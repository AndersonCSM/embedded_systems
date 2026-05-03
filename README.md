## About
Repository organized around embedded systems projects, with a simpler layout grouped by technology and board.

## Structure
```text
embedded_systems/
├── README.md
├── docs/
├── hdl/
│   ├── tang_nano_1k/
│   ├── tang_nano_20k/
│   ├── max_ii/
│   └── common/
├── embedded/
│   ├── pico/
│   ├── keystudio/
│   └── common/
├── scripts/
├── course/
├── embarcatech/
└── archive/
```

## Notes
- `hdl/` groups FPGA/SystemVerilog material.
- `embedded/` groups microcontroller projects.
- `scripts/` holds setup and automation helpers.
- `course/` keeps class material.
- `embarcatech/` keeps legacy or course-specific content.
- `archive/` is for old or inactive material.
- Heavy toolchains such as `oss-cad-suite/` are intentionally ignored in Git and must be installed locally.

## Technologies
- Raspberry pi pico;
- C and C++;
- Python3 and MicroPython.

## First setup after clone

- See `docs/PRIMEIRO_SETUP.md` for a quick onboarding guide.

## HDL environment guides

- Tang Nano family: `docs/HDL_TANG_NANO_AMBIENTE.md`
- Altera MAX II family: `docs/HDL_ALTERA_MAX_II_AMBIENTE.md`
