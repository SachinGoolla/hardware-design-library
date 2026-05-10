# AGNOSTIC STA SCRIPT
set TOP_MODULE $env(TOP_MODULE)

read_liberty lib/NangateOpenCellLibrary_typical.lib
read_verilog outputs/${TOP_MODULE}_netlist.v
link_design ${TOP_MODULE}

create_clock -name clk -period 0.332
set_input_delay 0.050 -clock clk [all_inputs]
set_output_delay 0.050 -clock clk [all_outputs]

# 5. Report the Worst Case Timing Paths
report_checks -path_delay max -format full_clock_expanded
report_worst_slack -max
report_tns
report_wns
