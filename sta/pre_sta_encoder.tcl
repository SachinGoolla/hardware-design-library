# 1. Load the 45nm Physics Library
read_liberty /home/dada/pdks/nangate45/libs.ref/liberty/NangateOpenCellLibrary_typical.lib

# 2. Load our synthesized Gates
read_verilog ../syn/outputs/priority_encoder_16to4_45nm.v
link_design priority_encoder_16to4

# 3. Load the Speed Target (1.0ns)
read_sdc ../constraints/priority_encoder_16to4.sdc

# 4. Generate the Timing Report
report_checks -path_delay max -fields {net cap slew delay arrival} -format full
exit
