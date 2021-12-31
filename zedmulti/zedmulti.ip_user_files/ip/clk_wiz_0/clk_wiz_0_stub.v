// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (lin64) Build 3247384 Thu Jun 10 19:36:07 MDT 2021
// Date        : Wed Dec 29 13:15:48 2021
// Host        : ubuntu running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/mattp/zed-multicomp/zedmulti/zedmulti.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clk50, clk25, clk100, resetn, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk50,clk25,clk100,resetn,locked,clk_in1" */;
  output clk50;
  output clk25;
  output clk100;
  input resetn;
  output locked;
  input clk_in1;
endmodule
