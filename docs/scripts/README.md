# Setup Tang Nano — Script Consolidado

Script unificado para configurar ambiente FPGA Tang Nano (1K ou 9K) no Linux.

## ⚡ Início Rápido

```bash
# Setup global completo (recomendado)
./setup_tang_nano.sh

# Ou especificar versão da placa
./setup_tang_nano.sh --version 1k

# Verificar instalação
./setup_tang_nano.sh --verify

# Ajuda
./setup_tang_nano.sh --help
```

---

## 📖 Uso Detalhado

### Modo Global (Recomendado)

Instala ferramentas em `/home/tools/` compartilhadas com todo o sistema.

```bash
./setup_tang_nano.sh --version 1k --mode global
```

**Características:**
- ✅ Instalação global
- ✅ Requer `sudo`
- ✅ Configura `~/.bashrc`
- ✅ Aplica regras `udev`
- ✅ Ideal para uso compartilhado

**Próximos passos:**
```bash
source ~/.bashrc
openFPGALoader --detect
```

### Modo Local

Instala ferramentas localmente no diretório do script (isolado).

```bash
./setup_tang_nano.sh --mode local
```

**Características:**
- ✅ Não requer `sudo`
- ✅ Instalação isolada
- ✅ Cria `.bashrc_tang_nano` local
- ✅ Bom para testes/desenvolvimento

**Próximos passos:**
```bash
source tools/.bashrc_tang_nano
```

---

## 🔍 Verificação

Verificar instalação existente sem instalar nada:

```bash
./setup_tang_nano.sh --verify
```

Testa:
- ✓ oss-cad-suite
- ✓ openFPGALoader
- ✓ Variáveis de ambiente
- ✓ Regras udev
- ✓ Conexão com FPGA

---

## 🎯 Opções

| Opção | Uso | Exemplo |
|-------|-----|---------|
| `--version 1k\|9k\|auto` | Placa (padrão: auto) | `--version 1k` |
| `--mode local\|global` | Modo instalação (padrão: global) | `--mode local` |
| `--verify` | Apenas verificar | `--verify` |
| `--help` | Exibir ajuda | `--help` |

---

## 📦 O que é Instalado

### Global (`/home/tools/`)

1. **oss-cad-suite** — Toolchain open-source
   - Yosys (síntese)
   - nextpnr (place & route)
   - Ferramentas de build

2. **openFPGALoader** — Programador FPGA
   - Via apt ou compilado do source

3. **Configuração**
   - Variáveis de ambiente em `~/.bashrc`
   - Regras udev para JTAG (`/etc/udev/rules.d/99-fpga.rules`)
   - Aliases úteis (`fpga_detect`, `fpga_version`)

### Local (`./tools/`)

Mesmas ferramentas, mas:
- Em `$SCRIPT_DIR/tools/`
- Configuração em `.bashrc_tang_nano` local
- Sem regras udev

---

## 🐛 Troubleshooting

### "sudo: comando não encontrado"

```bash
# Solução: instalar sudo ou usar --mode local
apt-get install sudo
```

### "apt-get: comando não encontrado"

Seu sistema não é Debian/Ubuntu. Adapte:
- Fedora: `dnf` em vez de `apt-get`
- Arch: `pacman` em vez de `apt-get`

### "oss-cad-suite falhou"

Verifique:
```bash
ls -la /home/tools/oss-cad-suite/bin/yosys
```

Se não existir, executar novamente o script.

### "openFPGALoader não detecta placa"

```bash
# 1. Verificar conexão USB
lsusb | grep -i sipeed

# 2. Recarregar regras udev
sudo udevadm control --reload-rules
sudo udevadm trigger

# 3. Reconectar placa

# 4. Testar novamente
openFPGALoader --detect
```

### "FPGA conectada mas não detectada"

Possíveis causas:
- Placa em modo Flash (não em SRAM)
- Drivers USB faltando
- Permissões insuficientes (tente `sudo openFPGALoader --detect`)

---

## 📂 Estrutura Criada

### Global

```
~/.bashrc                                # Configuração shell
/home/tools/
├── oss-cad-suite/                       # Toolchain
│   ├── bin/    (yosys, nextpnr, etc)
│   ├── lib/
│   └── share/
├── openFPGALoader/                      # Programador (se compilado)
│   └── build/
/etc/udev/rules.d/99-fpga.rules         # Permissões JTAG
```

### Local

```
scripts/tang_nano/
├── setup_tang_nano.sh                   # Script
├── .bashrc_tang_nano                    # Configuração local
└── tools/
    ├── oss-cad-suite/
    └── openFPGALoader/
```

---

## 📊 Comparação com Antigos

Este script **consolida** dois scripts antigos:

| Aspecto | Antigo (9K) | Antigo (1K) | Novo |
|---------|-----------|-----------|------|
| **Versão** | 9K apenas | 1K apenas | 1K, 9K, auto |
| **Tipo** | Verificação | Instalação | Ambos |
| **Local/Global** | Local | Global | Ambos |
| **Parâmetros** | Nenhum | Nenhum | Vários |
| **Flexible** | ⭐⭐ | ⭐⭐ | ⭐⭐⭐ |

Scripts antigos arquivados em `.archive/` para referência.

---

## 📖 Documentação

- **Instalação completa:** [`../../docs/hdl/TANG_NANO_LINUX.md`](../../docs/hdl/TANG_NANO_LINUX.md)
- **Workflow:** [`../../docs/hdl/WORKFLOW.md`](../../docs/hdl/WORKFLOW.md)
- **Setup inicial:** [`../../docs/FIRST_SETUP.md`](../../docs/FIRST_SETUP.md)

---

## ✨ Recursos Especiais

### Detecção Automática de Placa

Se não especificar `--version`, o script tenta detectar:

```bash
./setup_tang_nano.sh  # Detecta automaticamente
```

### Log Detalhado

Cada execução gera um log:

```bash
fpga_setup_1k_global_20260506_145600.log
```

Consulte para troubleshooting detalhado.

### Aliases Úteis

Após setup global:

```bash
fpga_detect        # Detectar FPGA conectada
fpga_version       # Versão das ferramentas
```

---

## 🆘 Suporte

Se encontrar problemas:

1. Consulte o log: `fpga_setup_*.log`
2. Verifique `./setup_tang_nano.sh --verify`
3. Leia a documentação em `docs/hdl/`
4. Veja troubleshooting no `--help`

---

**Última atualização:** 6 de maio de 2026  
**Manutentor:** Repositório embedded_systems
