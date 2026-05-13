## ---------------------------------------------------------
## 100 MHz System Clock
## ---------------------------------------------------------
set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.000 -waveform {0 5} [get_ports clk]

## ---------------------------------------------------------
## Reset Button (BTN0)
## Pressing button = logic 1
## Your Verilog uses active-LOW reset (!rst),
## so reset is active when button is NOT pressed.
## ---------------------------------------------------------
set_property -dict { PACKAGE_PIN D9 IOSTANDARD LVCMOS33 } [get_ports rst]

## ---------------------------------------------------------
## Highway Traffic Light -> RGB LED0
## highway[2] = Red
## highway[1] = Green
## highway[0] = Blue
## ---------------------------------------------------------
set_property -dict { PACKAGE_PIN G6 IOSTANDARD LVCMOS33 } [get_ports {highway[2]}]   ; # led0_r
set_property -dict { PACKAGE_PIN F6 IOSTANDARD LVCMOS33 } [get_ports {highway[1]}]   ; # led0_g
set_property -dict { PACKAGE_PIN E1 IOSTANDARD LVCMOS33 } [get_ports {highway[0]}]   ; # led0_b

## ---------------------------------------------------------
## Local Road Traffic Light -> RGB LED1
## local[2] = Red
## local[1] = Green
## local[0] = Blue
## ---------------------------------------------------------
set_property -dict { PACKAGE_PIN G3 IOSTANDARD LVCMOS33 } [get_ports {local[2]}]     ; # led1_r
set_property -dict { PACKAGE_PIN J4 IOSTANDARD LVCMOS33 } [get_ports {local[1]}]     ; # led1_g
set_property -dict { PACKAGE_PIN G4 IOSTANDARD LVCMOS33 } [get_ports {local[0]}]     ; # led1_b

## ---------------------------------------------------------
## Blinking Status LED -> LED0
## ---------------------------------------------------------
set_property -dict { PACKAGE_PIN H5 IOSTANDARD LVCMOS33 } [get_ports led]
