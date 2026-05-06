# 📚 Índice de Documentação — Embedded Systems

Guia de navegação centralizado para toda documentação do repositório.

---

## 🚀 Primeiros Passos

### Novo no Repositório?

1. **Setup Inicial:** [`FIRST_SETUP.md`](FIRST_SETUP.md) — Clone e estrutura
2. **Comece a Desenvolver:** [`hdl/WORKFLOW.md`](hdl/WORKFLOW.md) — Projeto Blink em 3 ambientes
3. **Ou escolha sua plataforma:** Seções abaixo

---

## 🚀 Workflow de Desenvolvimento

### Deseja começar a desenvolver logo?

Consulte **[`hdl/WORKFLOW.md`](hdl/WORKFLOW.md)** para um guia completo que mostra como desenvolver o mesmo projeto (Blink) em três ambientes:

- **Gowin IDE** (Windows, interface gráfica)
- **Quartus Prime Lite** (Windows/Linux, interface gráfica)
- **VS Code + oss-cad-suite** (Linux, terminal + editor)

Cada seção é independente e completa!

---

## 🎯 Índice Principal

### HDL/FPGA

Documentação para desenvolvimento com placas FPGA (Altera MAX II, Tang Nano).

**Localização:** `docs/hdl/`  
**Índice detalhado:** [`hdl/README.md`](hdl/README.md)

#### 🖥️ Linux

- **Tang Nano (oss-cad-suite)** — [`hdl/TANG_NANO_LINUX.md`](hdl/TANG_NANO_LINUX.md)
  - Instalação completa do toolchain
  - Configuração de drivers USB
  - Verificação e troubleshooting
  - Uso básico (compilação e programação)

- **MAX II (Quartus Prime Lite)** — [`hdl/QUARTUS_INSTALL.md`](hdl/QUARTUS_INSTALL.md)
  - Instalação do Quartus
  - Configuração USB Blaster
  - Programação de MAX II

#### 🪟 Windows

- **Tang Nano (Gowin IDE)** — [`hdl/GOWIN_INSTALL.md`](hdl/GOWIN_INSTALL.md)
  - Instalação do Gowin FPGA Designer
  - Criação de projeto
  - Síntese, Place & Route
  - Programação via Gowin Programmer

- **MAX II (Quartus Prime Lite)** — [`hdl/QUARTUS_INSTALL.md`](hdl/QUARTUS_INSTALL.md)
  - Instalação do Quartus
  - Drivers USB Blaster
  - Programação

#### 📂 Projetos

- **Tang Nano:** [`hdl/tang_nano/`](../hdl/tang_nano/) — Exemplos e projetos
- **MAX II:** [`hdl/max_ii/`](../hdl/max_ii/) — Exemplos e projetos

---

### Embedded

Documentação para desenvolvimento com microcontroladores e placas single-board.

**Localização:** `docs/embedded/`

Projetos disponíveis:
- **Raspberry Pi Pico** — `embedded/pico/`
- **KeyStudio** — `embedded/keystudio/`
- **Raspberry Zero 2W** — Scripts de setup

---

## 📋 Referência Rápida

| Plataforma | SO | Instalação | Projetos |
|---|---|---|---|
| **Tang Nano** | Linux | [`TANG_NANO_LINUX.md`](hdl/TANG_NANO_LINUX.md) | [`tang_nano/`](../hdl/tang_nano/) |
| **Tang Nano** | Windows | [`GOWIN_INSTALL.md`](hdl/GOWIN_INSTALL.md) | [`tang_nano/`](../hdl/tang_nano/) |
| **MAX II** | Linux | [`QUARTUS_INSTALL.md`](hdl/QUARTUS_INSTALL.md) | [`max_ii/`](../hdl/max_ii/) |
| **MAX II** | Windows | [`QUARTUS_INSTALL.md`](hdl/QUARTUS_INSTALL.md) | [`max_ii/`](../hdl/max_ii/) |

---

## 🔧 Guias de Instalação

### 1. Setup Inicial
→ [`FIRST_SETUP.md`](FIRST_SETUP.md)

