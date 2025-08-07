# Router 1x3 – RTL Design and Verification

## 📌 Overview
This project implements an 8-bit packet router with 1 input and 3 output ports.  
The design is written in Verilog, and verification is performed using SystemVerilog + UVM.

## 📁 Folder Structure
- `rtl/` – RTL modules: router_top, FSM, FIFO
- `tb/` – Testbench top and interface
- `src_agt_top/` – Source agent: driver, sequencer, monitor
- `dst_agt_top/` – Destination agent: monitor, analysis port
- `test/` – UVM testcases, sequences, coverage, assertions
- `sim/` – Simulation scripts and makefiles

## 🛠️ Tools Used
- Verilog / SystemVerilog
- UVM 1.2
- QuestaSim / VCS

## ✅ Features
- Full UVM environment
- Functional coverage
- Assertion-based verification
- FIFO and FSM-based routing logic

## 👤 Author
Raj Kushwaha  
🔗 [LinkedIn](https://linkedin.com/in/kushwaharaj)  
🔗 [GitHub](https://github.com/Kushwaharaj)
