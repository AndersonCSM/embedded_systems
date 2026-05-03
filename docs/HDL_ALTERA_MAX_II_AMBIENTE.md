# Altera MAX II Development Environment

Generic guide for setting up development for boards based on Altera MAX II.

## Scope

This document covers the common setup for MAX II boards:
- Quartus Prime Lite (primary flow)
- USB Blaster
- Programming via `quartus_pgm` with `.svf` files

## Important note

For MAX II devices use `quartus_pgm` as the primary programming tool. `openFPGALoader` can be used for auxiliary diagnostics but does not replace the Quartus flow.

1) Install Quartus Prime Lite (example for Linux):

```bash
tar -xzf Quartus-lite-20.1.0.711-linux.tar.gz
cd quartus/
./setup.sh
```

2) Environment variables

```bash
cat >> ~/.bashrc << 'EOF'

# Quartus Prime 20.1
export QUARTUS_ROOTDIR="$HOME/intelFPGA_lite/20.1/quartus"
export PATH=$QUARTUS_ROOTDIR/bin:$PATH
export LD_LIBRARY_PATH=$QUARTUS_ROOTDIR/linux64:$LD_LIBRARY_PATH
EOF

source ~/.bashrc
```

Verify:

```bash
quartus --version
jtagconfig
```

3) Configure USB Blaster udev rules

```bash
sudo bash -c 'cat > /etc/udev/rules.d/51-altera-usb-blaster.rules << "EOF"'
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6001", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6002", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6003", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6010", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6810", MODE="0666"
EOF'

sudo udevadm control --reload-rules
sudo udevadm trigger
sudo usermod -a -G dialout $USER
```

4) Programming MAX II

```bash
cd hdl/max_ii/blink
quartus_pgm -c "1-2" -m JTAG -o "P;top.svf"
```

5) Quick diagnostics

```bash
lsusb | grep Altera
jtagconfig
quartus_pgm -l
```

## Notes on openFPGALoader

If needed, `openFPGALoader` can be installed for additional diagnostics, but it does not replace the Quartus programming flow for MAX II devices.

## References

- Quartus Prime Lite (Intel)
- USB Blaster udev rules
- openFPGALoader: https://github.com/trabucayre/openFPGALoader
