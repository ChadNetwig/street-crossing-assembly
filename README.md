# 🚦 Street Crossing Traffic Signal Simulation

A Raspberry Pi assembly language project simulating a pedestrian crosswalk system, built entirely in ARM assembly.  

[![Demo Video](https://img.shields.io/badge/Watch-Demo%20Video-red)](https://www.youtube.com/watch?v=YOUR_VIDEO_ID_HERE)

---

## 📌 Project Overview

**Course:** CS-170 Assembly Language  
**Institution:** San Bernardino Valley College  
**Instructor:** Professor Paul J. Conrad  
**Date Completed:** May 2021  

This project demonstrates:
- Direct hardware control of GPIO pins
- Assembly logic for state sequencing
- Integration with LEDs and physical button inputs using the WiringPi library

---

## 🎯 Objectives

- Use ARM assembly to control GPIO pins on a Raspberry Pi 3B+
- Simulate a traffic signal and walk/don't walk signals
- Implement timing and blinking sequences triggered by button press
- Practice low-level debugging and I/O management

---

## 🛠️ Components & Environment

- **Hardware:**
  - Raspberry Pi 3B+
  - CanaKit Ultimate Starter Kit
  - Breadboard, resistors, 5 LEDs (traffic & walk signals), pushbutton
- **Software:**
  - Raspbian Linux 5.4.83-v7+
  - `g++` cross-assembler
  - WiringPi library for GPIO
- **Programming Language:** ARM Assembly

---

## 🖼️ Screenshots

> _(Replace with your actual image paths or URLs)_

**Breadboard Schematic:**
![Schematic](./streetxing-schematic.jpg)

**Breadboard Build - Walk Sequence:**
![Walk](./breadboard-seq1-walk.jpg)

**Breadboard Build - Hurry Up Sequence:**
![Hurry](./breadboard-seq2-hurry.jpg)

**Breadboard Build - Don't Walk Sequence:**
![DontWalk](./breadboard-seq3-dontwalk.jpg)

**Detailed Schematic:**
![Detailed](./streetxing-schematic-details.jpg)

**WiringPi Pinout Reference:**
![WiringPi](./wiringPi pinout.png)

---

## 🎮 Program Behavior

**Sequence Overview:**

1️⃣ **Walk Sequence**  
- Red traffic signal + Green walk signal ON  
- Duration: 6 seconds

2️⃣ **Hurry Up Sequence**  
- Yellow traffic + Green walk signals BLINK  
- 14 blinks with 300ms intervals

3️⃣ **Don't Walk Sequence**  
- Green traffic + Red walk signal ON  
- Duration: 6 seconds

Program exits after sequence completion.

---

## 🧩 Core Logic (Assembly)

- Configure GPIO pins as INPUT or OUTPUT
- Poll button input (`digitalRead`)
- Use delay loops (`delay`) for timing
- Loop counter to control blinking
- `printf` output for status messages in console

> **Note:** Full source code available in [`streetxing.s`](./streetxing.s).  
*(Code is shared here for educational purposes; please do not plagiarize.)*

---

## 🧪 Testing & Debugging

- Verified GPIO outputs via LEDs
- Used console logs to monitor sequence progress
- Validated timing delays with stopwatch
- Iteratively tested each state before full integration

---

## 🚧 Challenges & Solutions

**Challenge:**  
Limited examples for WiringPi assembly integration.

**Solution:**  
- Studied C examples to understand WiringPi function signatures
- Adapted GPIO logic and `pinMode` calls manually in assembly
- Debugged pin state transitions with console logs and LED visual feedback

---

## 🌟 Highlights

- Full assembly implementation without high-level C code wrappers
- Clean separation of sequences
- Real hardware control of LEDs and button input
- Visual feedback for each crosswalk state

---

## 🎬 Demo Video

[Watch the demo on YouTube](https://www.youtube.com/watch?v=YOUR_VIDEO_ID_HERE)

---

## 📝 License

This project is shared for **educational demonstration purposes only**.  
Please do not submit this work as your own in any academic context.

---

