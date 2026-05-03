# Instalação e Configuração - Quartus Prime 20.1 + USB Blaster + OpenFPGALoader

**Data:** 30 de Abril de 2026  
**Sistema Operacional:** Linux  
**Hardware:** MAX II + USB Blaster

---

## 1. Instalação do Quartus Prime 20.1

### 1.1 Extrair arquivo .tar
```bash
tar -xzf Quartus-lite-20.1.0.711-linux.tar.gz
cd quartus/
```

### 1.2 Executar o instalador
```bash
./setup.sh
```

### 1.3 Seguir o assistente
- Aceitar termos de licença
- Escolher diretório: `/home/anderson/intelFPGA_lite/20.1/`
- Selecionar componentes desejados

**Status:** ✅ Instalado com sucesso em `~/intelFPGA_lite/20.1/`

---

## 2. Configuração de Variáveis de Ambiente

### 2.1 Adicionar ao ~/.bashrc
```bash
cat >> ~/.bashrc << 'EOF'

# Quartus Prime 20.1
export QUARTUS_ROOTDIR="$HOME/intelFPGA_lite/20.1/quartus"
export PATH=$QUARTUS_ROOTDIR/bin:$PATH
export LD_LIBRARY_PATH=$QUARTUS_ROOTDIR/linux64:$LD_LIBRARY_PATH
EOF
```

### 2.2 Carregar configurações
```bash
source ~/.bashrc
```

### 2.3 Verificar instalação
```bash
quartus --version
jtagconfig
```

**Status:** ✅ Configurado e testado com sucesso

---

## 3. Criar Ícone no Menu de Aplicações

### 3.1 Para usuário atual
```bash
cat > ~/.local/share/applications/quartus.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Quartus Prime 20.1
Comment=Intel FPGA Design Software
Exec=$HOME/intelFPGA_lite/20.1/quartus/bin/quartus %F
Icon=$HOME/intelFPGA_lite/20.1/quartus/adm/quartus.png
Terminal=false
Categories=Development;Engineering;Electronics;
StartupNotify=true
EOF

update-desktop-database ~/.local/share/applications/
```

### 3.2 Para todos os usuários (opcional)
```bash
sudo bash -c 'cat > /usr/share/applications/quartus.desktop << '"'"'EOF'"'"'
[Desktop Entry]
Version=1.0
Type=Application
Name=Quartus Prime 20.1
Comment=Intel FPGA Design Software
Exec=/home/anderson/intelFPGA_lite/20.1/quartus/bin/quartus %F
Icon=/home/anderson/intelFPGA_lite/20.1/quartus/adm/quartus.png
Terminal=false
Categories=Development;Engineering;Electronics;
StartupNotify=true
EOF'
```

**Status:** ✅ Quartus aparece no menu de aplicações

---

## 4. Configuração do USB Blaster

### 4.1 Criar regras udev
```bash
sudo bash -c 'cat > /etc/udev/rules.d/51-altera-usb-blaster.rules << "EOF"
# USB Blaster
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6001", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6002", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6003", MODE="0666"

# USB Blaster II
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6010", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6810", MODE="0666"
EOF'
```

### 4.2 Recarregar regras udev
```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

### 4.3 Adicionar usuário aos grupos
```bash
sudo usermod -a -G dialout $USER
```

### 4.4 Verificar detecção
```bash
lsusb | grep Altera
jtagconfig
```

**Status:** ✅ USB Blaster detectado: `1) USB-Blaster [1-2]`

---

## 5. Instalação do OpenFPGALoader

### 5.1 Verificar disponibilidade
```bash
apt-cache search openFPGALoader
```

### 5.2 Compilar do source
```bash
# Instalar dependências
sudo apt-get update
sudo apt-get install -y cmake git pkg-config libftdi-dev libftdi1 libusb-1.0-0-dev zlib1g-dev

# Clonar repositório
cd ~
git clone https://github.com/trabucayre/openFPGALoader.git
cd openFPGALoader

# Compilar
mkdir build
cd build
cmake ..
make -j$(nproc)
sudo make install
```

**Status:** ✅ OpenFPGALoader instalado

---

## 6. Configuração de Permissões (OpenFPGALoader)

### 6.1 Verificar se grupo plugdev existe
```bash
grep -w plugdev /etc/group
```

### 6.2 Criar grupo plugdev (se necessário)
```bash
sudo groupadd --system plugdev
```

### 6.3 Copiar regras udev OpenFPGALoader
```bash
sudo cp /usr/lib/udev/rules.d/99-openfpgaloader.rules /etc/udev/rules.d/
```

### 6.4 Recarregar regras e adicionar usuário
```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
sudo usermod -a -G plugdev $USER
```

### 6.5 Ativar novo grupo na sessão atual
```bash
newgrp plugdev
```

**Status:** ✅ Permissões configuradas

---

## 7. Teste de Conexão

### 7.1 Quartus Programmer
```bash
quartus_pgm -l
```

**Esperado:** 
```
1) USB-Blaster [1-2]
```

### 7.2 OpenFPGALoader
```bash
LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH openFPGALoader -c usb-blaster --detect
```

### 7.3 JTAG Config
```bash
jtagconfig
```

**Status:** ✅ USB Blaster detectado e funcionando

---

## 8. Programação da MAX II

### 8.1 Comando para programar com .svf
```bash
cd blink/
quartus_pgm -c "1-2" -m JTAG -o "P;top.svf"
```

### 8.2 Script auxiliar
```bash
cat > programa_max2.sh << 'EOF'
#!/bin/bash
if [ -z "$1" ]; then
    echo "Uso: $0 arquivo.svf"
    exit 1
fi
quartus_pgm -c "1-2" -m JTAG -o "P;$1"
EOF

chmod +x programa_max2.sh

# Usar assim:
./programa_max2.sh top.svf
```

---

## Resumo das Etapas Completadas

| Etapa | Status |
|-------|--------|
| Quartus Prime 20.1 instalado | ✅ |
| Variáveis de ambiente configuradas | ✅ |
| Ícone adicionado ao menu | ✅ |
| USB Blaster detectado | ✅ |
| Regras udev USB Blaster configuradas | ✅ |
| OpenFPGALoader instalado | ✅ |
| Grupo plugdev criado e configurado | ✅ |
| Permissões configuradas | ✅ |

---

## Notas Importantes

1. **MAX II com OpenFPGALoader:** OpenFPGALoader não tem suporte completo para MAX II (apenas MAX 10)
2. **Programação:** Usar `quartus_pgm` para MAX II com arquivos `.svf`
3. **Depois de logout/login:** As mudanças de grupo serão aplicadas
4. **Biblioteca conflitante:** Usar `LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH` ao executar OpenFPGALoader

---

## Próximas Etapas (Não Implementadas)

- [ ] Diagnóstico avançado do USB Blaster
- [ ] Configuração de Signal Tap para debug
- [ ] Integração com VS Code/editor
- [ ] Scripts de automação para build e programação

---

*Documento criado em 30 de Abril de 2026*
