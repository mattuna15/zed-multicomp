library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;

entity main_tb is
end main_tb;

architecture structural of main_tb is

   -- Clock
   signal main_clk  : std_logic := '0';
   signal reset : std_logic := '0' ;
   signal start_up  : std_logic := '0';
   
begin
   
   --------------------------------------------------
   -- Generate clock
   --------------------------------------------------

   main_clk <= not main_clk after 42ns;
   
   --------------------------------------------------
   -- Instantiate MAIN
   --------------------------------------------------

   main_inst : entity work.multicomp_wrapper

   port map (
        sysclk => main_clk,
        btn => "00",
        uart_txd_in => '0',
        uart_rxd_out => open
   ); -- main_inst
   
end architecture structural;

