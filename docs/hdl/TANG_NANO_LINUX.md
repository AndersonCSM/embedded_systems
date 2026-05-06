# Tang Nano no Linux — Guia Completo

Guia de instalação e configuração do toolchain `oss-cad-suite` para desenvolvimento FPGA com Tang Nano no Linux.

**Plataformas:** Tang Nano 1K, 20K e variantes  
**Toolchain:** `oss-cad-suite` (Yosys, nextpnr, openFPGALoader)  
**Suporte:** Linux (Ubuntu 20.04+, Debian, Fedora, etc.)

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Pré-requisitos](#pré-requisitos)
3. [Instalação do oss-cad-suite](#instalação-do-oss-cad-suite)
4. [Configuração de Variáveis de Ambiente](#configuração-de-variáveis-de-ambiente)
5. [Instalação de OpenFPGALoader](#instalação-de-openfpgaloader)
6. [Configuração USB/Drivers](#configuração-usbdrivers)
7. [Verificação de Instalação](#verificação-de-instalação)
8. [Uso Básico](#uso-básico)
9. [Troubleshooting](#troubleshooting)

---

## Visão Geral

Para trabalhar com **Tang Nano** no Linux, você precisa:

| Ferramenta | Função |
|------------|--------|
| **oss-cad-suite** | Síntese, Place & Route, Bitstream (Yosys + nextpnr) |
| **openFPGALoader** | Programador FPGA via USB/JTAG |
| **Drivers USB** | Comunicação com FPGA |

### Layout Recomendado

```bash
/home/tools/
  oss-cad-suite/        # Instalação global (compartilhada)
    bin/
    lib/
    share/

hdl/
  tang_nano_1k/
    blink/              # Projetos
    teste/
  tang_nano_20k/
```

---

## Pré-requisitos

- **Linux:** Ubuntu 20.04 LTS ou posterior (recomendado)
- **Espaço em disco:** ≥ 5 GB
- **Acesso à internet:** Para download dos toolchains
- **Acesso root/sudo:** Para instalação global

### Dependências do Sistema

#### Ubuntu/Debian

```bash
sudo apt update
sudo apt install -y \
    build-essential \
    git \
    cmake \
    pkg-config \
    libusb-1.0-0-dev \
    libusb-1.0-0 \
    python3 \
    python3-pip \
    python3-dev \
    libftdi1-dev \
    libftdi-dev \
    libmpsse-dev
```

#### Fedora/RHEL

```bash
sudo dnf install -y \
    gcc \
    g++ \
    git \
    cmake \
    pkg-config \
    libusbx-devel \
    python3 \
    python3-devel \
    libftdi-devel
```

---

## Instalação do oss-cad-suite

### Opção A: Instalação Global (Recomendada)

Instalar em `/home/tools/` para compartilhar entre projetos.

```bash
# Criar diretório
sudo mkdir -p /home/tools
cd /home/tools

# Determinar versão (substituir VERSION pela tag mais recente)
# Acesse: https://github.com/YosysHQ/oss-cad-suite-build/releases

# Fazer download (Linux x64)
VERSION="2024-01-01"  # Exemplo: ajuste para a versão mais recente
wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${VERSION}/oss-cad-suite-linux-x64-${VERSION}.tgz

# Extrair
sudo tar xzf oss-cad-suite-linux-x64-${VERSION}.tgz

# Remover arquivo compactado
sudo rm oss-cad-suite-linux-x64-${VERSION}.tgz

# Verificar instalação
ls -la /home/tools/oss-cad-suite/bin/
```

### Opção B: Instalação Local (Projeto Específico)

Se preferir instalar apenas para um projeto:

```bash
cd hdl/tang_nano_1k

# Download e extração
wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/VERSION/oss-cad-suite-linux-x64.tgz
tar xzf oss-cad-suite-linux-x64.tgz
rm oss-cad-suite-linux-x64.tgz

# Usar path local em vez de global
```

---

## Configuração de Variáveis de Ambiente

### 1. Editar `~/.bashrc`

```bash
nano ~/.bashrc
# ou
vim ~/.bashrc
```

### 2. Adicionar ao Final do Arquivo

```bash
# === oss-cad-suite (FPGA Tang Nano) ===
export FPGA_TOOLS="/home/tools/oss-cad-suite"
export PATH="${FPGA_TOOLS}/bin:$PATH"
export LD_LIBRARY_PATH="${FPGA_TOOLS}/lib:$LD_LIBRARY_PATH"
```

### 3. Recarregar Configuração

```bash
source ~/.bashrc
```

### 4. Verificar

```bash
yosys --version
nextpnr-gowin --version
openFPGALoader --version
```

---

## Instalação de OpenFPGALoader

**openFPGALoader** é o programador para carregar bitstreams na FPGA.

### Opção A: Via Pacote (Se Disponível)

```bash
sudo apt install openfpgaloader
```

### Opção B: Compilar do Source (Recomendado)

```bash
# Clonar repositório
git clone https://github.com/trabucayre/openFPGALoader.git
cd openFPGALoader

# Criar diretório de build
mkdir build && cd build

# Configurar CMake
cmake -DCMAKE_BUILD_TYPE=Release ..

# Compilar (use todos os cores)
make -j$(nproc)

# Instalar globalmente
sudo make install

# Ou instalar localmente
mkdir -p ~/.local/bin
cp openFPGALoader ~/.local/bin/
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Verificação

```bash
openFPGALoader --version
```

---

## Configuração USB/Drivers

### 1. Conectar Tang Nano

Conecte a placa via USB-C.

### 2. Criar Regras udev

```bash
sudo tee /etc/udev/rules.d/99-fpga.rules > /dev/null << 'EOF'
# Anlogic FPGA (Tang Nano, etc.)
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", MODE="0666"

# Outros dispositivos Gowin/FTDI
SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6014", MODE="0666"
EOF
```

### 3. Recarregar Regras

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

### 4. Adicionar Usuário ao Grupo (Opcional, para evitar sudo)

```bash
sudo usermod -a -G dialout $USER
sudo usermod -a -G plugdev $USER

# Fazer login novamente para aplicar
exit
# Reconecte ou execute:
# newgrp dialout
```

---

## Verificação de Instalação

### Checklist Completo

```bash
# 1. Verificar Yosys
yosys -version

# Saída esperada:
# Yosys 0.26+...

# 2. Verificar nextpnr
nextpnr-gowin --version

# 3. Verificar openFPGALoader
openFPGALoader --version

# 4. Conectar Tang Nano e detectar
openFPGALoader --detect

# Saída esperada:
# found 1 device
#   idcode 0x100681b
#   manufacturer Gowin
#   family GW1NZ
#   model  GW1NZ-1
```

---

## Uso Básico

### Compilar Projeto

```bash
cd hdl/tang_nano_1k/blink

# Via Makefile (se disponível)
make all

# Ou manualmente com yosys
yosys -m gw1n -d gw1n -p "synth_gowin -json blink.json" blink.v

# Place & Route com nextpnr
nextpnr-gowin --json blink.json --asc blink.asc --device GW1NZ-1

# Gerar bitstream
gowin_pack -d GW1NZ-1 -o blink.fs blink.asc
```

### Programar FPGA

```bash
# Detectar dispositivo
openFPGALoader --detect

# Programar
openFPGALoader -b tangnano1k blink.fs

# Ou com busID específico
openFPGALoader -b tangnano1k -d "0:0000:0000" blink.fs
```

---

## Troubleshooting

### "Command not found: yosys"

**Causa:** oss-cad-suite não está no PATH

**Solução:**
```bash
# 1. Verificar localização
ls -la /home/tools/oss-cad-suite/bin/yosys

# 2. Verificar ~/.bashrc
cat ~/.bashrc | grep "FPGA_TOOLS\|oss-cad-suite"

# 3. Recarregar
source ~/.bashrc

# 4. Testar novamente
yosys --version
```

### "Device not found" ao programar

**Causa:** Tang Nano não detectado, drivers ausentes ou permissões insuficientes

**Solução:**
```bash
# 1. Verificar conexão USB
lsusb | grep -i ftdi

# 2. Reconectar placa

# 3. Reaplcar regras udev
sudo udevadm control --reload-rules
sudo udevadm trigger

# 4. Se necessário, usar sudo
sudo openFPGALoader -b tangnano1k blink.fs

# 5. Testar novamente
openFPGALoader --detect
```

### Problemas de Permissão USB

```bash
# Adicionar usuário ao grupo plugdev
sudo usermod -a -G plugdev $USER

# Fazer logout e login para aplicar

# Ou executar com sudo
sudo openFPGALoader --detect
```

### Compilação lenta

O oss-cad-suite pode ser lento em VMs ou máquinas antigas. Considere:
- Usar `-j$(nproc)` em compilações paralelas
- Executar em máquina host em vez de VM

### Erros de compilação do openFPGALoader

```bash
# Reinstalar dependências
sudo apt install -y libftdi-dev libftdi1-dev libusb-1.0-0-dev

# Limpar build anterior
rm -rf build/
mkdir build && cd build

# Recompilar
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j$(nproc)
sudo make install
```

---

## Referências

- **oss-cad-suite:** https://github.com/YosysHQ/oss-cad-suite-build
- **openFPGALoader:** https://github.com/trabucayre/openFPGALoader
- **Gowin Semiconductor:** https://www.gowinsemi.com/
- **Yosys:** http://www.clifford.at/yosys/
- **nextpnr:** https://github.com/YosysHQ/nextpnr

---

**Última atualização:** 6 de maio de 2026
