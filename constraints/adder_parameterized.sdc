# --- SDC Timing Constraints ---
# New Target: 500 MHz (2.0ns Period)
create_clock -name virtual_clk -period 2.0

# Keep 20% budget for I/O (0.4ns now)
set_input_delay  0.4 [all_inputs]  -clock virtual_clk
set_output_delay 0.4 [all_outputs] -clock virtual_clk

set_max_fanout 20 [current_design]
set_load 0.05 [all_outputs]
