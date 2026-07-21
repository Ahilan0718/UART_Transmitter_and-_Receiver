
# UART Transmitter & Receiver in Verilog

A modular **Universal Asynchronous Receiver Transmitter (UART)** designed in **Verilog HDL** featuring configurable baud rate generation, UART transmission and reception, even parity generation/checking, and frame error detection. The design was functionally verified using **Icarus Verilog** and **GTKWave**, and synthesized using **Xilinx Vivado**.

## Repository Structure

```text
UART_Transmitter_Receiver/
│
├── codes/
│   ├── brg.v                  # Baud Rate Generator
│   ├── tx.v                   # UART Transmitter Module
│   ├── rx.v                   # UART Receiver Module
│   └── uart_top.v             # Top-Level UART Module
│
├── tb/
│   ├── brg_tb.v               # Baud Rate Generator Testbench
│   ├── tx_tb.v                # UART Transmitter Testbench
│   ├── top_tb.v               # TX-RX Loopback Testbench
│   └── uart_top_tb.v          # Top-Level Self-Checking Testbench
│
├── simulation/
│   ├── dump_brg.vcd
│   ├── dump_tx.vcd
│   ├── dump_loop.vcd
│   └── dump_top.vcd
│
├── vivado/
│   ├── Utilization_Report.pdf
│   └──Synthesis_Report.pdf
│
├── pics/
│   ├── RTL_Schematic.png
│   ├── Synthesized_Schematic.png
│   ├── Waveform.png
│   ├── Utilization.png
│   └── Timing.png
│
├── LICENSE
└── README.md
```

## Project Features

- Parameterized Baud Rate Generator
- UART Transmitter
- UART Receiver
- 8-bit Serial Communication
- LSB-First Data Transmission
- Even Parity Generation
- Even Parity Verification
- Frame Error Detection
- Busy Status Signal
- Done Status Signal
- Modular Verilog Design
- Self-Checking Testbench
- Simulated using Icarus Verilog + GTKWave
- Synthesized using Xilinx Vivado

## Project Overview

The **Universal Asynchronous Receiver Transmitter (UART)** is one of the most widely used serial communication protocols in embedded systems, microcontrollers, processors, sensors, and FPGA-based systems.

This project implements a complete UART communication system consisting of:

- Baud Rate Generator (BRG)
- UART Transmitter (TX)
- UART Receiver (RX)
- Top-Level UART Module

The transmitter converts 8-bit parallel data into a serial UART frame, while the receiver reconstructs the transmitted byte, verifies the parity bit, checks the stop bit, and reports communication errors.

The complete design was functionally verified through simulation before FPGA synthesis.

## UART Frame Format

| Field | Size |
|-------|------|
| Start Bit | 1 Bit |
| Data | 8 Bits |
| Parity | 1 Bit (Even) |
| Stop Bit | 1 Bit |

**Transmission Order**

```text
START → D0 → D1 → D2 → D3 → D4 → D5 → D6 → D7 → PARITY → STOP
```

## Module Description

### Baud Rate Generator (BRG)

Generates the **baud_tick** signal by dividing the system clock according to the selected baud rate.

- Clock Division
- Parameterized Baud Rate
- Baud Tick Generation

### UART Transmitter (TX)

Serializes 8-bit parallel data into a UART frame.

- Start Bit Generation
- LSB-First Data Transmission
- Even Parity Generation
- Stop Bit Generation
- Busy Signal Generation
- Done Signal Generation

### UART Receiver (RX)

Receives serial UART data and reconstructs the transmitted byte.

- Start Bit Detection
- Serial Data Reception
- Even Parity Verification
- Stop Bit Verification
- Frame Error Detection
- Busy Signal Generation
- Done Signal Generation

### UART Top Module

Integrates the Baud Rate Generator, UART Transmitter, and UART Receiver into a single UART communication system.

For simulation, the transmitter output is internally connected to the receiver input, forming a UART loopback configuration.

## Verification Summary

The UART was verified using a self-checking loopback testbench with multiple test vectors.

| Transmitted Data | Received Data | Result |
|-----------------:|:-------------:|:------:|
| 0x00 | 0x00 | PASS |
| 0xFF | 0xFF | PASS |
| 0x55 | 0x55 | PASS |
| 0xAA | 0xAA | PASS |
| 0xA5 | 0xA5 | PASS |
| 0x3C | 0x3C | PASS |

Overall Result

```text
PASSED : 6
FAILED : 0
```

## FPGA Synthesis Summary

- Slice LUTs : **50**
- Slice Registers : **60**
- F7 MUX : **1**
- Bonded IOBs : **25**
- BUFGCTRL : **1**
- Worst Negative Slack (WNS) : **5.878 ns**
- Worst Hold Slack (WHS) : **0.150 ns**

## Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave
- Xilinx Vivado

