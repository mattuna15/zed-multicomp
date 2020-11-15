----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/16/2020 04:43:37 PM
-- Design Name: 
-- Module Name: multicomp_wrapper - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multicomp_wrapper is
port(
        sysclk        : in    std_logic;                      -- 12 Mhz clock module input        PACKAGE_PIN L17
        btn           : in    std_logic_vector(1 downto 0);   -- normally low, high when pushed   PACKAGE_PIN B18, A18 
        led           : out   std_logic_vector(1 downto 0);   -- high lights the green led        PACKAGE_PIN C16, A17
        led0_b        : out   std_logic;                      -- low lights the RGB blue LED      PACKAGE_PIN B17
        led0_g        : out   std_logic;                      -- low lights the RGB green LED     PACKAGE_PIN B16
        led0_r        : out   std_logic;                      -- low lights the RGB red LED       PACKAGE_PIN C17
        
        -- SRAM pins
        MemAdr        : out   std_logic_vector(18 downto 0);  -- External SRAM address
        MemDB         : inout std_logic_vector(7 downto 0);   -- External SRAM data
        RamOEn        : out   std_logic;                      -- External SRAM OEn 
        RamWEn        : out   std_logic;                      -- External SRAM WEn 
        RamCEn        : out   std_logic;                      -- External SRAM CEn 
        
        -- GP IO pins
        IOGroupA      : inout std_logic_vector(20 downto 0);  -- module pins 23..17, 14..1
        IOGroupB      : inout std_logic_vector(22 downto 0);  -- module pins 23..17, 14..1
        ja            : inout std_logic_vector(7 downto 0);   -- PMOD pins 10..7, 4..1
        
        uart_txd_in   : in    std_logic;                      -- FT2232HQ UART TxD --> FPGA RxD   PACKAGE_PIN J17
        uart_rxd_out  : out   std_logic                       -- FT2232HQ UART RxD <-- FPGA TxD   PACKAGE_PIN J18 

	);
end multicomp_wrapper;

architecture Behavioral of multicomp_wrapper is

    signal clk100 : std_logic := '0';
    signal clk50 : std_logic := '0';
    signal clk25 : std_logic := '0';
    signal resetn : std_logic := '0';
    signal locked : std_logic := '0';
    
    
   component clk_wiz_0 is
   port  (
      clk_in1  : in std_logic;
      clk50 : out std_logic; 
      clk25  :out  std_logic;
      clk100 : out std_logic;
      resetn : in std_logic;
      locked : out std_logic
   ); -- clk_inst
   end component;
   
begin

   --------------------------------------------------
   -- Instantiate Clock generation
   --------------------------------------------------
   
   resetn <=  not btn(0);
   
   led(0) <= resetn;
   led(1) <= locked;

   clk_inst :  clk_wiz_0
   port map (
      clk_in1  => sysclk,
      clk50  => clk50, 
      clk25  => clk25,
      clk100 => clk100,
      resetn => resetn,
      locked => locked
   ); -- clk_inst
   
   

 computer: entity work.Microcomputer 
    port map (
        
        n_reset	=> resetn,
		clk	=> clk50,
		vgaClock => clk25,
		-- SRAM pins
        MemAdr   => MemAdr, -- External SRAM address
        MemDB    => MemDB,   -- External SRAM data
        RamOEn   => RamOEn,                      -- External SRAM OEn 
        RamWEn   => RamWEn,                     -- External SRAM WEn 
        RamCEn   => RamCEn,                      -- External SRAM CEn 
        
		rxd1 => uart_txd_in,
		txd1 => uart_rxd_out,
		rts1 => open

    );


end Behavioral;