### 2. HDL/FPGA
→ [`hdl/README.md`](hdl/README.md)

**Linux:**
- Tang Nano: [`hdl/TANG_NANO_LINUX.md`](hdl/TANG_NANO_LINUX.md)
- MAX II: [`hdl/QUARTUS_INSTALL.md`](hdl/QUARTUS_INSTALL.md)

**Windows:**
- Tang Nano: [`hdl/GOWIN_INSTALL.md`](hdl/GOWIN_INSTALL.md)
- MAX II: [`hdl/QUARTUS_INSTALL.md`](hdl/QUARTUS_INSTALL.md)

### 3. Embedded
→ Consulte README específico em `embedded/[plataforma]/`

---

## 🆘 Troubleshooting

### Problema: Ferramenta não encontrada

1. Leia o guia de instalação da plataforma escolhida
2. Verifique variáveis de ambiente (`.bashrc` ou `.profile`)
3. Consulte a seção "Troubleshooting" do guia

### Problema: Dispositivo não detectado

1. Verifique conexão USB
2. Instale drivers (udev rules no Linux, INF no Windows)
3. Reconecte o dispositivo
4. Consulte guia específico da plataforma

### Problema: Compilação falha

1. Verifique dependências do sistema
2. Confirme que toolchain está instalado
3. Leia logs de erro cuidadosamente

---

## 📂 Estrutura de Diretórios

```
docs/
├── INDEX.md                          # Este arquivo
├── FIRST_SETUP.md                   # Setup inicial
├── hdl/
│   ├── README.md                    # Índice HDL/FPGA
│   ├── TANG_NANO_LINUX.md           # Tang Nano no Linux
│   ├── QUARTUS_INSTALL.md           # Quartus (Linux/Windows)
│   ├── GOWIN_INSTALL.md             # Gowin IDE (Windows)
│   ├── tang_nano/                   # Projetos Tang Nano
│   └── max_ii/                      # Projetos MAX II
└── embedded/
    ├── pico/                        # Raspberry Pi Pico
    └── keystudio/                   # KeyStudio
```

---

## 📝 Convenções

- **Linux:** Scripts em Bash
- **Windows:** Scripts PowerShell (quando necessário)
- **Variáveis de Ambiente:** Salvas em `~/.bashrc` ou `~/.profile`
- **Instalação Global:** Ferramentas em `/home/tools/` (Linux)

---

## 🔗 Links Úteis

### Fabricantes

- **Intel Quartus:** https://www.intel.com/quartus
- **Gowin Semiconductor:** https://www.gowinsemi.com/
- **Sipeed Tang Nano:** https://sipeed.com/

### Toolchains Open-Source

- **oss-cad-suite:** https://github.com/YosysHQ/oss-cad-suite-build
- **openFPGALoader:** https://github.com/trabucayre/openFPGALoader
- **Yosys:** http://www.clifford.at/yosys/
- **nextpnr:** https://github.com/YosysHQ/nextpnr

### Microcontroladores

- **Raspberry Pi Pico:** https://www.raspberrypi.com/products/raspberry-pi-pico/
- **Raspberry Pi Zero 2W:** https://www.raspberrypi.com/products/raspberry-pi-zero-2-w/

---

## 📧 Perguntas Frequentes

**P: Por onde começo?**  
R: Leia [`FIRST_SETUP.md`](FIRST_SETUP.md) e escolha sua plataforma em [`hdl/README.md`](hdl/README.md).

**P: Posso usar Windows?**  
R: Sim! Quartus e Gowin IDE funcionam nativamente. Ou use WSL2 + Linux.

**P: Qual plataforma é melhor para iniciantes?**  
R: Tang Nano no Linux com `oss-cad-suite` é recomendado por ser open-source e gratuito.

**P: Como atualizar ferramentas?**  
R: Cada guia de instalação contém instruções para atualizar versões.

---

**Última atualização:** 6 de maio de 2026  
**Manutenção:** Consulte o README.md principal do repositório para informações sobre contribuições.
