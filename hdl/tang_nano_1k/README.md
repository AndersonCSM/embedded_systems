# Tang Nano 1K Development Environment

Documentação completa para setup e uso do ambiente de desenvolvimento para **Tang Nano 1K** FPGA.

---

## 📋 Visão Geral

Este projeto fornece um **toolchain open-source** para desenvolvimento com a placa **Tang Nano 1K** da Sipeed.

> **Importante para novos usuários**
>
> A pasta `oss-cad-suite/` **não é versionada no Git** (foi adicionada ao `.gitignore`) porque é muito grande.
> Após clonar o repositório, faça o download local do toolchain antes de compilar os exemplos.

### Componentes

- **FPGA**: Gowin GW1NZ-1 (1K LUTs)
- **Toolchain**: oss-cad-suite (Yosys + nextpnr-nexus + Apicula)
- **Linguagem**: SystemVerilog / Verilog
- **Programador**: openFPGALoader

---

## 🏗️ Estrutura do Projeto

```
tang_nano_1k/
├── oss-cad-suite/          ← Toolchain local (ignorado no Git)
│   ├── bin/
│   │   ├── yosys
│   │   ├── nextpnr-nexus
│   │   └── gowin_pack
│   └── ...
├── blink/                   ← Projeto exemplo (LED piscante)
│   ├── top.sv              ← Código Verilog
│   ├── constraints.cst     ← Mapeamento de pinos
│   ├── Makefile            ← Build system
│   └── README.md
├── config/
│   └── setup_tang_nano_safe.sh  ← Script de setup
├── .bashrc_tang_nano        ← Configuração de PATH (criado pelo script)
└── README.md               ← Este arquivo
```

---

## 1️⃣ Etapa 1: Configuração do oss-cad-suite

### 1.1 O que é oss-cad-suite?

O **oss-cad-suite** é um conjunto integrado de ferramentas open-source para FPGA:

| Ferramenta | Função |
|------------|--------|
| **Yosys** | Sintetizador de HDL (Verilog → primitivas lógicas) |
| **nextpnr-nexus** | Place & Route (otimizar layout no FPGA) |
| **Apicula** | Gerador de bitstream para Gowin FPGA |
| **openFPGALoader** | Programador (carrega bitstream na placa) |

### 1.2 Instalação

**Pré-requisitos:**
- 5GB de espaço em disco
- Conexão internet
- Linux, macOS ou Windows (WSL)

**Opção A: Download automático (recomendado)**

```bash
# Ir para a pasta tang_nano_1k
cd ~/github_projects/embedded_systems/hdl/tang_nano_1k

# Executar o script de setup
bash config/setup_tang_nano_safe.sh
```

O script irá:
1. ✅ Verificar recursos (disco, RAM)
2. ✅ Procurar oss-cad-suite em `~/tools/` (se existir)
3. ✅ Ou instruir você a baixar de: https://github.com/YosysHQ/oss-cad-suite-build/releases
4. ✅ Instalar openFPGALoader via apt
5. ✅ Configurar udev rules (permissões de USB)
6. ✅ Criar `.bashrc_tang_nano` (PATH config)

**Opção B: Download manual**

```bash
# 1. Baixar a última release (arquitetura Linux x86_64)
wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/VERSÃO/oss-cad-suite-linux-x64.tgz

# 2. Extrair na pasta tang_nano_1k
tar -xzf oss-cad-suite-linux-x64.tgz -C ~/github_projects/embedded_systems/hdl/tang_nano_1k/

# 3. Verificar instalação
./oss-cad-suite/bin/yosys --version
```

### 1.3 Verificação

```bash
# Testar cada ferramenta
yosys --version
nextpnr-nexus --help
gowin_pack --help
openFPGALoader --version
```

Se todos retornam versão/help sem erro ✅, instalação OK!

---

## 2️⃣ Etapa 2: Usando o Script setup_tang_nano_safe.sh

### 2.1 O que faz o script?

O `setup_tang_nano_safe.sh` **automatiza toda a configuração** com:

- ✅ Verificações de segurança (disco/RAM)
- ✅ Localização do oss-cad-suite
- ✅ Validação de binários
- ✅ Instalação de dependências (openFPGALoader)
- ✅ Configuração de permissões USB (udev)
- ✅ Setup de variáveis de ambiente
- ✅ Logging completo (para troubleshooting)

### 2.2 Executar o script

```bash
cd ~/github_projects/embedded_systems/hdl/tang_nano_1k
bash config/setup_tang_nano_safe.sh
```

### 2.3 Saída esperada

