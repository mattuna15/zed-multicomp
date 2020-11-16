-- This file is copyright by Grant Searle 2014
-- You are free to use this file in your own projects but must never charge for it nor use it without
-- acknowledgement.
-- Please ask permission from Grant Searle before republishing elsewhere.
-- If you use this file or any part of it, please add an acknowledgement to myself and
-- a link back to my main web site http://searle.hostei.com/grant/    
-- and to the "multicomp" page at http://searle.hostei.com/grant/Multicomp/index.html
--
-- Please check on the above web pages to see if there are any updates before using this file.
-- If for some reason the page is no longer available, please search for "Grant Searle"
-- on the internet to see if I have moved to another web hosting service.
--
-- Grant Searle
-- eMail address available on my main web page link above.

library ieee;
use ieee.std_logic_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.numeric_std.all;

entity Microcomputer is
	port(
		n_reset		: in std_logic;
		clk			: in std_logic;
		vgaClock    : in std_logic;


       -- SRAM pins
        MemAdr        : out   std_logic_vector(18 downto 0);  -- External SRAM address
        MemDB         : inout std_logic_vector(7 downto 0);   -- External SRAM data
        RamOEn        : out   std_logic;                      -- External SRAM OEn 
        RamWEn        : out   std_logic;                      -- External SRAM WEn 
        RamCEn        : out   std_logic;                      -- External SRAM CEn 
        
		
		rxd1			: in std_logic;
		
		rxd2    : in std_logic; 
        cts2    : in std_logic; 
        txd2    : out std_logic;
        rts2    : out std_logic
	);
end Microcomputer;

architecture struct of Microcomputer is

	signal n_WR							: std_logic := '0';
	signal n_RD							: std_logic :='0';
	signal cpuAddress					: std_logic_vector(31 downto 0) := (others => '0');
	signal cpuDataOut					: std_logic_vector(15 downto 0) := (others => '0');
	signal cpuDataIn					: std_logic_vector(15 downto 0) := (others => '0');
	signal basRomData					: std_logic_vector(15 downto 0);
    signal monRomData					: std_logic_vector(15 downto 0);

	signal n_interface2CS			: std_logic :='1';
	signal n_externalRamCS			: std_logic :='1';
	signal n_internalRam1CS			: std_logic :='1';
	signal n_internalRam2CS			: std_logic :='1';
	signal n_basRom1CS					: std_logic :='1';
    signal n_basRom2CS					: std_logic :='1';
    signal n_basRom3CS					: std_logic :='1';
    signal n_basRom4CS					: std_logic :='1';
    
	signal internalRam1DataOut		: std_logic_vector(7 downto 0);
	signal internalRam2DataOut		: std_logic_vector(7 downto 0);
	signal interface1DataOut		: std_logic_vector(7 downto 0);
	signal interface2DataOut		: std_logic_vector(7 downto 0);
	signal sdCardDataOut				: std_logic_vector(7 downto 0);

    signal n_MemRD						: std_logic :='1';	
	signal n_MemWR						: std_logic :='1';	

	signal n_int1						: std_logic :='1';	
	signal n_int2						: std_logic :='1';	
	

	signal n_basRomCS					: std_logic :='1';
	signal n_interface1CS			: std_logic :='1';
	signal n_sdCardCS					: std_logic :='1';

	signal serialClkCount			: std_logic_vector(15 downto 0) := (others => '0');
	signal cpuClkCount				: std_logic_vector(5 downto 0) := (others => '0');
	signal cpuClock				    : std_logic := '0';
	signal sdClkCount					: std_logic_vector(5 downto 0); 	
	signal serialClock				: std_logic := '0';
	signal sdClock						: std_logic;	
	
	signal    memAddress		:  std_logic_vector(15 downto 0);
	signal    cpu_as      :  std_logic; -- Address strobe
    signal    cpu_uds :  std_logic; -- upper data strobe
    signal    cpu_lds :  std_logic; -- lower data strobe
    signal    cpu_r_w :   std_logic; -- read(high)/write(low)
    signal    cpu_dtack :  std_logic; -- data transfer acknowledge
    
    type t_Vector is array (0 to 10) of std_logic_vector(15 downto 0);
    signal r_vec : t_Vector;
    signal vecAddress: integer := 0;

    signal int_out: std_logic_vector(2 downto 0) := "111";
    signal int_ack: std_logic := '0';
    
    signal regsel : std_logic := '0';
    
    
  COMPONENT fifo_generator_0
  PORT (
    wr_clk : IN STD_LOGIC;
    rd_clk : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC;
    rd_data_count : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
  );
  end COMPONENT fifo_generator_0;
    
	
