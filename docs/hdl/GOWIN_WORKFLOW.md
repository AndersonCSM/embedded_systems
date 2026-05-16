# Gowin FPGA - Generic Development Workflow

This guide describes a **100% external and portable development workflow** for Gowin FPGAs (such as Tang Nano 20K, 1K, etc) using Yosys, nextpnr-himbaechel, Apicula, and openFPGALoader.

## Prerequisites

- `oss-cad-suite` installed (contains Yosys, nextpnr, and Apicula)
- `openFPGALoader` installed
- Project files:
  - `<project>.v` - Verilog code
  - `<project>.cst` - pin mapping (constraints)
  - `Makefile` - build automation

## Development Flow

```
<project>.v + <project>.cst
    ↓
  YOSYS (Synthesis)
    ↓
<project>.json (netlist)
    ↓
nextpnr-himbaechel (Place & Route)
    ↓
<project>_pnr.json (design with placement)
    ↓
Apicula (Bitstream Generation)
    ↓
<project>.fs (bitstream)
    ↓
openFPGALoader (Programming)
    ↓
FPGA running! 🎉
```

## Complete Makefile

```makefile
# Gowin FPGA - Build System
# Flow: Synthesis → Place & Route → Bitstream → Programming
# Compatible with: Tang Nano 20K, 1K, and other Gowin devices

# ============================================================================
# TOOL CONFIGURATION
# ============================================================================

TOOLS_DIR := /home/anderson/tools/oss-cad-suite
YOSYS := $(TOOLS_DIR)/bin/yosys
NEXTPNR := $(TOOLS_DIR)/bin/nextpnr-himbaechel
PYTHON := $(TOOLS_DIR)/py3bin/python3
OPENOCDLOADER := openFPGALoader

# ============================================================================
# PROJECT CONFIGURATION - EDIT HERE
# ============================================================================

PROJECT := my_project
TOP_MODULE := top
DEVICE := GW2A-18C              # Change according to your device
FAMILY := GW2A-18C              # Change according to your device
FPGA_BOARD := tangnano20k       # Change according to your board

# Input files
VERILOG_FILES := my_project.v
CST_FILE := my_project.cst

# Output files
JSON_SYNTH := $(PROJECT).json
JSON_PNR := $(PROJECT)_pnr.json
BITSTREAM := $(PROJECT).fs
LOG_SYNTH := $(PROJECT)_synth.log
LOG_PNR := $(PROJECT)_pnr.log

# ============================================================================
# MAIN TARGETS
# ============================================================================

.PHONY: all synth pnr pack program clean help

all: program

help:
	@echo "Gowin FPGA Build System"
	@echo "======================="
	@echo ""
	@echo "Targets:"
	@echo "  make synth     - Synthesis with Yosys"
	@echo "  make pnr       - Place & Route with nextpnr-himbaechel"
	@echo "  make pack      - Generate bitstream with Apicula"
	@echo "  make program   - Program FPGA with openFPGALoader"
	@echo "  make all       - Run complete flow"
	@echo "  make clean     - Clean generated files"
	@echo ""

# ============================================================================
# SYNTHESIS WITH YOSYS
# ============================================================================

synth: $(JSON_SYNTH)

$(JSON_SYNTH): $(VERILOG_FILES) $(CST_FILE)
	@echo "╔════════════════════════════════════════╗"
	@echo "║  SYNTHESIS WITH YOSYS                  ║"
	@echo "╚════════════════════════════════════════╝"
	@echo "Reading Verilog: $(VERILOG_FILES)"
	@echo "Constraints file: $(CST_FILE)"
	@echo "Target device: $(DEVICE)"
	@echo ""
	@$(YOSYS) -p "read_verilog $(VERILOG_FILES); synth_gowin -json $(JSON_SYNTH)" \
		2>&1 | tee $(LOG_SYNTH)
	@echo ""
	@echo "✓ Synthesis complete: $(JSON_SYNTH)"
	@echo ""

# ============================================================================
# PLACE & ROUTE WITH NEXTPNR-HIMBAECHEL
# ============================================================================

pnr: $(JSON_PNR)

$(JSON_PNR): $(JSON_SYNTH) $(CST_FILE)
	@echo "╔════════════════════════════════════════╗"
	@echo "║  PLACE & ROUTE WITH NEXTPNR-HIMBAECHEL ║"
	@echo "╚════════════════════════════════════════╝"
	@echo "Input netlist: $(JSON_SYNTH)"
	@echo "Constraints: $(CST_FILE)"
	@echo "Device: $(DEVICE)"
	@echo "Family: $(FAMILY)"
	@echo ""
	@$(NEXTPNR) --device $(DEVICE) --vopt family=$(FAMILY) \
		--vopt cst=$(CST_FILE) \
		--json $(JSON_SYNTH) \
		--write $(JSON_PNR) \
		2>&1 | tee $(LOG_PNR)
	@echo ""
	@echo "✓ Place & Route complete: $(JSON_PNR)"
	@echo ""

# ============================================================================
# BITSTREAM GENERATION WITH APICULA
# ============================================================================

pack: $(BITSTREAM)

$(BITSTREAM): $(JSON_PNR)
	@echo "╔════════════════════════════════════════╗"
	@echo "║  BITSTREAM GENERATION WITH APICULA     ║"
	@echo "╚════════════════════════════════════════╝"
	@echo "Design with placement: $(JSON_PNR)"
	@echo "Device: $(DEVICE)"
	@echo ""
	@$(PYTHON) -m apycula.pack -d $(DEVICE) $(JSON_PNR) -o $(BITSTREAM)
	@echo ""
	@echo "✓ Bitstream generated: $(BITSTREAM)"
	@ls -lh $(BITSTREAM)
	@echo ""

# ============================================================================
# FPGA PROGRAMMING
# ============================================================================

program: $(BITSTREAM)
	@echo "╔════════════════════════════════════════╗"
	@echo "║  FPGA PROGRAMMING                      ║"
	@echo "╚════════════════════════════════════════╝"
	@echo "Bitstream: $(BITSTREAM)"
	@echo "Board: $(FPGA_BOARD)"
	@echo ""
	@echo "Connecting to FPGA..."
	@$(OPENOCDLOADER) -b $(FPGA_BOARD) $(BITSTREAM)
	@echo ""
	@echo "✓ FPGA programmed successfully!"
	@echo ""

# ============================================================================
# CLEANUP
# ============================================================================

clean:
	@echo "Cleaning build files..."
	@rm -f $(JSON_SYNTH) $(JSON_PNR) $(BITSTREAM)
	@rm -f $(LOG_SYNTH) $(LOG_PNR)
	@rm -f *.vcd *.gtkw
	@echo "✓ Cleanup complete"

# ============================================================================
# ADDITIONAL RULES
# ============================================================================

# Show design info after synthesis
info-synth: $(JSON_SYNTH)
	@echo "Synthesis JSON info:"
	@python3 -c "import json; d=json.load(open('$(JSON_SYNTH)')); print(f'Modules: {len(d[\"modules\"])}')"

# Show statistics after PnR
info-pnr: $(JSON_PNR)
	@echo "Place & Route JSON info:"
	@python3 -c "import json; d=json.load(open('$(JSON_PNR)')); print(f'Modules: {len(d[\"modules\"])}')"

# Remove bitstream and rebuild only bitstream and programming
reprogram: $(BITSTREAM)
	@echo "Reprogramming FPGA..."
	@$(OPENOCDLOADER) -b $(FPGA_BOARD) $(BITSTREAM)
```