```
[2026-04-30 14:23:45] ===== Tang Nano Setup v2.2 =====
[2026-04-30 14:23:45] Checking disk space...
[2026-04-30 14:23:45] ✓ 237GB free (min 5GB)
[2026-04-30 14:23:45] Checking RAM...
[2026-04-30 14:23:45] ✓ 8GB available
[2026-04-30 14:23:46] Locating oss-cad-suite...
[2026-04-30 14:23:46] ✓ Found at /home/anderson/github_projects/embedded_systems/hdl/tang_nano_1k/oss-cad-suite
[2026-04-30 14:23:46] Validating tools...
[2026-04-30 14:23:47] ✓ yosys 0.26+1
[2026-04-30 14:23:47] ✓ nextpnr-nexus
[2026-04-30 14:23:47] ✓ gowin_pack
[2026-04-30 14:23:48] Installing openFPGALoader...
[2026-04-30 14:23:52] ✓ openFPGALoader installed
[2026-04-30 14:23:53] Configuring udev rules...
[2026-04-30 14:23:53] ✓ udev rules installed (reboot may be needed)
[2026-04-30 14:23:53] Creating .bashrc_tang_nano...
[2026-04-30 14:23:53] ✓ Environment configured
[2026-04-30 14:23:53] ===== Setup Complete! =====
```

### 2.4 Log do script

O script cria um log detalhado com timestamp:

```bash
setup_tang_nano_20260430_142345.log
```

Para ver erros (se houver):

```bash
cat setup_tang_nano_*.log
```

### 2.5 Ativar ambiente

Após o script, ativar as variáveis de ambiente:

```bash
# Uma vez por sessão de terminal
source .bashrc_tang_nano

# Ou adicionar ao ~/.bashrc para ativar automaticamente:
echo "source ~/github_projects/embedded_systems/hdl/tang_nano_1k/.bashrc_tang_nano" >> ~/.bashrc
```

---

## 🚀 Próximas Etapas

### 1. Compilar projeto exemplo

```bash
cd blink
make all        # Synth + Place&Route + Pack
```

### 2. Programar FPGA

```bash
make program
```

### 3. Criar novo projeto

Copiar estrutura de `blink/`:

```bash
mkdir my_project
cp blink/Makefile my_project/
cp blink/constraints.cst my_project/
# Editar: top.sv, constraints.cst
```

### 4. Desenvolvendo com VS Code

```bash
code ~/github_projects/embedded_systems/hdl/tang_nano_1k/tang_nano.code-workspace
```

Extensões recomendadas:
- **Verilog-HDL/SystemVerilog** (syntax highlighting)
- **WaveTrace** (waveform viewer)

---

## 🔧 Troubleshooting

### Problema: "oss-cad-suite not found"

**Solução:**

```bash
# Verificar se existe em ~/tools/
ls -la ~/tools/oss-cad-suite/

# Se não existe, baixar manualmente:
cd ~/github_projects/embedded_systems/hdl/tang_nano_1k
wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/VERSÃO/oss-cad-suite-linux-x64.tgz
tar -xzf oss-cad-suite-linux-x64.tgz
```

### Problema: "Permission denied" ao programar

**Solução:**

```bash
# Executar script novamente para reinstalar udev rules
bash config/setup_tang_nano_safe.sh

# Ou instalar manualmente:
sudo cp /etc/udev/rules.d/99-openFPGALoader.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
sudo udevadm trigger
```

### Problema: "FPGA não reconhecida"

**Solução:**

1. Desconectar/reconectar cabo USB
2. Verificar modo bootloader:
   ```bash
   openFPGALoader -b tangnano1k -m JTAG top.fs
   ```
3. Atualizar openFPGALoader:
   ```bash
   sudo apt update && sudo apt install -y openfpgaloader
   ```

### Problema: Síntese falha com "module not found"

**Solução:**

```bash
# Verificar arquivo Makefile
cat Makefile

# Testar Yosys diretamente
source .bashrc_tang_nano
yosys -m gw_sh -p "read_verilog top.sv; synth_gowin -json blink.json"
```

---

## 📚 Referências

### Documentação Oficial

- [Gowin FPGA](https://www.gowinsemi.com/)
- [oss-cad-suite](https://github.com/YosysHQ/oss-cad-suite-build)
- [Yosys](http://www.clifford.at/yosys/)
- [nextpnr](https://github.com/YosysHQ/nextpnr)
- [openFPGALoader](https://github.com/trabucayre/openFPGALoader)

### Tang Nano 1K

- [Schematic](https://dl.sipeed.com/shareURL/TANG/Nano%201k/7_Schematic)
- [Datasheet](https://dl.sipeed.com/shareURL/TANG/Nano%201k/2_Chip_Document)
- [Pinout](https://dl.sipeed.com/shareURL/TANG/Nano%201k/3_HDK)

### Tutoriais

- [Lushay Labs (Gowin FPGA)](https://learn.lushaylabs.com/)
- [Yosys RTL Synthesis](http://www.clifford.at/yosys/tutorial.html)

---

## 📝 Notas de Versão

### v1.0 (2026-04-30)

- ✅ Setup script v2.2
- ✅ Projeto exemplo (blink)
- ✅ Makefile template
- ✅ Documentação completa

---

## ❓ Suporte

Se encontrar problemas:

1. Consulte o log do script: `setup_tang_nano_*.log`
2. Verifique [Troubleshooting](#-troubleshooting)
3. Abra uma issue com:
   - Output do script
   - Versão Ubuntu/OS
   - Placa usada (Tang Nano 1K)
