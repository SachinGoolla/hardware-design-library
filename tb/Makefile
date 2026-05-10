# tb/Makefile
RTL_DIR   = ../rtl
SIM_DIR   = ../sim
VERILATOR = /usr/local/bin/verilator
P_ROOT    ?= ..

TOP       ?= mac_unit
TESTBENCH  = tb_$(TOP)
OBJ_DIR    = obj_dir_$(TOP)
EXE_OUT    = ./$(OBJ_DIR)/V$(TESTBENCH)

FLAGS = --binary --trace --coverage -Wall -Wno-TIMESCALEMOD -Wno-WIDTHTRUNC -Wno-UNUSEDSIGNAL -Wno-INITIALDLY -y $(RTL_DIR) -I.. -j 0 --Mdir $(OBJ_DIR)

CYAN   = \033[0;36m
YELLOW = \033[0;33m
GREEN  = \033[0;32m
NC     = \033[0m

.PHONY: compile run clean

compile: $(RTL_DIR)/$(TOP).sv $(TESTBENCH).sv
	@mkdir -p $(SIM_DIR)
	@mkdir -p $(P_ROOT)/logs
	@echo "$(YELLOW)Verilating $(TOP) Hierarchy...$(NC)"
	@$(VERILATOR) $(FLAGS) --top-module $(TESTBENCH) $(TESTBENCH).sv > /dev/null 2>&1

run: compile
	@echo "$(CYAN)Simulating $(TOP) Pipeline...$(NC)"
	@if $(EXE_OUT) +verilator+coverage+file+$(P_ROOT)/logs/coverage.dat > /dev/null 2>&1; then \
		printf "$(GREEN)   ✓ PASS: Vectors Exhausted$(NC)\n"; \
	else \
		printf "\033[0;31m   ❌ FAIL: Simulation Error\033[0m\n"; \
		exit 1; \
	fi

clean:
	@rm -rf obj_dir* $(SIM_DIR)/*.vcd
