# 🚦 Audible Pedestrian Crossing Signal System

## Context
This project was created by a student in the Technology in Analysis and Systems Development (TADS) program at IFRN - Campus Central. The goal is to build a low-cost system to assist visually impaired pedestrians crossing intersections using audible and visual signals.

## Project goals
- Develop a traffic signal control system for intersections.
- Emit audible and visual cues to ensure safe pedestrian crossings.
- Add a push-button to trigger the crossing sequence.

## Technologies and tools
- Hardware: Raspberry Pi Pico W, LEDs, buzzer, push button, resistors, breadboard and wiring.
- Simulator: Wokwi (for circuit tests and validation).
- Programming language: C

## System operation
1. Idle: LEDs cycle automatically between green, yellow and red.
2. On button press:
   - Yellow active for 5 seconds.
   - Red active for 15 seconds to allow crossing.
   - Pedestrian green LED turns on and the buzzer beeps intermittently.
3. After crossing: system returns to normal operation.

## How to run the project
1. Clone this repository:
```bash
git clone https://github.com/AndersonCSM/EmbeddedSystems.git
