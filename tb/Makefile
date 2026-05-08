# tb/Makefile
RTL_DIR  = ../rtl
SIM_DIR  = ../sim
VERILATOR = /usr/local/bin/verilator

# Flags
FLAGS = --binary --trace --coverage -Wall -y $(RTL_DIR) -I$(RTL_DIR) -j 0

# Colors
CYAN   = \033[0;36m
YELLOW = \033[0;33m
NC     = \033[0m

TESTBENCH ?= tb_adder_parameterized
EXE_OUT    = ./obj_dir/V$(TESTBENCH)

.PHONY: compile run clean

compile:
	@mkdir -p $(SIM_DIR)
	@echo "$(YELLOW)Verilating $(TESTBENCH)...$(NC)"
	$(VERILATOR) $(FLAGS) --top-module $(TESTBENCH) $(TESTBENCH).sv

# Inside tb/Makefile
run: compile
	@echo "$(CYAN)Simulating $(TESTBENCH)...$(NC)"
	@# Use the P_ROOT variable we pass from the Root Makefile
	$(EXE_OUT) +verilator+coverage+file+$(P_ROOT)/logs/coverage.dat

clean:
	@rm -rf obj_dir $(SIM_DIR)/*.vcd
