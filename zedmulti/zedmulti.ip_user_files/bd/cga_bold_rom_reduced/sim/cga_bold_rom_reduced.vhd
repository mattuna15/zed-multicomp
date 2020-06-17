--Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
--Date        : Tue May 19 14:27:15 2020
--Host        : DESKTOP-ID021MN running 64-bit major release  (build 9200)
--Command     : generate_target cga_bold_rom_reduced.bd
--Design      : cga_bold_rom_reduced
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity cga_bold_rom_reduced is
  port (
    addra_0 : in STD_LOGIC_VECTOR ( 9 downto 0 );
    clka_0 : in STD_LOGIC;
    douta_0 : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of cga_bold_rom_reduced : entity is "cga_bold_rom_reduced,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=cga_bold_rom_reduced,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,da_ps7_cnt=1,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of cga_bold_rom_reduced : entity is "cga_bold_rom_reduced.hwdef";
end cga_bold_rom_reduced;

architecture STRUCTURE of cga_bold_rom_reduced is
  component cga_bold_rom_reduced_blk_mem_gen_0_0 is
  port (
    clka : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 9 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  end component cga_bold_rom_reduced_blk_mem_gen_0_0;
  signal addra_0_1 : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal blk_mem_gen_0_douta : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal clka_0_1 : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clka_0 : signal is "xilinx.com:signal:clock:1.0 CLK.CLKA_0 CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clka_0 : signal is "XIL_INTERFACENAME CLK.CLKA_0, CLK_DOMAIN cga_bold_rom_reduced_clka_0, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000";
begin
  addra_0_1(9 downto 0) <= addra_0(9 downto 0);
  clka_0_1 <= clka_0;
  douta_0(7 downto 0) <= blk_mem_gen_0_douta(7 downto 0);
blk_mem_gen_0: component cga_bold_rom_reduced_blk_mem_gen_0_0
     port map (
      addra(9 downto 0) => addra_0_1(9 downto 0),
      clka => clka_0_1,
      douta(7 downto 0) => blk_mem_gen_0_douta(7 downto 0)
    );
end STRUCTURE;
