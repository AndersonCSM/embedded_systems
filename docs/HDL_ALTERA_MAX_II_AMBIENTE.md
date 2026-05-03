# Ambiente de desenvolvimento para placas Altera MAX II

Guia generico para configurar ambiente de desenvolvimento para placas baseadas em Altera MAX II.

## Escopo

Este documento cobre o setup comum para placas MAX II:
- Quartus Prime Lite (fluxo principal)
- USB Blaster
- Programacao via `quartus_pgm` com `.svf`

## Observacao importante

Para MAX II, use `quartus_pgm` como fluxo principal de programacao.
O openFPGALoader nao e o caminho principal para MAX II.

## 1) Instalar Quartus Prime Lite

Exemplo (Linux):

```bash
tar -xzf Quartus-lite-20.1.0.711-linux.tar.gz
cd quartus/
./setup.sh
```

## 2) Variaveis de ambiente

```bash
cat >> ~/.bashrc << 'EOF'

# Quartus Prime 20.1
export QUARTUS_ROOTDIR="$HOME/intelFPGA_lite/20.1/quartus"
export PATH=$QUARTUS_ROOTDIR/bin:$PATH
export LD_LIBRARY_PATH=$QUARTUS_ROOTDIR/linux64:$LD_LIBRARY_PATH
EOF

source ~/.bashrc
```

Verificacao:

```bash
quartus --version
jtagconfig
```

## 3) Configurar USB Blaster (udev)

```bash
sudo bash -c 'cat > /etc/udev/rules.d/51-altera-usb-blaster.rules << "EOF"
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

## 4) Programar MAX II

```bash
cd hdl/max_ii/blink
quartus_pgm -c "1-2" -m JTAG -o "P;top.svf"
```

## 5) Diagnostico rapido

```bash
lsusb | grep Altera
jtagconfig
quartus_pgm -l
```

## Nota sobre openFPGALoader

Se necessario, pode ser instalado para diagnosticos auxiliares, mas nao substitui o fluxo padrao com Quartus para MAX II.

## Referencias

- Quartus Prime Lite (Intel)
- USB Blaster udev rules
- openFPGALoader: https://github.com/trabucayre/openFPGALoader
