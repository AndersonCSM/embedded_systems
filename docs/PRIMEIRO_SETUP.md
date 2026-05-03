## First setup after clone

This quickstart explains the minimal steps to get started after cloning the repository.

1) Clone the repository

```bash
git clone https://github.com/AndersonCSM/EmbeddedSystems.git
cd EmbeddedSystems
```

2) Verify the main layout

- `hdl/`: FPGA / HDL projects
- `embedded/`: microcontroller projects
- `scripts/`: setup and automation scripts

3) Heavy dependencies (install locally)

Large toolchains such as `oss-cad-suite/` are ignored in Git due to size. Install them locally on your machine.

Tang Nano 1K (HDL) example:

```bash
cd hdl/tang_nano_1k
bash ../../scripts/setup_tang_nano_safe.sh
```

Recommendation: install `oss-cad-suite` under `~/tools/oss-cad-suite/` or another local path and add its `bin/` to your `PATH`.

4) First build (examples)

Tang Nano 1K

```bash
cd hdl/tang_nano_1k/blink
make all
```

Raspberry Pi Pico (CMake example)

```bash
cd embedded/pico/blink
cmake -S . -B build
cmake --build build
```

5) Best practices

- Do not commit locally downloaded toolchains.
- Keep build artifacts out of version control.
- Read the board-level README before building.
