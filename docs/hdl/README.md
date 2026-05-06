# 📚 Documentação HDL/FPGA

Documentação para FPGA com Tang Nano (Gowin) e Altera MAX II.

---

## 🚀 Comece Aqui

### Desenvolver Projeto Blink em 3 Ambientes

→ **[`WORKFLOW.md`](WORKFLOW.md)** — Guia passo-a-passo:
- **Gowin IDE** (Windows, interface gráfica)
- **Quartus Prime Lite** (Windows/Linux, interface gráfica)  
- **VS Code + oss-cad-suite** (Linux, terminal + editor)

Cada seção é independente e completa. Escolha seu ambiente!

---

## 📖 Guias de Instalação

| Plataforma | SO | Arquivo |
|-----------|-----|---------|
| **Tang Nano** | Linux | [`TANG_NANO_LINUX.md`](TANG_NANO_LINUX.md) |
| **Quartus** | Linux/Windows | [`QUARTUS_INSTALL.md`](QUARTUS_INSTALL.md) |
| **Gowin IDE** | Windows | [`GOWIN_INSTALL.md`](GOWIN_INSTALL.md) |

---

## 📁 Projetos

- **Tang Nano:** [`tang_nano/`](tang_nano/) — Exemplos e projetos
- **MAX II:** [`max_ii/`](max_ii/) — Exemplos e projetos

---

## 🔗 Próximo Passo

1. Leia [`../FIRST_SETUP.md`](../FIRST_SETUP.md) se for primeira vez
2. Consulte [`WORKFLOW.md`](WORKFLOW.md) para começar a desenvolver

---

**Última atualização:** 6 de maio de 2026

### Por Sintoma

| Problema | Consulte |
|----------|----------|
| "command not found: yosys" | [`INSTALACAO_FERRAMENTAS.md`](hdl/tang_nano/INSTALACAO_FERRAMENTAS.md) seção 9.1 |
| Device não detectado | [`INSTALACAO_FERRAMENTAS.md`](hdl/tang_nano/INSTALACAO_FERRAMENTAS.md) seção 9.2 |
| USB sem permissão | [`INSTALACAO_FERRAMENTAS.md`](hdl/tang_nano/INSTALACAO_FERRAMENTAS.md) seção 6.2 |
| PATH incorreto | [`INSTALACAO_FERRAMENTAS.md`](hdl/tang_nano/INSTALACAO_FERRAMENTAS.md) seção 7 |
| Compilação falha | [`QUICK_START_FERRAMENTAS.md`](hdl/tang_nano/QUICK_START_FERRAMENTAS.md) Troubleshooting |

### Por Ferramenta

| Ferramenta | Documentação |
|-----------|--------------|
| oss-cad-suite | [`INSTALACAO_FERRAMENTAS.md`](hdl/tang_nano/INSTALACAO_FERRAMENTAS.md) seção 4 |
| OpenFPGALoader | [`INSTALACAO_FERRAMENTAS.md`](hdl/tang_nano/INSTALACAO_FERRAMENTAS.md) seção 3 |
| Lushay Code | [`INSTALACAO_FERRAMENTAS.md`](hdl/tang_nano/INSTALACAO_FERRAMENTAS.md) seção 5 |
| Drivers USB | [`INSTALACAO_FERRAMENTAS.md`](hdl/tang_nano/INSTALACAO_FERRAMENTAS.md) seção 6 |

---

## 🔗 Links Externos

