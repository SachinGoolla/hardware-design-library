# Load the 45nm library
read_liberty lib/NangateOpenCellLibrary_typical.lib

# Load the synthesized netlist we just made
read_verilog syn/outputs/adder_ksa_32bit_45nm.v
link_design adder_ksa_32bit

# Apply the 3 GHz constraint
read_sdc constraints/adder_ksa_32bit.sdc

# Report the worst-case timing path
report_checks -path_delay max -format full_clock_expanded
