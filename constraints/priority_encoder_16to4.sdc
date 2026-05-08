# 3 GHz Target (332ps)
set period 0.332

# Create a virtual clock to represent the system heartbeat
create_clock -name clk -period $period

# Assume 50ps delay for data to arrive from previous registers
set_input_delay 0.050 -clock clk [all_inputs]

# Assume 50ps setup time for the next stage's registers
set_output_delay 0.050 -clock clk [all_outputs]
