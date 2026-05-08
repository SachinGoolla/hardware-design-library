# 1. Load PDK and Netlist
read_liberty /home/dada/pdks/nangate45/libs.ref/liberty/NangateOpenCellLibrary_typical.lib
read_verilog syn/outputs/adder_parameterized_gates.v
link_design adder_parameterized
read_sdc constraints/adder_parameterized.sdc

# 2. Set Activity Factor (Estimate: 10% of bits flip every cycle)
set_driving_cell -lib_cell INV_X1 [all_inputs]
set_load 0.05 [all_outputs]

# 3. POWER ANALYSIS
puts "--- POWER REPORT ---"
report_power > reports/power_report.txt
report_power

# 4. SLEW/NOISE PRE-CHECK (Looking for electrical weak spots)
puts "--- ELECTRICAL/NOISE PRE-CHECK ---"
report_check_types -max_slew -max_capacitance > reports/noise_precheck.txt
report_checks -path_delay max -format full_clock_expanded > reports/timing_final.txt

puts "Sign-off reports generated in the reports/ directory."
