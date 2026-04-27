# RTL Design Library: Technical Specifications

This directory contains SystemVerilog implementations of core digital components. All designs are architected with a focus on high-speed synthesis targets ($<333ps$ cycle time) and low logic depth.

---

## ⚡ Arithmetic Units

### adder_cla_32b.sv & adder_carry_lookahead.v
* **Architecture:** Carry-Lookahead (CLA).
* **Design Choice:** I moved away from Ripple-Carry to a CLA structure to break the $O(N)$ carry chain.
* **Performance:** By calculating carry-generate and propagate signals in parallel, I reduced logic depth to $O(\log N)$, essential for 3GHz timing closure.

### adder_ksa_32bit.sv
* **Architecture:** Kogge-Stone Prefix Adder.
* **Design Choice:** This is the "performance king" of my library. I chose KSA for its minimum logic depth and uniform fan-out.
* **Trade-off:** It uses significantly more wiring area than the CLA, but it is the only way to hit extreme frequency targets in 45nm/7nm nodes.

### mac_unit.v
* **Architecture:** Pipelined Multiply-Accumulate.
* **Design Choice:** I utilized a multi-stage pipeline to isolate the high-delay multiplier logic from the accumulator.
* **Intent:** Critical for DSP and AI acceleration tasks where throughput is prioritized over latency.

---

## 🚦 Control & Routing Logic

### mux_32b_4to1.sv & mux_onehot_4to1.sv
* **Architecture:** 2-Level Selection Tree.
* **Design Choice:** Rather than a priority-encoded `if-else` chain, I implemented a balanced tree.
* **Performance:** This ensures a fixed, minimum delay from any input to the output, preventing "late-arriving signal" bottlenecks in the datapath.

### decoder_generic.v & priority_encoder.v
* **Design Choice:** Parameterized the widths to support varied instruction decoding and interrupt handling.
* **Intent:** The priority encoder is optimized for "find-first" operations in scheduler logic.

---

## 🔍 Specialized Detectors

### triple_one_detector.sv
* **Architecture:** Bitwise Sliding Window.
* **Design Choice:** I avoided a sequential State Machine in favor of a purely combinatorial bitwise AND/Shift approach.
* **Benefit:** Detects the pattern across the entire 10-bit vector in a single clock cycle with zero sequential overhead.

### pop_count_8bit.v
* **Architecture:** Combinatorial Adder Tree.
* **Design Choice:** Implemented as a parallel bit-summation.
* **Intent:** Useful for error correction codes (ECC) and cryptographic weights where bit-density must be calculated at line rate.

---

## ⚖️ Comparison Units

### comparator_32b.sv & comparator_32bit_fast.sv
* **Architecture:** Parallel Prefix Comparison.
* **Design Choice:** I prioritized bitwise XOR equality checks to allow the synthesizer to map to dedicated high-speed comparison cells in the Nangate/ASAP7 libraries.
* **Intent:** Targeted for the Branch Execution Unit in a RISC-V pipeline where comparison results are on the critical path.
