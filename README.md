# RISC-V Single Cycle CPU

A Verilog implementation of a small single-cycle RISC-V CPU core built from scratch and verified with Icarus Verilog and GTKWave.

This project was built to practice computer architecture concepts including instruction fetch, decode, register files, ALU execution, control signals, program counter updates, and waveform-based debugging.

---

## Overview

This CPU implements a small RV32I-style instruction subset and executes instructions from a hex-loaded instruction memory.

The first version focuses on a clean single-cycle datapath where each instruction completes in one clock cycle.

Current supported instructions include:

- ADD
- SUB
- AND
- OR
- XOR
- ADDI

---

## Architecture

```text
Program Counter
      │
      ▼
Instruction Memory
      │
      ▼
Control Unit
      │
      ▼
Register File
      │
      ▼
Immediate Generator
      │
      ▼
ALU
      │
      ▼
Writeback
```

---

## Modules

| Module | Purpose |
|---|---|
| `alu.v` | Performs arithmetic and logic operations |
| `regfile.v` | Implements 32 general-purpose registers |
| `control.v` | Decodes instruction fields into control signals |
| `imm_gen.v` | Generates immediates for instruction formats |
| `instr_mem.v` | Loads machine code instructions from hex files |
| `data_mem.v` | Provides memory support for future load/store tests |
| `cpu_single_cycle.v` | Connects all datapath components together |

---

## Test Program

The current test program runs:

```text
addi x1, x0, 5
addi x2, x0, 10
add  x3, x1, x2
sub  x4, x3, x1
and  x5, x1, x3
or   x6, x1, x3
xor  x7, x1, x3
```

Expected register results:

```text
x1 = 5
x2 = 10
x3 = 15
x4 = 10
x5 = 5
```

---

## Simulation Result

![Register Output](docs/register-output.png)

The terminal output confirms that the CPU correctly fetched, decoded, executed, and wrote back the expected register values.

---

## Waveform Verification

![Single Cycle Waveform](docs/waveform-single-cycle.png)

The waveform shows:

- clock and reset behavior
- program counter incrementing by 4
- instruction memory output changing each cycle
- ALU results matching instruction execution
- writeback data updating register values

---

## Running the Simulation

Compile:

```bash
iverilog -o sim/cpu_single_cycle.vvp src/*.v sim/tb_cpu_single_cycle.v
```

Run:

```bash
vvp sim/cpu_single_cycle.vvp
```

Open waveform:

```bash
gtkwave waves/cpu_single_cycle.vcd
```

---

## Repository Structure

```text
riscv-pipeline-cpu/
│
├── src/
│   ├── alu.v
│   ├── control.v
│   ├── cpu_single_cycle.v
│   ├── data_mem.v
│   ├── imm_gen.v
│   ├── instr_mem.v
│   └── regfile.v
│
├── sim/
│   └── tb_cpu_single_cycle.v
│
├── programs/
│   └── add_test.hex
│
├── waves/
│   └── cpu_single_cycle.vcd
│
├── docs/
│   ├── register-output.png
│   └── waveform-single-cycle.png
│
└── README.md
```

---

## What This Demonstrates

- Verilog hardware design
- RISC-V instruction execution
- Single-cycle CPU datapath design
- Register file and ALU implementation
- Instruction decoding and control signals
- Waveform-based verification
- Computer architecture fundamentals

---

## Future Work

- Add load/store instruction tests
- Add branch and jump tests
- Implement a 5-stage pipeline
- Add hazard detection and forwarding
- Build a small pipeline visualization dashboard