## Getting Started

### 1. **Edit the Makefile for your board:**

```makefile
# Edit these 4 variables at the beginning of the Makefile
PROJECT := your_project
DEVICE := GW2A-18C            # Change according to your device
FAMILY := GW2A-18C
FPGA_BOARD := tangnano20k     # See device support table below
```

### 2. **Build and program:**

```bash
cd your_project_directory
make all                    # Build everything
make program                # Program the FPGA
```

## Understanding Each Step

### **YOSYS (Synthesis)**
- Reads the Verilog file
- Optimizes the logic
- Generates netlist in JSON format
- Maps to Gowin cells (LUTs, DFFs, ALUs, etc)

### **nextpnr-himbaechel (Place & Route)**
- Takes the netlist and applies constraints
- Places cells on the FPGA (placement)
- Connects with wires (routing)
- Calculates maximum frequency

### **Apicula (Bitstream)**
- Converts the final design into bits the FPGA understands
- Generates `.fs` file (Filesize)

### **openFPGALoader (Programming)**
- Communicates with FPGA via USB
- Transfers bitstream to internal memory
- FPGA starts executing the design

## Environment Variables (Optional)

If tools are not in `/home/anderson/tools/`, you can:

```bash
# Point to another installation
export OSS_CAD_SUITE=/your/path/oss-cad-suite
make
```

