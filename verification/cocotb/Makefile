SIM ?= verilator
TOPLEVEL_LANG ?= verilog
# Point to the RTL folder
VERILOG_SOURCES += $(PWD)/../../rtl/adder_parameterized.sv
TOPLEVEL = adder_parameterized
MODULE = test_adder_parameterized

include $(shell cocotb-config --makefiles)/Makefile.sim
