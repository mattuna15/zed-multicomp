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
        sys_clock : in STD_LOGIC;
        reset : in STD_LOGIC;
		videoR0		: out std_logic;
		videoG0		: out std_logic;
		videoB0		: out std_logic;
		videoR1		: out std_logic;
		videoG1		: out std_logic;
		videoB1		: out std_logic;
		hSync			: out std_logic;
		vSync			: out std_logic;

		ps2Clk		: inout std_logic;
		ps2Data		: inout std_logic;
		sdCS			: out std_logic;
		sdMOSI		: out std_logic;
		sdMISO		: in std_logic;
		sdSCLK		: out std_logic;
		driveLED		: out std_logic :='1';
		
		rxd1			: in std_logic;
		txd1			: out std_logic;
		rts1			: out std_logic	

	);
end multicomp_wrapper;

architecture Behavioral of multicomp_wrapper is

    signal clk50 : std_logic := '0';
    signal clk25 : std_logic := '0';

begin

   --------------------------------------------------
   -- Instantiate Clock generation
   --------------------------------------------------

   clk_inst : entity work.clk_wiz_0_clk_wiz
   port map (
      clk_in1  => sys_clock,
      eth_clk  => clk50, 
      vga_clk  => clk25,
      main_clk => open
   ); -- clk_inst

 computer: entity work.Microcomputer 
    port map (
        
        n_reset	=> not reset,
		clk	=> clk50,
		vgaClock => clk25,
		cpuClock => clk25,
		videoR0	 => videoR0,
		videoG0	=> videoG0,
		videoB0	=> videoB0,
		videoR1	=> videoR1,
		videoG1	=> videoG1,
		videoB1	=> videoB1,
		hSync	=> hSync,
		vSync	=> vSync,

		ps2Clk => ps2Clk,
		ps2Data	=> ps2Data,
		
		sdCS => sdCS,
		sdMOSI => sdMOSI,
		sdMISO => sdMISO,
		sdSCLK => sdSCLK,
		driveLED => driveLED,
		
		rxd1 => rxd1,
		txd1 => txd1,
		rts1 => rts1

    );


end Behavioral;