begin
-- ____________________________________________________________________________________
-- CPU CHOICE GOES HERE
cpu1 : entity work.TG68
   port map
	(
		clk => cpuClock,
        reset => n_reset,
        clkena_in => '1',
        data_in => cpuDataIn,   
		IPL => "111",	-- For this simple demo we'll ignore interrupts
		dtack => cpu_dtack,
		addr => cpuAddress,
		as => cpu_as,
		data_out => cpuDataOut,
		rw => cpu_r_w,
		uds => cpu_uds,
		lds => cpu_lds
  );
	
	-- rom address
    memAddress <= std_logic_vector(to_unsigned(conv_integer(cpuAddress(15 downto 0)) / 2, memAddress'length)) ;
    
    -- vector address storage
    vecAddress <= conv_integer(cpuAddress(3 downto 0)) / 2 ;
    r_Vec(vecAddress) <= cpuDataOut when cpuAddress(31 downto 16) = X"FFFF" and cpu_r_w = '0' ;
    int_ack <= '1' when cpuAddress(31 downto 16) = X"FFFF" and cpu_r_w = '1' else '0'; -- acknowledge interrupts
    

-- ____________________________________________________________________________________
-- ROM GOES HERE	
  
	rom1 : entity work.rom -- 8 
	generic map (
	   G_ADDR_BITS => 13,
	   G_INIT_FILE => "D:/code/zed-68k/roms/monitor/monitor_0.hex"
	)
    port map(
        addr_i => memAddress(12 downto 0),
        clk_i => clk,
        data_o => monRomData(15 downto 8)
    );
    
    rom2 : entity work.rom -- 8 
	generic map (
	   G_ADDR_BITS => 13,
	   G_INIT_FILE => "D:/code/zed-68k/roms/monitor/monitor_1.hex"
	)
    port map(
        addr_i => memAddress(12 downto 0),
        clk_i => clk,
        data_o => monRomData(7 downto 0)
    );
    
    rom3 : entity work.rom -- 8 
	generic map (
	   G_ADDR_BITS => 13,
	   G_INIT_FILE => "D:/code/zed-68k/roms/ehbasic/basic_0.hex"
	)
    port map(
        addr_i => memAddress(12 downto 0),
        clk_i => clk,
        data_o => basRomData(15 downto 8)
    );
    
    rom4 : entity work.rom -- 8 
	generic map (
	   G_ADDR_BITS => 13,
	   G_INIT_FILE => "D:/code/zed-68k/roms/ehbasic/basic_1.hex"
	)
    port map(
        addr_i => memAddress(12 downto 0),
        clk_i => clk,
        data_o => basRomData(7 downto 0)
    );
-- ____________________________________________________________________________________
-- RAM GOES HERE

MemAdr(18 downto 0) <= cpuAddress(18 downto 0);
MemDB <= cpuDataOut(7 downto 0) when cpu_lds = '0' and cpu_r_w='0' else (others => 'Z');
RamWEn <= cpu_r_w;
RamOEn <= not cpu_r_w;
RamCEn <= n_externalRamCS;


ram1 : entity work.ram --64k
    generic map (
    G_INIT_FILE => "D:/code/zed-68k/roms/empty_1.hex",
      -- Number of bits in the address bus. The size of the memory will
      -- be 2**G_ADDR_BITS bytes.
      G_ADDR_BITS => 16
    )
   port map (
      clk_i => clk,

      -- Current address selected.
      addr_i => memAddress,

      -- Data contents at the selected address.
      -- Valid in same clock cycle.
      data_o  => internalRam1DataOut,

      -- New data to (optionally) be written to the selected address.
      data_i => cpuDataOut(15 downto 8),

      -- '1' indicates we wish to perform a write at the selected address.
      wren_i => not(cpu_r_w or n_internalRam1CS)
   );

   
   ram2 : entity work.ram --64k
    generic map (
    G_INIT_FILE => "D:/code/zed-68k/roms/empty_2.hex",
      -- Number of bits in the address bus. The size of the memory will
      -- be 2**G_ADDR_BITS bytes.
      G_ADDR_BITS => 16
    )
   port map (
      clk_i => clk,

      -- Current address selected.
      addr_i => memAddress,

      -- Data contents at the selected address.
      -- Valid in same clock cycle.
      data_o  => internalRam2DataOut,

      -- New data to (optionally) be written to the selected address.
      data_i => cpuDataOut(7 downto 0),

      -- '1' indicates we wish to perform a write at the selected address.
      wren_i => not(cpu_r_w or n_internalRam2CS)
   );

-- ____________________________________________________________________________________
-- INPUT/OUTPUT DEVICES GO HERE	

io1 : entity work.bufferedUART
port map(
    clk => clk,
    n_wr => n_interface1CS or cpuClock or cpu_r_w,
    n_rd => n_interface1CS or (not cpu_r_w) or cpu_as,
    n_int => n_int1,
    regSel => regsel,
    dataIn => cpuDataOut(7 downto 0),
    dataOut => interface1DataOut,
    rxClock => serialClock,
    txClock => serialClock,
    rxd => rxd2,
    txd => txd2,
    n_cts => cts2,
    n_dcd => '0',
    n_rts => rts2
);

-- ____________________________________________________________________________________
-- MEMORY READ/WRITE LOGIC GOES HERE
n_memRD <= not(cpuClock) nand cpu_r_w;
n_memWR <= not(cpuClock) nand (not cpu_r_w);
-- ____________________________________________________________________________________
-- CHIP SELECTS GO HERE

n_basRom1CS <= '0' when cpu_uds = '0' and cpuAddress(23 downto 20) = "1010" else '1'; --A00000-A0FFFF
n_basRom2CS <= '0' when cpu_lds = '0' and cpuAddress(23 downto 20) = "1010" else '1'; 
n_basRom3CS <= '0' when cpu_uds = '0' and cpuAddress(23 downto 20) = "1011" else '1'; --B00000-B0FFFF
n_basRom4CS <= '0' when cpu_lds = '0' and cpuAddress(23 downto 20) = "1011" else '1'; 

--terminal
n_interface1CS <= '0' when (cpuAddress = X"f0000b" or cpuAddress = X"f00009") and cpu_lds = '0' else '1';

-- block ram
n_internalRam1CS <= '0' when  cpuAddress <= X"FFFF" 
                    and cpu_uds = '0' else '1' ; --4k at bottom
n_internalRam2CS <= '0' when  cpuAddress <= X"FFFF" 
                    and cpu_lds = '0' else '1' ; --4k at bottom
                    
n_externalRamCS <=  '0' when cpuAddress > X"FFFF" and cpuAddress < X"A00000" and cpu_lds = '0' and n_reset = '1' else '1' ;

regsel <= '0' when cpuAddress = X"F00009" else '1';
-- ____________________________________________________________________________________
-- BUS ISOLATION GOES HERE

cpuDataIn(15 downto 8) 
<= 
X"00"
when n_interface1CS = '0'  and cpu_r_w = '1' and cpu_uds = '0' else
r_Vec(vecAddress)(15 downto 8)
when cpuAddress(31 downto 16) = X"FFFF" and cpu_r_w = '1' else
X"00"
when cpuAddress(31 downto 16) = X"FFFF" and cpu_r_w = '0'  else
monRomData(15 downto 8)
when n_basRom1CS = '0'  and cpu_r_w = '1' and cpu_uds = '0'  else
basRomData(15 downto 8)
when n_basRom3CS = '0'  and cpu_r_w = '1' and cpu_uds = '0'  else
internalRam1DataOut
when n_internalRam1CS= '0'and cpu_r_w = '1' and cpu_uds = '0' else
X"00" when n_externalRamCS= '0' else
X"00" when cpu_uds = '1' ;

cpuDataIn(7 downto 0) <=
interface1DataOut when n_interface1CS = '0' and cpu_r_w = '1' and cpu_lds = '0'  else
monRomData(7 downto 0)
when n_basRom2CS = '0'  and cpu_r_w = '1' and cpu_lds = '0' else 
basRomData(7 downto 0)
when n_basRom4CS = '0'  and cpu_r_w = '1' and cpu_lds = '0' else 
internalRam2DataOut
when n_internalRam2CS = '0' and cpu_r_w = '1' and cpu_lds = '0' else
"00000" & cpuAddress(3 downto 1)
when cpuAddress(31 downto 16) = X"FFFF" and cpu_r_w = '0' else 
r_Vec(vecAddress)(7 downto 0)
when cpuAddress(31 downto 16) = X"FFFF" and cpu_r_w = '1' else
MemDB when n_externalRamCS= '0' else
X"00" when cpu_lds = '1' ;

cpu_dtack <=  '0';

--not ram_ack when ram_cen = '0' else
--sd_ack when
--(cpuAddress = x"f4000c" or cpuAddress = x"f4000d") and cpu_r_w = '0' else 
--else '0';


-- SUB-CIRCUIT CLOCK SIGNALS
serialClock <= serialClkCount(15);
process (clk)
begin
if rising_edge(clk) then

if cpuClkCount < 1 then -- 4 = 10MHz, 3 = 12.5MHz, 2=16.6MHz, 1=25MHz
    cpuClkCount <= cpuClkCount + 1;
else
    cpuClkCount <= (others=>'0');
end if;

if cpuClkCount < 1 then -- 2 when 10MHz, 2 when 12.5MHz, 2 when 16.6MHz, 1 when 25MHz
    cpuClock <= '0';
else
    cpuClock <= '1';
end if;

if sdClkCount < 49 then -- 1MHz
sdClkCount <= sdClkCount + 1;
else
sdClkCount <= (others=>'0');
end if;
if sdClkCount < 25 then
sdClock <= '0';
else
sdClock <= '1';
end if;

-- Serial clock DDS
-- 50MHz master input clock:
-- Baud Increment
-- 115200 2416
-- 38400 805
-- 19200 403
-- 9600 201
-- 4800 101
-- 2400 50
serialClkCount <= serialClkCount + 2416;
end if;
end process;


end;
