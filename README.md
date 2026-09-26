# Programmable IIR Filters for Software-Defined Radio on FPGA

A Verilog + MATLAB implementation of **programmable, fixed-point Infinite Impulse Response (IIR) filters** for Software-Defined Radio (SDR) applications, designed for real-time interference suppression on wideband signals with minimal FPGA resource usage.

This repository accompanies the report *"Implementation of Programmable IIR Filters for Software-Defined Radio on FPGA"* (`implementation-report.pdf`) and the earlier `Preliminary Design Report.docx`, and includes a short demo video (`demo-video/`).

> Muhammad Omais · Ahmed Raziullah
> School of Electrical Engineering and Computer Science (SEECS), National University of Sciences and Technology (NUST), Islamabad, Pakistan

---

## Table of Contents

- [Overview](#overview)
- [Project Motivation](#project-motivation)
- [Key Technical Objectives](#key-technical-objectives)
- [System Architecture](#system-architecture)
- [Fixed-Point Arithmetic](#fixed-point-arithmetic)
- [Repository Structure](#repository-structure)
- [Design Methodology](#design-methodology)
- [Testing and Validation Workflow](#testing-and-validation-workflow)
- [Results](#results)
- [Requirements](#requirements)
- [How to Run](#how-to-run)
- [Future Work](#future-work)
- [Project Report and Demo](#project-report-and-demo)
- [References](#references)
- [Authors](#authors)

---

## Overview

Software-Defined Radio (SDR) systems need filters that can be reconfigured on the fly to match changing communication channels and interference conditions. This project implements a **programmable IIR filter architecture** on FPGA using Verilog, with an **Elliptic filter response** chosen for its sharp passband-to-stopband transition at low filter order — critical for real-time, resource-constrained hardware.

The filter is realized in **Second-Order Section (SOS) / biquad form**, cascading multiple second-order stages to build higher-order responses while keeping the design numerically stable, modular, and easy to reconfigure. A MATLAB App Designer GUI generates test signals and filter coefficients, drives a Verilog testbench, and verifies the FPGA-side output against the MATLAB reference.

---

## Project Motivation

Fixed, hardwired filters cannot adapt to changing SDR channel conditions, and floating-point filter implementations are too resource-hungry for real-time FPGA use. This project explores a **programmable, fixed-point IIR architecture** that:

- Supports dynamic coefficient updates without re-synthesizing the RTL
- Maintains numerical stability across reconfigurations
- Achieves sharp roll-off and high stopband attenuation at low filter order
- Operates in real time on FPGA targets with minimal resource overhead

---

## Key Technical Objectives

- Implement a stable, reconfigurable IIR filtering architecture
- Use Second-Order Sections (SOS) to mitigate numerical instability
- Design a fixed-point datapath optimized for FPGA logic
- Enable external parameter loading without redesigning the RTL
- Validate performance against theoretical responses and MATLAB ground truth

---

## System Architecture

| Item | Description |
|---|---|
| **Filter type** | IIR — Elliptic response (used in experiments) |
| **Structure** | Cascaded Second-Order Sections (biquads) |
| **Arithmetic** | Fixed-point, Q-format (e.g., Q4.11 — 16-bit word, 1 sign bit, 11 fractional bits) |
| **Target platform** | FPGA development board (simulated at this stage) |
| **Configuration interface** | MATLAB App Designer GUI (planned: UART for external hardware control) |

**Core Verilog modules:**

- **Coefficient register bank** — holds the programmable filter coefficients, updatable at runtime
- **Multiply–Accumulate (MAC) units** — fixed-point multiplier and adder blocks for the recursive filter structure
- **SOS / biquad filtering blocks** — each a self-contained second-order IIR section
- **Top-level control module** — cascades the biquad sections, manages data flow and timing/synchronization across stages

Each biquad section processes its input independently and feeds its output into the next section in the cascade, so higher-order filters are built by chaining more sections rather than redesigning the datapath.

```
x[n] → [Biquad 1] → [Biquad 2] → ... → [Biquad N] → y[n]
```

*(See Figure 1 in `implementation-report.pdf` for the 4th-order IIR realized via two cascaded SOS stages.)*

---

## Fixed-Point Arithmetic

Fixed-point arithmetic was chosen over floating-point to balance precision against FPGA resource usage:

- Coefficients and intermediate values are represented in **Q-format** (e.g., Q4.11 for 16-bit data).
- Multiplications are performed with fixed-point arithmetic modules, with results rescaled to fit the designated bit-width.
- Input/output data is scaled to match the fixed-point format and preserve dynamic range without significant precision loss.
- Careful bit-width management throughout prevents overflow during recursive computation.

**Parallel vs. cascaded realization:** a single large parallel IIR filter was considered against multiple cascaded sections. Cascading introduces some latency but is significantly more numerically stable, so the filters were implemented in **SOS form** — a practical trade-off between the two approaches.

---

## Repository Structure

```
.
├── demo-video/                          # Short video walkthrough of the project
├── GUI.mlapp                            # MATLAB App Designer GUI — signal generation & filter configuration
├── filter_coefficients.m                # Generates/exports IIR filter coefficients (SOS form)
├── fplot.m                              # Plots frequency response / verification results
├── IIR.v                                # Core programmable IIR (biquad/SOS) filter module
├── multiplier.v                         # Fixed-point multiplier unit
├── proj.v                               # Top-level project module (cascades filter stages)
├── iir_tb.v                             # Testbench for the IIR filter module
├── tb_proj.v                            # Testbench for the top-level project module
├── simulation.bat                       # Script to run Verilog simulation
├── implementation-report.pdf            # Full project write-up (this README's companion document)
├── Preliminary Design Report.docx       # Earlier-stage design report
└── README.md                            # You are here
```

> File names above are taken directly from the repository. See inline comments in each script/module for implementation-level detail.

---

## Design Methodology

### 1. Algorithm & Specification
- Filter type: **Elliptic**, chosen for its sharp transition band and compact filter order
- Designed using standard digital filter design methods
- MATLAB used to derive coefficients for multiple filter configurations (passband/stopband frequency, stopband attenuation, filter order)

### 2. Fixed-Point Representation
- Coefficients and intermediate signals mapped to Q-format
- Scaling analysis performed to avoid overflow and preserve accuracy
- Bit-growth managed through controlled truncation/saturation logic

### 3. Hardware Architecture (Verilog)
- Coefficient register bank, MAC units, and cascaded SOS/biquad blocks
- Pipelined datapath to sustain throughput
- Top-level module for data routing, control, and stage synchronization

### 4. Simulation Workflow
- MATLAB generates the input signal and filter coefficients
- A Verilog testbench reads these files and exercises the hardware filter
- Output samples are written to file and compared against the MATLAB reference output, confirming numerical and functional correctness

### 5. User Interface
- A MATLAB App Designer **GUI** (`GUI.mlapp`) lets users set filter parameters (e.g., cutoff frequencies, ripple, stopband attenuation) and generate test signals interactively.

---

## Testing and Validation Workflow

The testbench validates the filter end-to-end across MATLAB and Verilog:

1. **Signal & coefficient generation (MATLAB):** the MATLAB app generates the test signal and configures filter parameters; coefficients are stored in one file, signal samples in another.
2. **Hardware simulation (Verilog):** a testbench (`iir_tb.v` / `tb_proj.v`) reads these files in the expected format and drives the IIR filter hardware, producing an output waveform that is also written to file.
3. **Verification (MATLAB):** MATLAB reads the Verilog-generated output file and plots it alongside the expected response for visual/numerical verification.

```
MATLAB (GUI.mlapp) ──► coefficients.file, signal.file
        │
        ▼
Verilog testbench (iir_tb.v / tb_proj.v) ──► output.file
        │
        ▼
MATLAB (fplot.m) ──► verification plot
```

---

## Results

The programmable IIR filters were evaluated on two key metrics:

- **Frequency response accuracy** — sharp roll-off and effective stopband attenuation were observed across a range of test frequencies, with minimal passband ripple, confirming suitability for interference suppression in wideband signal environments. Dynamic parameter adjustment allowed fine-tuning of the response for different signal conditions.
- **Computational efficiency** — measured via clock cycles required per filter operation. The fixed-point implementation, combined with pipelining and resource sharing, allowed high clock frequencies with minimal latency and consistent performance across operating conditions.

Overall, the design demonstrated a good balance between computational efficiency, FPGA resource utilization, and dynamic reconfigurability. See `implementation-report.pdf` for the full frequency response plots, GUI screenshots, and simulation waveforms.

---

## Requirements

- MATLAB (App Designer, Signal Processing Toolbox) — for coefficient generation, signal generation, and result verification
- A Verilog simulator (e.g., ModelSim/QuestaSim, Icarus Verilog, or Vivado Simulator) to run `simulation.bat` and the testbenches
- (Optional, for hardware deployment) FPGA synthesis toolchain matching your target board

---

## How to Run

1. **Generate signal & coefficients in MATLAB**
   Open `GUI.mlapp` in MATLAB App Designer, set the desired filter parameters (cutoff frequency, ripple, stopband attenuation), and generate the test signal. This produces the coefficient file and signal file consumed by the Verilog testbench. `filter_coefficients.m` can also be used directly to generate/export coefficients.

2. **Run the Verilog simulation**
   Run `simulation.bat` (or invoke your simulator manually) to compile and run `proj.v` with `tb_proj.v` (or `IIR.v` with `iir_tb.v`). The testbench reads the MATLAB-generated files and produces an output waveform, saved to file.

3. **Verify in MATLAB**
   Use `fplot.m` to load the Verilog-generated output file and plot it against the expected response for verification.

> Update any hardcoded file paths in the MATLAB scripts/testbenches to match your local directory structure before running.

---

## Future Work

- Implement a **UART**-based interface for external, real-time configuration on physical FPGA hardware
- Deploy and validate the design on an actual FPGA board with live data streaming (this stage is simulation-based)
- Develop more efficient multiplication logic to reduce resource usage
- Incorporate **complex (I/Q) number processing** for full SDR receiver chains
- Explore multiplier-less techniques (e.g., distributed arithmetic) for further efficiency gains
- Enhance the GUI for improved usability and functionality

---

## Project Report and Demo

- 📘 **Full write-up:** [`implementation-report.pdf`](./implementation-report.pdf) — filter design rationale, architecture, fixed-point analysis, testing methodology, and results.
- 📄 **Preliminary design report:** [`Preliminary Design Report.docx`](./Preliminary%20Design%20Report.docx)
- 🎥 **Demo video:** [`demo-video/`](./demo-video)

---

## References

1. *Journal of Electrical Systems and Information Technology* — "High performance IIR filter implementation on FPGA."
2. *International Journal of Advanced Computer Science and Applications* — "Design and Implementation of a Digital IIR Filter for Real-Time Applications on FPGA."
3. *IEEE Transactions on Circuits and Systems* — "Efficient FPGA Implementation of IIR Digital Filters."
4. *IEEE Transactions on Signal Processing* — "FPGA Implementation of IIR Filters Using Distributed Arithmetic."
5. *IEEE Journal on Emerging and Selected Topics in Circuits and Systems* — "Design and FPGA Implementation of Digital Filters for Software-Defined Radios."

---

## Authors

- **Muhammad Omais** — School of Electrical Engineering and Computer Science, NUST — `owaseem.bee21seecs@seecs.edu.pk`
- **Ahmed Raziullah** — School of Electrical Engineering and Computer Science, NUST — `aullah.bee21seecs@seecs.edu.pk`