Or edit in the Makefile:
```makefile
TOOLS_DIR := /your/path/oss-cad-suite
```

## Device Support

To change devices, edit these variables in the Makefile:

| Board | FPGA_BOARD | DEVICE | FAMILY |
|-------|------------|--------|--------|
| Tang Nano 20K | tangnano20k | GW2A-18C | GW2A-18C |
| Tang Nano 1K | tangnano1k | GW1NZ-1 | GW1N |
| Tang Nano 9K | tangnano9k | GW1N-9C | GW1N |
| Tang Nano 4K | tangnano4k | GW1NS-4 | GW1N |

Or use variables from the command line:
```bash
make DEVICE=GW1NZ-1 FAMILY=GW1N FPGA_BOARD=tangnano1k all
```

Complete example for Tang Nano 1K:
```bash
make PROJECT=my_project DEVICE=GW1NZ-1 FAMILY=GW1N FPGA_BOARD=tangnano1k program
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `nextpnr-himbaechel: command not found` | Check `TOOLS_DIR` in Makefile |
| `ERROR: Invalid device` | Verify `DEVICE` is correct (e.g., `GW2A-18C`) |
| `openFPGALoader: command not found` | Install: `sudo apt install openfpgaloader` |
| FPGA doesn't blink after programming | Check LED pin in `<project>.cst` |
| Pin constraint errors | Verify all module ports are mapped in CST file |

## Expected File Structure

```
your_project/
├── Makefile              ← Copy from this guide
├── GOWIN_WORKFLOW.md     ← This documentation
├── your_project.v        ← Verilog code (EDIT)
├── your_project.cst      ← Pin constraints (EDIT)
├── your_project.json     ← Generated: synthesis netlist
├── your_project_pnr.json ← Generated: routed design
├── your_project.fs       ← Generated: final bitstream
├── your_project_synth.log ← Synthesis log
└── your_project_pnr.log  ← Place & Route log
```

## Step-by-Step: Creating a New Project

1. **Create project directory**
   ```bash
   mkdir my_project
   cd my_project
   ```

2. **Copy Makefile template** from this guide

3. **Edit configuration** - update PROJECT, DEVICE, FAMILY, FPGA_BOARD

4. **Create Verilog file** - write your `my_project.v`

5. **Create constraints file** - map pins in `my_project.cst`

6. **Build and test**
   ```bash
   make synth    # Test synthesis
   make pnr      # Test place & route
   make program  # Program FPGA
   ```

## Recommended .gitignore

```
# Generated files
*.json
*.fs
*.log
*.vcd
*.gtkw

# Build artifacts
db/
incremental_db/
output_files/
simulation/
```

## Resources

- [Yosys Handbook](http://www.clifford.at/yosys/)
- [nextpnr Documentation](https://nextpnr.readthedocs.io/)
- [Apicula Project](https://github.com/YosysHQ/apicula)
- [openFPGALoader](https://github.com/trabucayre/openFPGALoader)
- [oss-cad-suite](https://github.com/YosysHQ/oss-cad-suite)

---

**Created for Linux development with oss-cad-suite**  
**Portable for any Gowin FPGA project**
