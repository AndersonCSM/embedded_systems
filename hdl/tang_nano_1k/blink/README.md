# Tang Nano 1K — Blink Project

Simple blinking LED example for the **Tang Nano 1K** board using the open-source toolchain.

## Hardware

- Board: Tang Nano 1K
- FPGA: Gowin GW1NZ-1 (approx. 1k LUTs)
- Clock: internal 27 MHz oscillator
- LED: D6 (default red LED)

## Functionality

This project implements a 1 Hz blink (0.5s ON / 0.5s OFF).

## Architecture

```
27 MHz oscillator
    ↓
Frequency divider
    ↓
Toggle flip-flop
    ↓
LED output (D6)
```

## Build

### Prerequisites

- `oss-cad-suite` (yosys, nextpnr-nexus, apicula) installed locally (recommended under `~/tools/oss-cad-suite/`), or available on `PATH`.
- Run the setup script first: `bash scripts/setup_tang_nano_safe.sh`
- `make`, `bash`

### Commands

```bash
# Full flow: synthesis, place & route, pack
make all

# Or step-by-step
make synth
make place
make pack
```

## Programming

### Using openFPGALoader (recommended)

```bash
make program
```

### Manual

```bash
openFPGALoader -b tangnano1k blink.fs
```

## Project files

| File | Description |
|------|-------------|
| `top.sv` | Top-level SystemVerilog source |
| `constraints.cst` | Pin mapping (Gowin format) |
| `Makefile` | Build system |
| `build.sh` | Build helper script |
| `blink.json` | Synth intermediate (generated) |
| `blink.config` | Place & route intermediate (generated) |
| `blink.fs` | Final bitstream (generated) |

## Pins

| Name | Pin | Function |
|------|-----|----------|
| `led` | D6 | LED output |
| `clk` | internal | 27 MHz oscillator |

## Troubleshooting

### Toolchain not found

Ensure the toolchain is available or source the board shell profile if provided:

```bash
source ../../.bashrc_tang_nano || true
```

### oss-cad-suite not available

Check that `oss-cad-suite` has an executable `yosys` in its `bin/` folder:

```bash
ls -la ../oss-cad-suite/bin/ || true
```

### FPGA does not program

1. Check the USB cable.
2. Try bootloader mode:

```bash
openFPGALoader -b tangnano1k -m JTAG blink.fs
```

## Next steps

- Add a button to toggle the LED
- Implement PWM for brightness control
- Add UART for communication
- Add a PLL for higher clocking options

## References

- [Gowin FPGA Documentation](https://www.gowinsemi.com/)
- [oss-cad-suite](https://github.com/YosysHQ/oss-cad-suite-build)
- [Tang Nano 1K Schematic](https://dl.sipeed.com/shareURL/TANG/Nano%201k/7_Schematic)
