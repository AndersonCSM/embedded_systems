#!/usr/bin/env make

# Tang Nano 1K Blink Project Makefile
# Uses oss-cad-suite (yosys + nextpnr + apicula)

TOOLCHAIN_PATH ?= ../oss-cad-suite
YOSYS = $(TOOLCHAIN_PATH)/bin/yosys
NEXTPNR = $(TOOLCHAIN_PATH)/bin/nextpnr-nexus
APICULA = $(TOOLCHAIN_PATH)/bin/gowin_pack
PACK = $(TOOLCHAIN_PATH)/bin/gowin_pack

# Device settings for Tang Nano 1K (GW1NZ-1)
DEVICE = GW1NZ-1
FAMILY = GW1N
PART_ID = GW1NZ-1

# Files
SOURCE = top.sv
CONSTRAINTS = constraints.cst
PROJECT_NAME = blink

# Build outputs
JSON = $(PROJECT_NAME).json
CONFIG = $(PROJECT_NAME).config
BITSTREAM = $(PROJECT_NAME).fs

.PHONY: all clean synth place route pack program

all: $(BITSTREAM)

# 1. Synthesis: Verilog → JSON
$(JSON): $(SOURCE)
	@echo "=== Synthesis (Yosys) ==="
	$(YOSYS) -m gw_sh -p "read_verilog $(SOURCE); synth_gowin -json $(JSON)"

# 2. Place & Route: JSON → Config
$(CONFIG): $(JSON) $(CONSTRAINTS)
	@echo "=== Place & Route (nextpnr) ==="
	$(NEXTPNR) --json $(JSON) --write $(CONFIG) --device $(PART_ID) --cst $(CONSTRAINTS)

# 3. Pack: Config → Bitstream
$(BITSTREAM): $(CONFIG)
	@echo "=== Bitstream Generation (apicula) ==="
	$(PACK) $(CONFIG) -d $(DEVICE) -o $(BITSTREAM)

synth: $(JSON)

place: $(CONFIG)

route: $(CONFIG)

pack: $(BITSTREAM)

program: $(BITSTREAM)
	@echo "=== Programming FPGA ==="
	openFPGALoader -b tangnano1k $(BITSTREAM)

clean:
	@echo "=== Cleaning build files ==="
	rm -f $(JSON) $(CONFIG) $(BITSTREAM)
	rm -f *.rpt *.log

help:
	@echo "Tang Nano 1K Blink - Makefile targets:"
	@echo "  make all      - Build complete project (default)"
	@echo "  make synth    - Synthesis only"
	@echo "  make place    - Place & Route"
	@echo "  make pack     - Generate bitstream"
	@echo "  make program  - Program FPGA (requires openFPGALoader)"
	@echo "  make clean    - Remove build artifacts"