### Ferramentas Principais
- [oss-cad-suite](https://github.com/YosysHQ/oss-cad-suite-build)
- [OpenFPGALoader](https://github.com/trabucayre/openFPGALoader)
- [Yosys](https://yosyshq.net/)
- [nextpnr](https://github.com/YosysHQ/nextpnr)

### Hardware
- [Tang Nano 1K](https://sipeed.com/tang-nano-1k)
- [Gowin FPGA](https://www.gowinsemi.com/)
- [Altera MAX II](https://www.intel.com/)

### Referências
- [Verilog Language](https://en.wikipedia.org/wiki/Verilog)
- [FPGA Design Basics](https://en.wikipedia.org/wiki/Field-programmable_gate_array)

---

## 📝 Versão da Documentação

- **Última atualização:** 5 de Maio de 2026
- **Versão:** 2.0 (reorganização centralizada)
- **Status:** ✅ Pronto para uso

---

## 🎯 Próximos Passos

1. **Escolher ambiente:**
   - Tang Nano → [`hdl/tang_nano/README.md`](hdl/tang_nano/README.md)
   - MAX II → [`HDL_ALTERA_MAX_II_ENVIRONMENT.md`](HDL_ALTERA_MAX_II_ENVIRONMENT.md)

2. **Seguir documentação de setup**

3. **Compilar projeto exemplo**

4. **Programar FPGA**

---

# Tang Nano - Documentação Completa

## 📚 Documentação Disponível

### 1. **INSTALACAO_FERRAMENTAS.md** 🔧
**Guia Completo de Instalação e Configuração**

Cobre:
- OpenFPGALoader (compilação e configuração)
- oss-cad-suite (Toolchain Yosys, nextpnr, Apicula)
- Lushay Code (extensão VS Code)
- Drivers USB/FTDI
- Variáveis de Ambiente (com localização global `/home/tools/oss-cad-suite/`)
- Script de setup automático
- Troubleshooting detalhado

📖 **Quando usar:** Primeira instalação ou reconfigure de ferramenta

---

### 2. **QUICK_START_FERRAMENTAS.md** ⚡
**Referência Rápida de Ferramentas**

Cove:
- 5 passos para começar
- Checklist de instalação
- Troubleshooting rápido
- Comandos essenciais
- Debug avançado

📖 **Quando usar:** Verificação rápida após instalação

---

## 🎓 Fluxo de Aprendizado Recomendado

### Primeira Vez (Novo Usuário)
1. Ler: `INSTALACAO_FERRAMENTAS.md` (seções 1-4)
2. Executar: Script setup
3. Verificar: `QUICK_START_FERRAMENTAS.md` (seção 1-3)
4. Testar: Compilar projeto exemplo

### Reconfigurando Ferramentas
1. Ler: `INSTALACAO_FERRAMENTAS.md` (seção problemática)
2. Usar: Troubleshooting em `QUICK_START_FERRAMENTAS.md`

### Debugando Erro
1. Procurar em: `INSTALACAO_FERRAMENTAS.md` (seção 9)
2. Depois em: `QUICK_START_FERRAMENTAS.md` (Troubleshooting)

---

## 📍 Localização do OSS_tools

⚠️ **IMPORTANTE:** O toolchain agora está centralizado em:

```bash
/home/tools/oss-cad-suite/
```

**Não está mais em:**
- `hdl/tang_nano_1k/oss-cad-suite/` (diretório do projeto)
- `/home/anderson/tools/oss-cad-suite/` (localização anterior)

### Configuração Necessária

Certifique-se de que seu `~/.bashrc` contém:

```bash
export PATH="/home/tools/oss-cad-suite/bin:$PATH"
export LD_LIBRARY_PATH="/home/tools/oss-cad-suite/lib:$LD_LIBRARY_PATH"
```

Depois recarregue:
```bash
source ~/.bashrc
```

---

## 🔗 Estrutura de Arquivos

```
docs/hdl/tang_nano/
├── README.md                    ← ESTE ARQUIVO
├── INSTALACAO_FERRAMENTAS.md    ← Instalação completa
└── QUICK_START_FERRAMENTAS.md   ← Referência rápida
```

---

## 🎯 Próximos Passos

### ✅ Se está começando do zero:
```bash
# 1. Ler documentação de instalação
cat INSTALACAO_FERRAMENTAS.md

# 2. Seguir seções 3-7

# 3. Verificar instalação
source ~/.bashrc
yosys -version
openFPGALoader --detect
```

### ✅ Se já tem tudo instalado:
```bash
# 1. Verificar que toolchain está em local correto
ls -la /home/tools/oss-cad-suite/bin/

# 2. Verificar PATH está correto
echo $PATH | grep -i oss

# 3. Testar
yosys -version
```

---

## 🆘 Precisa de Ajuda?

### Por Sintoma:

| Sintoma | Consulte |
|---------|----------|
| "command not found: yosys" | INSTALACAO 9.1 + QUICK_START |
| Device não detectado | INSTALACAO 9.2 + 9.3 |
| USB sem permissão | INSTALACAO 6.2 |
| Path configurado errado | INSTALACAO 7.1 |
| Toolchain não encontrado | QUICK_START Troubleshooting |

---

## 📊 Referência de Arquivos

| Arquivo | Localização | Propósito |
|---------|------------|----------|
| INSTALACAO_FERRAMENTAS.md | `docs/hdl/tang_nano/` | Guia completo de setup |
| QUICK_START_FERRAMENTAS.md | `docs/hdl/tang_nano/` | Referência rápida |
| Este arquivo (README.md) | `docs/hdl/tang_nano/` | Índice e navegação |

---
