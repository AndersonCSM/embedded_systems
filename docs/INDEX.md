# 📚 Documentation Index — Embedded Systems

Centralized navigation guide for all repository documentation.

---

## 🚀 Getting Started

### New to the Repository?

1. **Initial Setup:** [`FIRST_SETUP.md`](FIRST_SETUP.md) — Clone and structure
2. **Start Developing:** [`hdl/WORKFLOW.md`](hdl/WORKFLOW.md) — Blink Project in 3 environments
3. **Or choose your platform:** Sections below

---

## 🚀 Development Workflow

### Want to start developing right away?

Refer to **[`hdl/WORKFLOW.md`](hdl/WORKFLOW.md)** for a complete guide showing how to develop the same project (Blink) in three environments:

- **Gowin IDE** (Windows, graphical interface)
- **Quartus Prime Lite** (Windows/Linux, graphical interface)
- **VS Code + oss-cad-suite** (Linux, terminal + editor)

Each section is independent and complete!

---

## 🎯 Main Index

### HDL/FPGA

Documentation for development with FPGA boards (Altera MAX II, Tang Nano).

**Location:** `docs/hdl/`  
**Detailed Index:** [`hdl/README.md`](hdl/README.md)

#### 🖥️ Linux

- **Tang Nano (oss-cad-suite)** — [`hdl/TANG_NANO_LINUX.md`](hdl/TANG_NANO_LINUX.md)
  - Complete toolchain installation
  - USB driver configuration
  - Verification and troubleshooting
  - Basic usage (compilation and programming)

- **MAX II (Quartus Prime Lite)** — [`hdl/QUARTUS_INSTALL.md`](hdl/QUARTUS_INSTALL.md)
  - Quartus installation
  - USB Blaster configuration
  - MAX II programming

#### 🪟 Windows

- **Tang Nano (Gowin IDE)** — [`hdl/GOWIN_INSTALL.md`](hdl/GOWIN_INSTALL.md)
  - Gowin FPGA Designer installation
  - Project creation
  - Synthesis, Place & Route
  - Programming via Gowin Programmer

- **MAX II (Quartus Prime Lite)** — [`hdl/QUARTUS_INSTALL.md`](hdl/QUARTUS_INSTALL.md)
  - Quartus installation
  - USB Blaster drivers
  - Programming

#### 📂 Projects

- **Tang Nano:** [`hdl/tang_nano/`](../hdl/tang_nano/) — Examples and projects
- **MAX II:** [`hdl/max_ii/`](../hdl/max_ii/) — Examples and projects

---

### Embedded

Documentation for development with microcontrollers and single-board computers.

**Location:** `docs/embedded/`

Available projects:
- **Raspberry Pi Pico** — `embedded/pico/`
- **KeyStudio** — `embedded/keystudio/`
- **Raspberry Zero 2W** — Setup scripts

---

## 📋 Quick Reference

| Platform | OS | Installation | Projects |
|---|---|---|---|
| **Tang Nano** | Linux | [`TANG_NANO_LINUX.md`](hdl/TANG_NANO_LINUX.md) | [`tang_nano/`](../hdl/tang_nano/) |
| **Tang Nano** | Windows | [`GOWIN_INSTALL.md`](hdl/GOWIN_INSTALL.md) | [`tang_nano/`](../hdl/tang_nano/) |
| **MAX II** | Linux | [`QUARTUS_INSTALL.md`](hdl/QUARTUS_INSTALL.md) | [`max_ii/`](../hdl/max_ii/) |
| **MAX II** | Windows | [`QUARTUS_INSTALL.md`](hdl/QUARTUS_INSTALL.md) | [`max_ii/`](../hdl/max_ii/) |

---

## 🔧 Installation Guides

### 1. Initial Setup
→ [`FIRST_SETUP.md`](FIRST_SETUP.md)

### 2. HDL/FPGA
→ [`hdl/README.md`](hdl/README.md)

**Linux:**
- Tang Nano: [`hdl/TANG_NANO_LINUX.md`](hdl/TANG_NANO_LINUX.md)
- MAX II: [`hdl/QUARTUS_INSTALL.md`](hdl/QUARTUS_INSTALL.md)

**Windows:**
- Tang Nano: [`hdl/GOWIN_INSTALL.md`](hdl/GOWIN_INSTALL.md)
- MAX II: [`hdl/QUARTUS_INSTALL.md`](hdl/QUARTUS_INSTALL.md)

### 3. Embedded
→ Refer to specific README in `embedded/[platform]/`

---

## 🆘 Troubleshooting

### Issue: Tool not found

1. Read the installation guide for your chosen platform
2. Check environment variables (`.bashrc` or `.profile`)
3. Refer to the "Troubleshooting" section of the guide

### Issue: Device not detected

1. Check USB connection
2. Install drivers (udev rules on Linux, INF on Windows)
3. Reconnect the device
4. Refer to platform-specific guide

### Issue: Compilation fails

1. Check system dependencies
2. Confirm toolchain is installed
3. Read error logs carefully

---

## 📂 Directory Structure

```
docs/
├── INDEX.md                          # This file
├── FIRST_SETUP.md                   # Initial setup
├── hdl/
│   ├── README.md                    # HDL/FPGA index
│   ├── TANG_NANO_LINUX.md           # Tang Nano on Linux
│   ├── QUARTUS_INSTALL.md           # Quartus (Linux/Windows)
│   └── GOWIN_INSTALL.md             # Gowin IDE (Windows)
└── embedded/
    ├── pico/                        # Raspberry Pi Pico
    └── keystudio/                   # KeyStudio
```

---

## 📝 Conventions

- **Linux:** Bash scripts
- **Windows:** PowerShell scripts (when necessary)
- **Environment Variables:** Saved in `~/.bashrc` or `~/.profile`
- **Global Installation:** Tools in `/home/tools/` (Linux)

---

## 🔗 Useful Links

### Manufacturers

- **Intel Quartus:** https://www.intel.com/quartus
- **Gowin Semiconductor:** https://www.gowinsemi.com/
- **Sipeed Tang Nano:** https://sipeed.com/

### Open-Source Toolchains

- **oss-cad-suite:** https://github.com/YosysHQ/oss-cad-suite-build
- **openFPGALoader:** https://github.com/trabucayre/openFPGALoader
- **Yosys:** http://www.clifford.at/yosys/
- **nextpnr:** https://github.com/YosysHQ/nextpnr

### Microcontrollers

- **Raspberry Pi Pico:** https://www.raspberrypi.com/products/raspberry-pi-pico/
- **Raspberry Pi Zero 2W:** https://www.raspberrypi.com/products/raspberry-pi-zero-2-w/

---

## 📧 Frequently Asked Questions

**Q: Where should I start?**  
A: Read [`FIRST_SETUP.md`](FIRST_SETUP.md) and choose your platform in [`hdl/README.md`](hdl/README.md).

**Q: Can I use Windows?**  
A: Yes! Quartus and Gowin IDE work natively. Or use WSL2 + Linux.

**Q: Which platform is best for beginners?**  
A: Tang Nano on Linux with `oss-cad-suite` is recommended for being open-source and free.

**Q: How do I update tools?**  
A: Each installation guide contains instructions for updating versions.

---

**Last update:** May 6, 2026  
**Maintenance:** Refer to the main README.md of the repository for contribution information.
