# 3.0 GHz Target
create_clock -name clk -period 0.333 [get_ports clk_i]

# Apply delays only to DATA ports, not the clock port
set_input_delay 0.04 [get_ports {a_i[*] b_i[*] cin_i rst_ni}] -clock clk
set_output_delay 0.04 [get_ports {sum_o[*] cout_o}] -clock clk
