# DIC Final Project: FP_MUL

This repository contains the public 0.5 ns version of my Digital IC Design
final project. The project implements and verifies a double-precision
floating-point multiplier (`FP_MUL`) and documents the synthesis/APR flow used
to target a high-frequency ASIC implementation.

## Project Overview

`FP_MUL` receives two IEEE-754 double-precision floating-point operands through
an 8-bit serial input interface and returns the 64-bit multiplication result
through an 8-bit serial output interface. The design handles normal numbers,
subnormal numbers, zero, infinity, and NaN cases, with RTL simulation test
benches included in this public release.

This public version focuses on the 0.5 ns target clock implementation.

## Technology and Tools

- Process technology: TSMC ADFP N16
- RTL simulation: Cadence ncverilog
- Logic synthesis: Cadence Genus
- APR / physical implementation: Cadence Innovus
- Layout / physical verification related environment: Cadence Virtuoso

## Repository Contents

- `RTL/`: Verilog RTL and RTL-level test bench.
- `Synthesis/`: Public timing constraint and sanitized synthesis flow note.
- `Netlist/`: Gate/post-layout test bench files and simulation run files.
- `Innovus/`: Cadence Innovus APR command flow with process-specific values redacted.
- `0.5_ns_report/`: Sanitized synthesis report summaries.
- `DRC&LVS/`: Public note for private physical signoff material.

## Public Metrics

- Target clock period: 0.5 ns
- Worst synthesis slack: +2 ps
- Cell count: 19542
- Total area: 12623.773

## Implementation Result Snapshots

| APR Result Browser | IR Drop |
| --- | --- |
| ![APR result browser](assets/results/result_browser.png) | ![IR drop map](assets/results/IR_drop.png) |

## Confidentiality Notice

This repository intentionally does not publish confidential process collateral
or full physical implementation data. General Cadence command flow is kept, but
technology-dependent values are redacted with `<PRIVATE_...>` placeholders.

Redacted items include physical technology files, process setup values,
tap/endcap/filler/tie cell names, routing width/spacing/offset values,
stream-out map paths, physical-library GDS references, operating-corner details,
and full mapped timing paths.

The netlist run files keep the original referenced standard-cell model filename
for context, but the private model file itself is not included.
