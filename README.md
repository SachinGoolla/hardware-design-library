# 🚀 Digital Design & VLSI Components Library

Welcome to my comprehensive library of parameterized digital hardware components! This repository houses everything from basic combinatorial logic to complex, high-performance arithmetic units. 

The architectural focus here is on **high-speed synthesis targets (<333ps cycle time)**, **low logic depth**, and **rigorous verification standards** (targeting 95%+ coverage sign-off).

---

## 🌟 Project Status & Roadmap

### ✅ What I've Done (Implemented & Verified)
I have successfully architected and verified a core set of building blocks:
* **High-Speed Arithmetic Units:** 
  * **16-bit Pipelined MAC Unit:** Features a Radix-4 Booth Encoder, Wallace Tree reduction, and KSA final accumulation. *Recently achieved a 96.9% functional coverage sign-off!*
  * **32-bit Kogge-Stone Adder (KSA):** The performance king optimized for minimum logic depth and extreme frequencies.
  * **Carry-Lookahead Adders (CLA):** $O(\log N)$ carry chain optimizations.
* **Control & Routing Logic:** Balanced 2-level selection trees (Muxes), generic decoders, and priority encoders for minimum deterministic delay.
* **Specialized Detectors:** Single-cycle triple-one pattern detectors and parallel 8-bit pop-count modules.
* **Comparison Logic:** Parallel prefix comparators optimized for XOR equality checks.

### 🚧 What I'm Doing (Current Focus)
* **Rigorous Verification:** Expanding my 5-Pillar Verification methodology (Lint, Formal, Functional, Sim, Coverage) across all modules. 
* **Coverage Optimization:** Enhancing testbenches with Verilator to hit >95% coverage, intelligently using pragmas to separate architecturally "dead" bits from actual functional holes.
* **Formal Equivalence:** Proving mathematical truth for complex datapath elements (like multipliers and adders) using Formal Verification bounding.

### 🔮 What I'll Be Doing (Next Steps)
* **DSP & AI Integration:** Combining the MAC units and advanced Adders to form larger Neural Network accelerator tiles or systolic arrays.
* **Processor Datapaths:** Adapting the parallel prefix comparators and arithmetic units for a high-performance RISC-V execution pipeline.
* **ASIC Physical Design:** Pushing these modules through the OpenLane2 flow targeting Nangate 45nm and ASAP7 7nm PDKs to extract actual Power, Performance, and Area (PPA) metrics.

---

## 📂 Repository Structure

| Directory | Description |
| :--- | :--- |
| 📁 `rtl/` | Core Verilog/SystemVerilog source files |
| 📁 `tb/` | Python/C++ Testbenches for high-volume random and directed simulation |
| 📁 `verification/` | Formal verification scripts, environments, and coverage dashboards |
| 📁 `constraints/` | SDC files for timing and area constraints |
| 📁 `docs/` | Design specifications, verification journeys, and timing reports |

---

## 🛠️ Toolchain & Environment
This project avoids proprietary lock-in and relies entirely on a state-of-the-art Open-Source Hardware (OSH) ecosystem:

* **Simulation & Coverage:** `Verilator`
* **Formal Verification:** `SymbiYosys (SBY)` / `Z3`
* **Logic Synthesis:** `Yosys`
* **Physical Design:** `OpenROAD` / `OpenLane2`
* **Environment Management:** `Nix` / `Docker`

---

> *"Sometimes the coverage hole isn't in the test vectors, but in how we measure what is mathematically possible to toggle!"*  
> — *From the MAC Unit Verification Journey*
