# 1. Load the Nangate 45nm Timing Models
read_liberty $::env(HOME)/pdks/nangate45/libs.ref/liberty/NangateOpenCellLibrary_typical.lib

# 2. Read the Synthesized Gate-Level Netlist
read_verilog syn/outputs/adder_parameterized_gates.v

# 3. Define the Top Module
link_design adder_parameterized

# 4. Apply the Timing Constraints (The 1.0ns deadline)
read_sdc constraints/adder_parameterized.sdc

# 5. Report the Worst Case Timing Paths
report_checks -path_delay max -format full_clock_expanded
report_tns
report_wns
