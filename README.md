<div align="center">

# DIC Final Project: FP_MUL

Public 0.5 ns (2 GHz) ASIC implementation of an IEEE-754 double-precision floating-point multiplier.

**TSMC ADFP N16** | **RTL to GDSII Design Flow** | **Cadence ncverilog / Genus / Innovus / Virtuoso**

</div>

---

## Overview

This repository contains the public 0.5 ns version of my Digital IC Design final
project. The project implements, verifies, synthesizes, and physically
implements a double-precision floating-point multiplier (`FP_MUL`) through an
ASIC design flow from RTL to GDSII.

本 repository 為 Digital IC Design final project 的公開版本，內容是 0.5 ns
目標時脈的雙精度浮點乘法器 (`FP_MUL`)。本專案的 ASIC design flow 從 RTL
設計與模擬開始，經過 synthesis、netlist verification、APR，最後到 GDSII
stream-out。

`FP_MUL` receives two IEEE-754 double-precision floating-point operands through
an 8-bit serial input interface and returns the 64-bit multiplication result
through an 8-bit serial output interface. The design handles normal numbers,
subnormal numbers, zero, infinity, and NaN cases.

`FP_MUL` 透過 8-bit serial input interface 接收兩個 IEEE-754 double-precision
floating-point operands，並透過 8-bit serial output interface 回傳 64-bit
乘法結果。設計涵蓋 normal number、subnormal number、zero、infinity 與 NaN
等情況。

## Project Snapshot

| Item | Public Release Detail |
| --- | --- |
| Design | IEEE-754 double-precision floating-point multiplier |
| Target clock | 0.5 ns (2 GHz) |
| Process technology | TSMC ADFP N16 |
| RTL simulation | Cadence ncverilog |
| Logic synthesis | Cadence Genus |
| APR / physical implementation | Cadence Innovus |
| Layout / physical verification environment | Cadence Virtuoso |

## ASIC Design Flow: RTL to GDSII

```mermaid
flowchart LR
    A["RTL Design<br/>Verilog FP_MUL"] --> B["RTL Simulation<br/>Cadence ncverilog"]
    B --> C["Logic Synthesis<br/>Cadence Genus"]
    C --> D["Gate-Level Netlist<br/>SDC / SDF / Reports"]
    D --> E["APR<br/>Cadence Innovus"]
    E --> F["Physical Verification<br/>Virtuoso Environment"]
    F --> G["GDSII Stream-Out"]
```

| Stage | Purpose | Public Files |
| --- | --- | --- |
| RTL design | Floating-point datapath and control implementation | `RTL/FP_MUL.v` |
| RTL simulation | Functional verification with testbench | `RTL/TEST_MUL.v`, `RTL/run.f` |
| Synthesis | Map RTL to standard cells and generate reports | `Synthesis/SYN_ADFP_RC.tcl`, `Synthesis/SYN_RTL.sdc` |
| Netlist simulation | Gate/post-layout simulation setup | `Netlist/TEST_MUL_gate.v`, `Netlist/TEST_CHIP.v`, `Netlist/run.f`, `Netlist/run_CHIP.f` |
| APR | Floorplan, placement, CTS, routing, and signoff command flow | `Innovus/s0.cmd` to `Innovus/s12.cmd` |
| Reports | Public synthesis summary data | `0.5_ns_report/` |
| Physical signoff | DRC/LVS/GDSII related material | Private process collateral is not included |

The public repository keeps the command flow and project structure, while
process-dependent setup values are redacted where required.

此公開版本保留主要 flow 與資料夾結構；涉及 foundry PDK、standard-cell
library、routing rule、stream-out map、GDS 等製程相關資料的部分已遮蔽或不公開。

## Implementation Results

| Target Clock | Worst Synthesis Slack | Cell Count | Total Area |
| --- | --- | --- | --- |
| 0.5 ns | +2 ps | 19542 | 12623.773 |

<p align="center">
  <img src="assets/results/result_browser.png" width="49%" alt="APR result browser">
  <img src="assets/results/IR_drop.png" width="49%" alt="IR drop map">
</p>

## Repository Layout

| Path | Description |
| --- | --- |
| `RTL/` | Verilog RTL and RTL-level testbench |
| `Synthesis/` | Public timing constraint and sanitized Cadence Genus synthesis Tcl flow |
| `Netlist/` | Gate-level / post-layout simulation testbench and run files |
| `Innovus/` | Cadence Innovus APR command flow with process-specific values redacted |
| `0.5_ns_report/` | Sanitized synthesis report summaries |
| `DRC&LVS/` | Public note for private physical signoff material |
| `assets/results/` | Selected implementation result snapshots |

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

此公開版本保留一般 Cadence synthesis / APR / simulation flow，但不公開 foundry
PDK、standard-cell library、routing rule、GDS stream-out map、operating corner、
完整 mapped timing path 等製程相關機密資訊。這些內容在腳本中以
`<PRIVATE_...>` placeholder 表示。
