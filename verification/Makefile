# verification/Makefile
SIM ?= verilator
TOPLEVEL_LANG ?= verilog

# Point to your RTL
VERILOG_SOURCES += $(PWD)/../rtl/adder_parameterized.sv

# Top level module name
TOPLEVEL = adder_parameterized

# Python file name (without .py)
MODULE = test_adder

# Include cocotb's makefile logic
include $(shell cocotb-config --makefiles)/Makefile.sim
