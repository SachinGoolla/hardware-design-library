# Read the Nangate 45nm Library
read_liberty -lib lib/NangateOpenCellLibrary_typical.lib

# Read the KSA RTL
read_verilog -sv rtl/adder_ksa_32bit.sv

# ... (Read liberty and RTL as before) ...

hierarchy -top adder_ksa_32bit
proc; opt; fsm; opt; techmap; opt

# BAN X1 cells to force high drive strength
# We do this by setting the 'dont_use' attribute on X1 variants
# (Note: This depends on exactly which cells are in your .lib)
# For now, let's use the -D flag more aggressively.

dfflibmap -liberty lib/NangateOpenCellLibrary_typical.lib

# -D 150: Force the tool to over-optimize to clear the remaining 30ps
abc -liberty lib/NangateOpenCellLibrary_typical.lib -D 150 -constr syn/constraints.abc
# 4. Clean up and write the netlist
clean
write_verilog syn/outputs/adder_ksa_32bit_45nm.v
