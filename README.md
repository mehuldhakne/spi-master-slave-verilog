# SPI Master-Slave Communication using Verilog

A complete implementation of the **SPI (Serial Peripheral Interface)** protocol in **Verilog HDL** featuring both **Master** and **Slave** modules. The project has been simulated and verified in **Xilinx Vivado** using SPI **Mode-0 (CPOL = 0, CPHA = 0)** communication.

---

## Features

- SPI Master implementation
- SPI Slave implementation
- SPI Mode-0
- Full-duplex communication
- 8-bit data transfer
- FSM-based controller
- Configurable clock divider
- Behavioral simulation
- Multiple transaction verification
- Vivado compatible

---

## SPI Configuration

| Parameter | Value |
|-----------|-------|
| Protocol | SPI |
| Mode | 0 |
| CPOL | 0 |
| CPHA | 0 |
| Data Width | 8-bit |
| Transmission | Full Duplex |
| Bit Order | MSB First |

---

## Project Structure

```
SPI-Master-Slave-Verilog
│
├── rtl/
│   ├── spi_master.v
│   ├── spi_slave.v
│   └── spi_top.v
│
├── testbench/
│   └── tb.v
│
├── simulation/
│   ├── Waveforms/
│   └── Simulation_Result.png
│
├── synthesis/
│   ├── Utilization_Report.pdf
│   └── Timing_Report.pdf
│
├── docs/
│   ├── SPI_Project_Report.pdf
│   ├── FSM_Diagram.png
│   ├── Block_Diagram.png
│   └── SPI_Architecture.png
│
├── vivado_project/
│
├── LICENSE
└── README.md
```

---

## Functional Overview

The SPI Master initiates communication by asserting the Chip Select (CS) signal and generates the Serial Clock (SCK). Data is transmitted through MOSI while simultaneously receiving data through MISO, enabling full-duplex communication.

The Slave samples incoming data on the rising edge of SCK and shifts outgoing data on the falling edge according to SPI Mode-0 timing.

---

## Simulation Results

The design has been verified through behavioral simulation in Vivado.

### Test Cases

| Master TX | Slave RX | Slave TX | Master RX | Result |
|------------|-----------|-----------|-----------|--------|
| A5 | A5 | 5A | 5A | PASS |
| FF | FF | 00 | 00 | PASS |
| 53 | 53 | AC | AC | PASS |

---

## FSM

The controller operates using a finite state machine consisting of:

- IDLE
- LOAD
- TRANSFER
- DONE

---

## Tools Used

- Verilog HDL
- Xilinx Vivado
- XSIM Simulator

---

## Future Improvements

- SPI Mode 1
- SPI Mode 2
- SPI Mode 3
- Configurable data width
- FIFO buffering
- Interrupt support
- Multi-slave communication

---

## Author

**Mehul Jiwak Dhakne**

Electronics & Telecommunication Engineering

Government College of Engineering, Amravati

---

## License

This project is released under the MIT License.
