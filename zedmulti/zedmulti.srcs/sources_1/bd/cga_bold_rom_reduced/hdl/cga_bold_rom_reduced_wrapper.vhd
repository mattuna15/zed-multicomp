--Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
--Date        : Tue May 19 14:27:15 2020
--Host        : DESKTOP-ID021MN running 64-bit major release  (build 9200)
--Command     : generate_target cga_bold_rom_reduced_wrapper.bd
--Design      : cga_bold_rom_reduced_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity cga_bold_rom_reduced_wrapper is
  port (
    addra_0 : in STD_LOGIC_VECTOR ( 9 downto 0 );
    clka_0 : in STD_LOGIC;
    douta_0 : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
end cga_bold_rom_reduced_wrapper;

architecture STRUCTURE of cga_bold_rom_reduced_wrapper is
  component cga_bold_rom_reduced is
  port (
    clka_0 : in STD_LOGIC;
    douta_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    addra_0 : in STD_LOGIC_VECTOR ( 9 downto 0 )
  );
  end component cga_bold_rom_reduced;
begin
cga_bold_rom_reduced_i: component cga_bold_rom_reduced
     port map (
      addra_0(9 downto 0) => addra_0(9 downto 0),
      clka_0 => clka_0,
      douta_0(7 downto 0) => douta_0(7 downto 0)
    );
end STRUCTURE;
