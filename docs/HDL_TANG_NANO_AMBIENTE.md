# Tang Nano Development Environment

Generic setup guide for the Tang Nano family (1K, 20K, and similar boards).

## Scope

This document covers the common environment for Tang Nano boards:
- Open-source toolchain with `oss-cad-suite`
- Synthesis / place & route for Gowin flow
- Programming using `openFPGALoader`

## Important

The `oss-cad-suite/` directory is not tracked in Git due to size. After cloning, each user should install the toolchain locally.

## Recommended layout per board

```text
hdl/
  tang_nano_1k/
    blink/
    oss-cad-suite/   # local, ignored by Git
  tang_nano_20k/
    ...
```

## Prerequisites

- Linux / macOS / WSL
- Disk space (recommended >= 5 GB)
- Internet access to download the toolchain

## Installing oss-cad-suite

Option A (recommended): use the repository setup script when available:

```bash
cd hdl/tang_nano_1k
bash ../../scripts/setup_tang_nano_safe.sh
```

Option B (manual):

```bash
wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/VERSION/oss-cad-suite-linux-x64.tgz
tar -xzf oss-cad-suite-linux-x64.tgz
```

Extract the toolchain into the board folder or to a global location such as `~/tools/oss-cad-suite/` and add its `bin/` to your `PATH`.

## Expected tools

- `yosys`
- `nextpnr-*` (varies by flow)
- `gowin_pack` / `apicula`
- `openFPGALoader`

## Quick check

```bash
yosys --version
openFPGALoader --version
```

## Build and programming example

```bash
cd hdl/tang_nano_1k/blink
make all
make program
```

## Quick troubleshooting

### oss-cad-suite not found

- Ensure the `oss-cad-suite/` directory is extracted in the expected board folder or that its `bin/` is on your `PATH`.

### USB permissions when programming

- Reapply udev rules and reconnect the board.
- Re-login to apply new group permissions.

## References

- https://github.com/YosysHQ/oss-cad-suite-build
- https://github.com/trabucayre/openFPGALoader
- https://www.gowinsemi.com/
