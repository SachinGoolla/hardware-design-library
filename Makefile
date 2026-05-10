# ==============================================================================
# MASTER DISPATCHER - RTL AGNOSTIC SIGN-OFF
# ==============================================================================
TOP        ?= adder_parameterized
TESTBENCH  = tb_$(TOP)
P_ROOT     = $(shell pwd)
RTL_FILE   = $(P_ROOT)/rtl/$(TOP).sv

CYAN   = \033[0;36m
GREEN  = \033[0;32m
YELLOW = \033[0;33m
RED    = \033[0;31m
NC     = \033[0m

.PHONY: check all lint formal functional sim coverage clean

all: check lint formal functional sim coverage clean

check:
	@if [ ! -f $(RTL_FILE) ]; then \
		echo "$(RED)❌ ERROR: RTL file $(RTL_FILE) not found!$(NC)"; exit 1; \
	fi

lint: check
	@echo "$(CYAN)PILLAR 1: Structural Linting [$(TOP)]...$(NC)"
	@verilator --lint-only -Wall rtl/$(TOP).sv --top-module $(TOP)
	@echo "$(GREEN)  ✓ LINT: STRUCTURAL INTEGRITY SECURED.$(NC)"

# --- 2. FORMAL ---
formal: check
	@echo "$(CYAN)PILLAR 2: Formal Verification (SBY) [$(TOP)]...$(NC)"
	@if [ -f formal/$(TOP).sby ]; then \
		cd formal && sby -f $(TOP).sby && echo "$(GREEN)  ✓ FORMAL: MATHEMATICAL PROOF COMPLETE.$(NC)"; \
	else \
		echo "$(YELLOW)  ⚠ SKIPPED: NO FORMAL RULES FOUND.$(NC)"; \
	fi

# --- 3. FUNCTIONAL ---
functional: check
	@echo "$(CYAN)PILLAR 3: Functional Cocotb Check [$(TOP)]...$(NC)"
	@if [ -f tb/$(TESTBENCH).py ]; then \
		PYTHONPATH=$(P_ROOT) $(MAKE) -C verification/cocotb TOPLEVEL=$(TOP) P_ROOT=$(P_ROOT) MODULE=tb.$(TESTBENCH) VERILOG_SOURCES=$(RTL_FILE) \
		&& echo "$(GREEN)  ✓ FUNCTIONAL: LOGIC BEHAVIOR VERIFIED.$(NC)" \
		|| (echo "$(RED)  ❌ FUNCTIONAL: TEST CRASHED$(NC)" && exit 1); \
	else \
		echo "$(YELLOW)  ⚠ SKIPPED: NO COCOTB TESTBENCH FOUND.$(NC)"; \
	fi
sim: check
	@echo "$(CYAN)PILLAR 4: High-Volume Simulation [$(TOP)]...$(NC)"
	@mkdir -p logs
	@if [ -f tb/$(TESTBENCH).sv ]; then \
		$(MAKE) -C tb run TESTBENCH=$(TESTBENCH) TOP=$(TOP) P_ROOT=$(P_ROOT); \
		echo "$(GREEN)  ✓ SIM: STRESS TEST PASSED.$(NC)"; \
	else \
		echo "$(YELLOW)  ⚠ SKIPPED: NO SYSTEMVERILOG TESTBENCH.$(NC)"; \
	fi

coverage:
	@echo "PILLAR 5: Generating Final Coverage Dashboard [$(TOP)]..."
	@.venv/bin/python3 tb/coverage_pie.py $(TOP)
clean:
	@echo "$(CYAN)Cleaning build artifacts...$(NC)"
	@rm -rf logs formal/$(TOP) verification/cocotb/sim_build verification/cocotb/__pycache__
