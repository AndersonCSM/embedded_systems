# Development Workflow — Blink Project

Guide to developing the same **Blink** project in three different environments:
- **Gowin IDE** (Windows, graphical interface)
- **Quartus Prime Lite** (Windows/Linux, graphical interface)
- **VS Code + oss-cad-suite** (Linux, terminal + editor)

Each section is a complete project guide, from creation to programming.

---

## 📋 Index

1. [Project: Blink — Overview](#project-blink--overview)
2. [Workflow 1: Gowin IDE (Windows)](#workflow-1-gowin-ide-windows)
3. [Workflow 2: Quartus Prime Lite](#workflow-2-quartus-prime-lite)
4. [Workflow 3: VS Code + oss-cad-suite (Linux)](#workflow-3-vs-code--oss-cad-suite-linux)
5. [Workflow Comparison](#workflow-comparison)

---

## Project: Blink — Overview

### Objective

Create a simple project that blinks 3 RGB LEDs on **Tang Nano 1K** or **MAX II** board.

### Hardware

**Tang Nano 1K (Gowin):**
- **Clock:** 27MHz (pin 47)
- **Reset:** Button (pin 13, active low)
- **LEDs:** RGB (pins 10, 9, 11)

**MAX II (Altera):**
- **Clock:** 50MHz (depends on board)
- **Reset:** Button (depends on board)
- **LEDs:** Depends on board (check documentation)

### Verilog Code (Common)

```verilog
//=======================================================
// Project: Blink LED
// Board:   Tang Nano 1K (Gowin) or MAX II (Altera)
// Clock:   27MHz (Tang Nano) or 50MHz (MAX II)
// LEDs:    led[0]=R, led[1]=G, led[2]=B (RGB)
//=======================================================

module top (
    input        sys_clk,    // clock
    input        sys_rst_n,  // reset active low (button)
    output reg [2:0] led     // 3 LEDs: R=led[0], G=led[1], B=led[2]
);

    // 24-bit counter (~0.6s for 27MHz)
    reg [23:0] counter;

    // Increment counter
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            counter <= 24'd0;
        else if (counter < 24'd13499999)
            counter <= counter + 1'b1;
        else
            counter <= 24'd0;
    end

    // Rotate LEDs each counter cycle
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            led <= 3'b110;
        else if (counter == 24'd13499999)
            led[2:0] <= {led[1:0], led[2]};
        else
            led <= led;
    end

endmodule
```

> 💡 **Note:** For MAX II, adjust the counter value for the board's clock frequency.

---

---

# Workflow 1: Gowin IDE (Windows)

Development using **Gowin FPGA Designer** — complete graphical interface.

**Prerequisite:** Read [`GOWIN_INSTALL.md`](GOWIN_INSTALL.md) to install Gowin IDE.

---

## 1. Create Project

1. Open **Gowin FPGA Designer**
2. `File` → `New` → **FPGA Design Project** → OK
3. Configure:
   - **Project Name:** `blink` (use only letters and `_`)
   - **Project Path:** ex. `C:\fpga\tang_nano_1k\blink` (no spaces)
4. Click **Next**
5. Select device:
   - **Series:** GW1NZ
   - **Device:** GW1NZ-1
   - **Package:** QN48
   - **Speed:** C6/I5
   - **Part Number:** `GW1NZ-LV1QN48C6/I5`
6. Click **Finish**

---

## 2. Create Verilog File

1. `File` → `New` → **Verilog File** → OK
2. Save as `top.v` inside `src/` folder
3. Copy the Verilog code from [previous section](#verilog-code-common)

---

## 3. Synthesis (Synthesize)

1. In **Process** panel (left side), double-click **Synthesize**
2. Wait for completion (usually 1-2 minutes)

### Expected Messages (normal)

| Type | Code | Message |
|------|--------|----------|
| NOTE | EX0101 | Current top module is "top" |
| WARN | TA1132 | 'sys_clk' was determined to be a clock... |

✅ Success: `Finish synthesis, 0 error(s)`

---

## 4. Physical Constraints (`.cst`)

Maps Verilog ports to physical pins.

### Option A: Use Floorplanner (Recommended)

1. In **Process** panel, click **Floorplanner**
2. Drag ports to corresponding pins:
   - `sys_clk` → pin 47
   - `sys_rst_n` → pin 13
   - `led[0]` → pin 10
   - `led[1]` → pin 9
   - `led[2]` → pin 11
3. Save (Ctrl+S)

File `top.cst` is generated automatically.

### Option B: Create File Manually

1. `File` → `New` → **Physical Constraints File** → OK
2. Save as `top.cst`
3. Copy content:

```
IO_LOC "sys_clk"  47;
IO_PORT "sys_clk"  IO_TYPE=LVCMOS18 PULL_MODE=UP BANK_VCCIO=1.8;

IO_LOC "sys_rst_n" 13;
IO_PORT "sys_rst_n" IO_TYPE=LVCMOS18 PULL_MODE=UP BANK_VCCIO=1.8;

IO_LOC "led[0]" 10;
IO_PORT "led[0]" IO_TYPE=LVCMOS18 PULL_MODE=UP DRIVE=8 BANK_VCCIO=1.8;

IO_LOC "led[1]" 9;
IO_PORT "led[1]" IO_TYPE=LVCMOS18 PULL_MODE=UP DRIVE=8 BANK_VCCIO=1.8;

IO_LOC "led[2]" 11;
IO_PORT "led[2]" IO_TYPE=LVCMOS18 PULL_MODE=UP DRIVE=8 BANK_VCCIO=1.8;
```

---

## 5. Timing Constraints (`.sdc`)

Optional, but recommended to resolve warnings.

1. `File` → `New` → **Timing Constraints File** → OK
2. Save as `top.sdc`
3. Copy:

```tcl
# 27MHz clock — period = 37.037ns
create_clock -name sys_clk -period 37.037 -waveform {0 18.518} [get_ports {sys_clk}]
```

---

## 6. Place & Route

1. In **Process** panel, double-click **Place & Route**
2. Wait for completion

✅ Success: `Finish place and route, 0 error(s)`

O bitstream é gerado em: `impl/pnr/top.fs`

---

## 7. Programming

1. In **Process** panel, double-click **Program Device**
2. **Gowin Programmer** will open automatically

### Cable Configuration

1. `Edit` → `Cable Setting`
2. Click **Query/Detect Cable**
3. Verify:
   - **Cable:** USB Debugger A
   - **Port:** USB Debugger A/0/...
   - ✅ **using ftd2xx driver**
4. Click **Save**

### Program

1. Verify:
   - **Device:** GW1NZ-1
   - **Operation:** SRAM Program (temporary) or Flash Program (permanent)
   - **FS File:** path to `top.fs`
2. Click **Program/Configure** (green ▶)
3. Wait: `Program Done`

---

## Troubleshooting (Gowin IDE)

### Programmer hangs

```
Solution: Device Manager → uninstall JTAG Debugger
        Disconnect/reconnect USB → FTDI driver is reinstalled
```

### "No USB Cable Connection"

```
Solution: Same as above (incompatible driver)
```

### Invalid path / special characters

```
Solution: Move project to C:\fpga\my_project\ (no spaces/accents)
```

### LEDs don't blink

```
Possible causes:
1. Programmed to SRAM but powered off → use Flash Program
2. .fs file outdated → recompile
3. Wrong pins → check constraints
```

---

---

---

# Workflow 2: Quartus Prime Lite

Development using **Quartus Prime Lite** — Altera platform.

**Prerequisite:** Read [`QUARTUS_INSTALL.md`](QUARTUS_INSTALL.md) to install Quartus.

---

## 1. Create Project

1. Open **Quartus Prime Lite**
2. `File` → `New Project Wizard`
3. Configure:
   - **Project Name:** `blink`
   - **Project Directory:** ex. `C:\fpga\max_ii\blink\` or `/home/user/fpga/max_ii/blink/`
   - **Add Files to Project:** (leave blank for now)
4. Click **Next**
5. Select MAX II device:
   - **Family:** MAX II
   - **Device:** EPM570T100C5 (or other compatible MAX II)
6. Click **Finish**

---

## 2. Create Verilog File

1. `File` → `New`
2. Select **Verilog HDL File**
3. Copy code from [initial section](#verilog-code-common)
4. Save as `top.v`
5. `File` → `Project` → `Add Files...`
6. Select `top.v` and click **Add**

---

## 3. Synthesis

1. `Processing` → `Start Compilation`
2. Wait for compilation complete

✅ Success: No critical errors in **Messages** tab.

---

## 4. Physical Constraints (`.qsf`)

1. `Assignments` → `Pins`
2. Configure pins:

| Port Name | Pin # | IO Type |
|-----------|-------|---------|
| sys_clk | (check board) | LVCMOS |
| sys_rst_n | (check board) | LVCMOS |
| led[0] | (check board) | LVCMOS |
| led[1] | (check board) | LVCMOS |
| led[2] | (check board) | LVCMOS |

> **Note:** Pins depend on specific MAX II board. Check board documentation.

3. Save project (Ctrl+S)

---

## 5. Place & Route

Already done during compilation (step 3).

---

## 6. Generate Programming File

1. `File` → `Convert Programming Files`
2. Configure:
   - **Programming File Type:** SRAM Object File (`.svf`)
   - **Output File Name:** `blink.svf`
3. Click **Convert**

---

## 7. Programming

1. Connect board via **USB Blaster**
2. `Tools` → `Programmer`
3. Click **Hardware Setup** and select USB Blaster port
4. Click **Start** to program

---

## Troubleshooting (Quartus)

### USB Blaster not appearing

```
Solution: Check drivers (QUARTUS_INSTALL.md, Windows section)
        Reconnect USB cable
        jtagconfig (list devices)
```

### Compilation errors

```
Solution: Check pin names
        Confirm correct MAX II device
        Review Verilog code
```

---

---

# Workflow 3: VS Code + oss-cad-suite (Linux)

Development using **VS Code editor** + **oss-cad-suite toolchain** — open-source environment.

**Prerequisite:** Read [`TANG_NANO_LINUX.md`](TANG_NANO_LINUX.md) to install oss-cad-suite.

---

## 1. Project Structure

Create structure:

```bash
mkdir -p ~/fpga/tang_nano_blink
cd ~/fpga/tang_nano_blink

# Create folders
mkdir -p src constraints build
```

---

## 2. Verilog File

Create `src/top.v` with code from [initial section](#verilog-code-common).

```bash
nano src/top.v
# or open in VS Code
code src/top.v
```

---

## 3. Physical Constraints

Create `constraints/pins.cst` (Gowin):

```bash
cat > constraints/pins.cst << 'EOF'
IO_LOC "sys_clk"  47;
IO_PORT "sys_clk"  IO_TYPE=LVCMOS18 PULL_MODE=UP BANK_VCCIO=1.8;

IO_LOC "sys_rst_n" 13;
IO_PORT "sys_rst_n" IO_TYPE=LVCMOS18 PULL_MODE=UP BANK_VCCIO=1.8;

IO_LOC "led[0]" 10;
IO_PORT "led[0]" IO_TYPE=LVCMOS18 PULL_MODE=UP DRIVE=8 BANK_VCCIO=1.8;

IO_LOC "led[1]" 9;
IO_PORT "led[1]" IO_TYPE=LVCMOS18 PULL_MODE=UP DRIVE=8 BANK_VCCIO=1.8;

IO_LOC "led[2]" 11;
IO_PORT "led[2]" IO_TYPE=LVCMOS18 PULL_MODE=UP DRIVE=8 BANK_VCCIO=1.8;
EOF
```

---

## 4. Makefile

Create `Makefile` to automate compilation:

```makefile
# Tang Nano 1K (Gowin) Makefile

PROJ_NAME := top
DEVICE := GW1NZ-1
SRC_DIR := src
BUILD_DIR := build
CONSTR_DIR := constraints

# Tools
YOSYS := yosys
NEXTPNR := nextpnr-gowin
PACK := gowin_pack
LOADER := openFPGALoader

# Files
VERILOG := $(wildcard $(SRC_DIR)/*.v)
CONSTRAINTS := $(CONSTR_DIR)/pins.cst
TIMING := $(CONSTR_DIR)/timing.sdc

# Targets
.PHONY: all clean program detect

all: $(BUILD_DIR)/$(PROJ_NAME).fs

$(BUILD_DIR)/$(PROJ_NAME).json: $(VERILOG)
	mkdir -p $(BUILD_DIR)
	$(YOSYS) -m gw1n -d gw1n -p "synth_gowin -json $@ $(VERILOG)"

$(BUILD_DIR)/$(PROJ_NAME).asc: $(BUILD_DIR)/$(PROJ_NAME).json $(CONSTRAINTS)
	$(NEXTPNR) --json $< --asc $@ --device $(DEVICE) --cst $(CONSTRAINTS)

$(BUILD_DIR)/$(PROJ_NAME).fs: $(BUILD_DIR)/$(PROJ_NAME).asc
	$(PACK) -d $(DEVICE) -o $@ $<

program: $(BUILD_DIR)/$(PROJ_NAME).fs
	$(LOADER) -b tangnano1k -f $<

detect:
	$(LOADER) --detect

clean:
	rm -rf $(BUILD_DIR)
```

---

## 5. Compilation

```bash
# Compile everything
make all

# Or step by step
make detect              # Detect FPGA
make                    # Compile (creates top.fs)
```

---

## 6. Programming

```bash
# Program FPGA
make program

# Or manual
openFPGALoader -b tangnano1k build/top.fs
```

---

## 7. Complete Workflow

```bash
cd ~/fpga/tang_nano_blink

# 1. Connect Tang Nano via USB

# 2. Detect device
make detect

# 3. Modify code if needed
code src/top.v

# 4. Compile
make clean
make all

# 5. Program
make program

# 6. Verify LEDs blinking! 🎉
```

---

## Troubleshooting (VS Code + oss-cad-suite)

### "Command not found: yosys"

```bash
# Check environment variables
echo $PATH | grep oss-cad-suite

# If not present, add to ~/.bashrc
export PATH="/home/tools/oss-cad-suite/bin:$PATH"
source ~/.bashrc
```

### "Device not found"

```bash
# Check USB connection
lsusb | grep -i ftdi

# Test permissions
openFPGALoader --detect

# If it fails, may need sudo
sudo openFPGALoader --detect

# Or apply udev rules (TANG_NANO_LINUX.md)
```

### Compilation errors

```bash
# Clean build
make clean

# Recompile with verbose
yosys -v -m gw1n -d gw1n -p "synth_gowin -json build/top.json src/top.v"
```

---

---

# Workflow Comparison

| Aspect | Gowin IDE | Quartus | VS Code + oss-cad-suite |
|--------|-----------|---------|-------------------------|
| **OS** | Windows | Windows/Linux | Linux/macOS |
| **Interface** | Graphical GUI | Graphical GUI | Terminal + Editor |
| **License** | Free (Education) | Free (Lite) | Open-source |
| **Learning Curve** | ⭐⭐⭐ Easy | ⭐⭐ Medium | ⭐ Advanced |
| **Customization** | ⭐ Limited | ⭐⭐ Medium | ⭐⭐⭐ Full |
| **Script Support** | ❌ No | ⭐ Yes (TCL) | ⭐⭐⭐ Yes (Makefile) |
| **Debugging** | ⭐⭐ Simulation | ⭐⭐ Simulation | ⭐ RTL-level |
| **Compile Time** | ⭐⭐ ~2-3 min | ⭐⭐ ~2-3 min | ⭐⭐⭐ <1 min |
| **Toolchain Size** | ~2GB | ~10GB | ~1GB |

---

## When to Use?

### 🎯 Gowin IDE
- ✅ Beginners with graphical interface
- ✅ Quick visual development
- ✅ Windows only
- ✅ Tang Nano with Gowin

### 🎯 Quartus Prime
- ✅ Professional projects
- ✅ Altera/Intel devices
- ✅ License support (important)
- ✅ EDA integration

### 🎯 VS Code + oss-cad-suite
- ✅ Automated workflows
- ✅ Full control (scripts/Makefile)
- ✅ Open-source environment
- ✅ Git integration
- ✅ Linux/macOS

---

**Last update:** May 6, 2026
