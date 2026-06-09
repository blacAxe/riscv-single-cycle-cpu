# RISC-V CPU Architecture

A Verilog implementation of a RISC-V CPU built from scratch and verified with Icarus Verilog and GTKWave.

The project currently includes a fully functional single-cycle CPU and an instruction-trace pipeline model used to validate instruction flow through a classic 5-stage pipeline architecture.
---

## Overview

This project currently supports arithmetic, logical, memory, branch, and jump instructions through a single-cycle datapath and includes an instruction-trace pipeline model that demonstrates instruction movement through a 5-stage pipeline.

The long-term goal is to evolve the design into a fully pipelined RV32I processor with hazard detection, forwarding, and control-flow handling.

This CPU implements a small RV32I-style instruction subset and executes instructions from a hex-loaded instruction memory.

The first version focuses on a clean single-cycle datapath where each instruction completes in one clock cycle.

---

## Supported Instructions

- ADD
- SUB
- AND
- OR
- XOR
- ADDI
- LW
- SW
- BEQ
- JAL

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
| `cpu_pipeline_trace.v` | Demonstrates instruction movement through a 5-stage pipeline |
---

## Arithmetic and Logic Verification

This verification program tests arithmetic and logical instructions executed through the ALU and confirms correct register writeback behavior.

![ALU Output](docs/alu-verification-output.png)

![ALU Waveform](docs/alu-verification-waveform.png)

The waveform confirms correct instruction fetch, ALU execution, and register writeback for arithmetic and logical operations.

The waveform shows:

- clock and reset behavior
- program counter incrementing by 4
- instruction memory output changing each cycle
- ALU results matching instruction execution
- writeback data updating register values

---

## Memory and Control Flow Verification

![Control Flow Output](docs/control-flow-output.png)

This verification program tests memory operations and control-flow instructions.

The test confirms:

- SW stores values into data memory
- LW loads values back into registers
- BEQ correctly branches when registers match
- JAL stores a return address and jumps to the target instruction

Expected final state:

```text
x1 = 42
x2 = 42
x3 = 0
x4 = 24
x5 = 7
mem[0] = 42
```

![Control Flow Waveform](docs/control-flow-waveform.png)

The waveform shows successful memory access, branch execution, and jump behavior while the program counter advances through the instruction stream.

---

## Pipeline Stage Trace Verification

The project also includes a pipeline trace model used to verify instruction movement through a classic 5-stage pipeline.

Pipeline stages:

- IF (Instruction Fetch)
- ID (Instruction Decode)
- EX (Execute)
- MEM (Memory Access)
- WB (Write Back)

![Pipeline Trace Output](docs/pipeline-stage-trace-output.png)

![Pipeline Stage Trace](docs/pipeline-stage-trace.png)

The waveform shows multiple instructions occupying different pipeline stages simultaneously.

Example pipeline state:

```text
IF/ID  = 0080026f
ID/EX  = 06f00193
EX/MEM = 00208463
MEM/WB = 00002103
```

This confirms that instructions advance through the IF, ID, EX, MEM, and WB stages one clock cycle at a time and establishes the foundation for a future pipelined implementation.

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
│   ├── cpu_pipeline_trace.v
│   ├── data_mem.v
│   ├── imm_gen.v
│   ├── instr_mem.v
│   └── regfile.v
│
├── sim/
│   ├── tb_cpu_single_cycle.v
│   └── tb_pipeline_trace.v
│
├── programs/
│   ├── alu_validation.hex
│   └── memory_branch_jump.hex
│
├── waves/
│   └── cpu_single_cycle.vcd
│
├── docs/
│   ├── alu-verification-output.png
│   ├── alu-verification-waveform.png
│   ├── control-flow-output.png
│   ├── control-flow-waveform.png
│   ├── pipeline-stage-trace.png
│   └── pipeline-stage-trace-output.png
|
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
- Five-stage pipeline fundamentals
- Pipeline register design
- Instruction flow visualization

---

## Next Steps

- Expand the RV32I instruction subset
- Add additional load and store variants
- Convert the pipeline trace model into a functional 5-stage pipeline
- Add pipeline registers carrying data and control signals
- Add hazard detection and forwarding
- Support pipeline stalling and flushing
- Execute larger RISC-V programs