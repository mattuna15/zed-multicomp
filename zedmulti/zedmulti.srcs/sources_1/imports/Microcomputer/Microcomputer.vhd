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
		txd1			: out std_logic;
		rts1			: out std_logic	
	);
end Microcomputer;

architecture struct of Microcomputer is

	signal n_WR							: std_logic := '0';
	signal n_RD							: std_logic :='0';
	signal cpuAddress					: std_logic_vector(15 downto 0) := (others => '0');
	signal cpuDataOut					: std_logic_vector(7 downto 0) := (others => '0');
	signal cpuDataIn					: std_logic_vector(7 downto 0) := (others => '0');

	signal basRomData					: std_logic_vector(7 downto 0);
	signal internalRam1DataOut		: std_logic_vector(7 downto 0);
	signal internalRam2DataOut		: std_logic_vector(7 downto 0);
	signal interface1DataOut		: std_logic_vector(7 downto 0);
	signal interface2DataOut		: std_logic_vector(7 downto 0);
	signal sdCardDataOut				: std_logic_vector(7 downto 0);

	signal n_memWR						: std_logic :='1';
	signal n_memRD 					: std_logic :='1';

	signal n_ioWR						: std_logic :='1';
	signal n_ioRD 						: std_logic :='1';
	
	signal n_MREQ						: std_logic :='1';
	signal n_IORQ						: std_logic :='1';	

	signal n_int1						: std_logic :='1';	
	signal n_int2						: std_logic :='1';	
	
	signal n_externalRamCS			: std_logic :='1';
	signal n_internalRam1CS			: std_logic :='1';
	signal n_internalRam2CS			: std_logic :='1';
	signal n_basRomCS					: std_logic :='1';
	signal n_interface1CS			: std_logic :='1';
	signal n_interface2CS			: std_logic :='1';
	signal n_sdCardCS					: std_logic :='1';

	signal serialClkCount			: std_logic_vector(15 downto 0) := (others => '0');
	signal cpuClkCount				: std_logic_vector(5 downto 0) := (others => '0');
	signal cpuClock				    : std_logic := '0';
	signal sdClkCount					: std_logic_vector(5 downto 0); 	
	signal serialClock				: std_logic := '0';
	signal sdClock						: std_logic;	
	signal topAddress               : std_logic_vector(7 downto 0);
	
begin
-- ____________________________________________________________________________________
-- CPU CHOICE GOES HERE
cpu1 : entity work.cpu09
port map(
clk => not(cpuClock),
rst => not n_reset,
rw => n_WR,
addr => cpuAddress,
data_in => cpuDataIn,
data_out => cpuDataOut,
halt => '0',
hold => '0',
irq => '0',
firq => '0',
nmi => '0');


-- ____________________________________________________________________________________
-- ROM GOES HERE	
	rom1 : entity work.rom -- 8KB BASIC
	generic map (
	   G_ADDR_BITS => 13,
	   G_INIT_FILE => "/home/mattp/zed-multicomp/ROMS/6809/bas_6809.hex"
	)
    port map(
        addr_i => cpuAddress(12 downto 0),
        clk_i => clk,
        data_o => basRomData
    );
-- ____________________________________________________________________________________
-- RAM GOES HERE

MemAdr(18 downto 16) <= "000";
MemAdr(15 downto 0) <= cpuAddress(15 downto 0);
MemDB <= cpuDataOut when n_WR='0' else (others => 'Z');
RamWEn <= n_memWR;
RamOEn <= n_memRD;
RamCEn <= n_externalRamCS;

-- ____________________________________________________________________________________
-- INPUT/OUTPUT DEVICES GO HERE	

io1 : entity work.bufferedUART
port map(
clk => clk,
n_wr => n_interface1CS or cpuClock or n_WR,
n_rd => n_interface1CS or cpuClock or (not n_WR),
n_int => n_int1,
regSel => cpuAddress(0),
dataIn => cpuDataOut,
dataOut => interface1DataOut,
rxClock => serialClock,
txClock => serialClock,
rxd => rxd1,
txd => txd1,
n_cts => '0',
n_dcd => '0',
n_rts => rts1
);

-- ____________________________________________________________________________________
-- MEMORY READ/WRITE LOGIC GOES HERE
n_memRD <= not(cpuClock) nand n_WR;
n_memWR <= not(cpuClock) nand (not n_WR);
-- ____________________________________________________________________________________
-- CHIP SELECTS GO HERE

n_basRomCS <= '0' when cpuAddress(15 downto 13) = "111" else '1'; --8K at top of memory
n_interface1CS <= '0' when cpuAddress(15 downto 1) = "111111111101000" else '1'; -- 2 bytes FFD0-FFD1
n_sdCardCS <= '0' when cpuAddress(15 downto 3) = "1111111111011" else '1'; -- 8 bytes FFD8-FFDF
n_interface2CS <= '0' when cpuAddress(15 downto 1) = "111111111101001" else '1'; -- 2 bytes FFD2-FFD3
n_externalRamCS<= not n_basRomCS;

-- ____________________________________________________________________________________
-- BUS ISOLATION GOES HERE

cpuDataIn <=
interface1DataOut when n_interface1CS = '0' else
interface2DataOut when n_interface2CS = '0' else
sdCardDataOut when n_sdCardCS = '0' else
basRomData when n_basRomCS = '0' else
MemDB when n_externalRamCS= '0' else
x"FF";

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
serialClkCount <= serialClkCount + 201;
end if;
end process;


end;
