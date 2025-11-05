##Programmable IIR Filters for Software-Defined Radio on FPGA

This repository contains the design and implementation of programmable Infinite Impulse Response (IIR) digital filters targeted for Software-Defined Radio (SDR) systems on FPGA hardware. The primary objective of this student project is to enable flexible and efficient real-time filtering of wideband signals, while minimizing FPGA resource usage and maintaining stability under reconfigurable conditions.

This work demonstrates the full design pipeline, including algorithm selection, fixed-point mapping, hardware architecture, simulation, and verification against MATLAB-generated reference data.

##Project Motivation

Modern SDR systems require adaptable filtering modules capable of adjusting to changing communication channel conditions and interference environments. Fixed filters are inadequate in such contexts, and floating-point implementations on FPGA are resource-intensive.

This project explores a programmable fixed-point IIR architecture that:

Supports dynamic coefficient updates

Maintains numerical stability

Achieves high attenuation and sharp frequency response

Operates in real time on FPGA targets

The design emphasizes mathematical modeling, digital filter architecture, numerical precision handling, and structured Verilog implementation.

##Key Technical Objectives

Implement a stable, reconfigurable IIR filtering architecture

Use Second-Order Sections (SOS) to mitigate numerical instability

Design a fixed-point datapath optimized for FPGA logic

Enable external parameter loading without redesigning RTL

Validate performance against theoretical responses and MATLAB ground truth

##System Overview

Filter Architecture

Item	                                           Description
Filter Type                          	IIR (Elliptic response used in experiments)
Structure                           	Cascaded SOS (biquad) blocks
Arithmetic	                          Fixed-point (Q-format)
Target Platform                     	FPGA development board (simulated for this stage)

The cascaded SOS topology was selected to ensure numeric stability and controlled precision levels when updating coefficients.

##Design Methodology

#1. Algorithm & Specification

Chosen IIR type: Elliptic (due to sharp transition band and compact design)

Designed using standard digital filter design methods

MATLAB used to derive coefficients for multiple configurations

#2. Fixed-Point Representation

Coefficients and intermediate signals mapped to Q-format

Scaling analysis performed to avoid overflow and maintain accuracy

Bit-growth managed through controlled truncation and saturation logic

#3. Hardware Architecture (Verilog)

Core modules include:

Coefficient register bank

Multiply–Accumulate (MAC) units

SOS filtering blocks

Pipelined datapath to maintain throughput

Top-level data routing and control module

The system accepts programmable coefficients and processes sample streams through cascaded second-order stages.

#4. Simulation Workflow

MATLAB generates input signal and filter coefficient files

Verilog testbench reads files and exercises the hardware filter

#5. Future Extensions

UART-based runtime control interface

Hardware deployment on FPGA board with external data streaming

Complex (IQ) version for full SDR receiver chains

Exploration of multiplier-less methods (e.g., distributed arithmetic)

Output samples written to file and compared against MATLAB output

This ensures numerical and functional correctness of the hardware design.
