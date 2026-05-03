# Tang Nano 9K - Setup Seguro v2.0

## O que causou o travamento?

Analisando os logs do sistema, identifiquei 3 problemas:

### 1. **Extensões GNOME Shell com conflito**
- `tilingshell` e `dash-to-panel` geravam erros de objetos dispostos
- Causava loops no gerenciador de janelas (gnome-shell)
- Sistema ficava congelado

### 2. **Erro ACPI PowerButton**
```
ACPI Error: No installed handler for fixed event - PowerButton (2)
```
- Driver não estava corretamente instalado
- Pior ainda se houve comando sudo prejudicial executado

### 3. **Script openfpgaloader-ubuntufix perigoso**
- O script `curl ... | sh` executava operações de udev sem validação
- Sem logs = impossível debugar o que deu errado
# Tang Nano Setup — Safe Installer (v2.0)

This document explains the secure setup script and how to validate the installation of the open-source FPGA toolchain for Tang Nano boards.

## Root causes of previous failures

When analyzing system logs, three common issues were identified:

1. Conflicting GNOME Shell extensions (e.g. `tilingshell`, `dash-to-panel`) that caused shell instability.
2. ACPI errors related to the PowerButton handler on some systems.
3. Unsafe installer scripts piped from the network (`curl | sh`) that modify udev rules without logging.

## Using the safe setup script

1. Make the script executable:

```bash
chmod +x scripts/setup_tang_nano_safe.sh
```

2. Run the script:

```bash
bash scripts/setup_tang_nano_safe.sh
```

3. What the script does

- Checks disk space and available RAM.
- Verifies `oss-cad-suite` is available (recommended location: `~/tools/oss-cad-suite/`).
- Configures `PATH` and shells.
- Tests `yosys` and `nextpnr-nexus`.
- Installs `openFPGALoader` via the system package manager (avoid unsafe external scripts).
- Configures udev rules for FPGA programming devices.
- Writes a detailed log for debugging.

4. Verify results

```bash
# Check logs created by the script (either in the current directory or under ~/)
ls -1 tang_nano_setup_*.log || true

# Verify tools
source ~/.bashrc
yosys --version || true
nextpnr-nexus --help || true
```

## Expected toolchain layout

Recommended location:

```
~/tools/oss-cad-suite/
├── bin/
│   ├── yosys
│   ├── nextpnr-nexus
│   └── ...
├── lib/
└── share/
```

If you extracted the toolchain elsewhere, move it into `~/tools/` or add its `bin/` to your `PATH`.

## Best practices

- Avoid running `curl | sh` without reviewing the script.
- Use the system package manager when possible.
- Add logging (`tee`) and `set -e` to sensitive setup scripts.

## Next steps

1. Run the setup script:

```bash
bash scripts/setup_tang_nano_safe.sh
```

2. Reload your shell:

```bash
source ~/.bashrc
```

3. Test the board:

```bash
lsusb | grep Sipeed
openfpgaloader --detect
```

4. Build a test project (example):

```bash
cd hdl/tang_nano_1k/blink
yosys -p "read_verilog top.sv; synth_gowin -json blink.json" || true
nextpnr-nexus --json blink.json --asc blink.asc || true
```

## Troubleshooting

### "oss-cad-suite not found"

```bash
find ~ -name "oss-cad-suite" -type d
# If found, move it to ~/tools
mkdir -p ~/tools
mv /path/found ~/tools/oss-cad-suite
```

### udev rule failures

```bash
sudo groupadd --system plugdev 2>/dev/null || true
sudo usermod -a -G plugdev $USER
newgrp plugdev
```

### openFPGALoader installation

```bash
git clone https://github.com/trabucayre/openFPGALoader
cd openFPGALoader
mkdir build && cd build
cmake ..
make
sudo make install
```

## Notes

Updated: 30/04/2026
Version: 2.0 — assumes oss-cad-suite already extracted
find ~/ -name "oss-cad-suite" -type d
