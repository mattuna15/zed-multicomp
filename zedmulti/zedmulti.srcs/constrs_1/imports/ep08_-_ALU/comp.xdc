# This file is specific for the Zedboard board.


set_property -dict {PACKAGE_PIN U20 IOSTANDARD LVCMOS33} [get_ports videoR1]
set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33} [get_ports videoR0]
set_property -dict {PACKAGE_PIN AA22 IOSTANDARD LVCMOS33} [get_ports videoG1]
set_property -dict {PACKAGE_PIN AB22 IOSTANDARD LVCMOS33} [get_ports videoG0]
set_property -dict {PACKAGE_PIN Y20 IOSTANDARD LVCMOS33} [get_ports videoB1]
set_property -dict {PACKAGE_PIN Y21 IOSTANDARD LVCMOS33} [get_ports videoB0]
set_property -dict {PACKAGE_PIN AA19 IOSTANDARD LVCMOS33} [get_ports hSync]
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33} [get_ports vSync]


#NET LD0           LOC = T22  | IOSTANDARD=LVCMOS33;  # "LD0"
#NET LD1           LOC = T21  | IOSTANDARD=LVCMOS33;  # "LD1"
#NET LD2           LOC = U22  | IOSTANDARD=LVCMOS33;  # "LD2"
#NET LD3           LOC = U21  | IOSTANDARD=LVCMOS33;  # "LD3"
#NET LD4           LOC = V22  | IOSTANDARD=LVCMOS33;  # "LD4"
#NET LD5           LOC = W22  | IOSTANDARD=LVCMOS33;  # "LD5"
#NET LD6           LOC = U19  | IOSTANDARD=LVCMOS33;  # "LD6"
#NET LD7           LOC = U14  | IOSTANDARD=LVCMOS33;  # "LD7"


#NET BTNC          LOC = P16  | IOSTANDARD=LVCMOS18;  # "BTNC"
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33} [get_ports reset]
#JA PMOD has a ps2 pmod
set_property -dict {PACKAGE_PIN Y11 IOSTANDARD LVCMOS33} [get_ports ps2Data] 
set_property -dict {PACKAGE_PIN Y10 IOSTANDARD LVCMOS33} [get_ports ps2Clk]



set_property PULLUP true [get_ports ps2Clk]
set_property PULLUP true [get_ports ps2Data]

# Configuration Bank Voltage Select
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

set_property PACKAGE_PIN Y9 [get_ports sys_clock]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clock]

# Clock definition
create_clock -name sys_clk -period 10.00 [get_ports {sys_clock}];                          # 100 MHz
