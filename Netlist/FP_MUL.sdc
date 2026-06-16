# ###################################################################
# Created by Genus(TM) Synthesis Solution 20.10-p001_1 on Thu May 14 15:45:51 CST 2026
# ###################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design FP_MUL

create_clock -name "CLK" -period 0.5 -waveform {0.0 0.25} [get_ports CLK]
set_load -pin_load 0.1 [get_ports {DATA_OUT[7]}]
set_load -pin_load 0.1 [get_ports {DATA_OUT[6]}]
set_load -pin_load 0.1 [get_ports {DATA_OUT[5]}]
set_load -pin_load 0.1 [get_ports {DATA_OUT[4]}]
set_load -pin_load 0.1 [get_ports {DATA_OUT[3]}]
set_load -pin_load 0.1 [get_ports {DATA_OUT[2]}]
set_load -pin_load 0.1 [get_ports {DATA_OUT[1]}]
set_load -pin_load 0.1 [get_ports {DATA_OUT[0]}]
set_load -pin_load 0.1 [get_ports READY]
set_clock_gating_check -setup 0.0
set_input_delay -clock [get_clocks CLK] -add_delay 0.25 [get_ports RESET]
set_input_delay -clock [get_clocks CLK] -add_delay 0.25 [get_ports ENABLE]
set_input_delay -clock [get_clocks CLK] -add_delay 0.25 [get_ports {DATA_IN[7]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.25 [get_ports {DATA_IN[6]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.25 [get_ports {DATA_IN[5]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.25 [get_ports {DATA_IN[4]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.25 [get_ports {DATA_IN[3]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.25 [get_ports {DATA_IN[2]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.25 [get_ports {DATA_IN[1]}]
set_input_delay -clock [get_clocks CLK] -add_delay 0.25 [get_ports {DATA_IN[0]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.25 [get_ports {DATA_OUT[7]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.25 [get_ports {DATA_OUT[6]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.25 [get_ports {DATA_OUT[5]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.25 [get_ports {DATA_OUT[4]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.25 [get_ports {DATA_OUT[3]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.25 [get_ports {DATA_OUT[2]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.25 [get_ports {DATA_OUT[1]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.25 [get_ports {DATA_OUT[0]}]
set_output_delay -clock [get_clocks CLK] -add_delay 0.25 [get_ports READY]