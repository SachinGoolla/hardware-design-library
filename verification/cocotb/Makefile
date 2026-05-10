SIM ?= verilator
TOPLEVEL_LANG ?= verilog

# 1. Use the TOP variable passed from the root (defaults to mac_unit)
TOP ?= mac_unit

# 2. Point to the specific RTL file
VERILOG_SOURCES += $(PWD)/../../rtl/$(TOP).sv

# 3. Match the TOP module name and the Python testbench filename (tb_mac_unit.py)
TOPLEVEL = $(TOP)
MODULE = tb_$(TOP)

# 4. THE FIX: Tell Verilator to include the root directory in its search path
# This allows `include "rtl/..."` to resolve correctly from any subfolder.
# THE GENTLEMAN'S SEARCH PATH:
# We include the root AND the rtl folder directly.
EXTRA_ARGS += -I$(PWD)/../../ -I$(PWD)/../../rtl

include $(shell cocotb-config --makefiles)/Makefile.sim
