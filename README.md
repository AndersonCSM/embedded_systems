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
│   └── max_ii/
├── embedded/
│   ├── pico/
│   └── keystudio/
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

## Technologies
- Raspberry pi pico zero 2W and pi pico, esp32, CPLD max II, Sipeed tang nano, FPGA  boardAltera de2 115;
- C and C++;
- System Verilog;
- Python3 and MicroPython.

## First setup after clone

- See `docs/FIRST_SETUP.md` for a quick onboarding guide.

## HDL environment guides

- Tang Nano family: [docs/HDL_TANG_NANO_ENVIRONMENT.md](docs/HDL_TANG_NANO_ENVIRONMENT.md)
- Altera MAX II family: [docs/HDL_ALTERA_MAX_II_AMBIENTE.md](docs/HDL_ALTERA_MAX_II_AMBIENTE.md)
