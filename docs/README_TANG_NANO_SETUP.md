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
- Sem retry/timeout = freezing em download

---

## Como usar o script seguro

### 1. Dar permissão de execução
```bash
chmod +x ~/github_projects/embedded_systems/scripts/setup_tang_nano_safe.sh
```

### 2. Executar o script
```bash
bash ~/github_projects/embedded_systems/scripts/setup_tang_nano_safe.sh
```

### 3. O script fará:
- ✅ Verificará espaço em disco e RAM antes de começar
- ✅ Verificará que oss-cad-suite está em `~/tools/oss-cad-suite/`
- ✅ Configurará PATH corretamente
- ✅ Testará yosys e nextpnr-nexus
- ✅ Instalará openFPGALoader via apt (não script externo perigoso)
- ✅ Configurará regras udev corretamente
- ✅ **Gerará log completo** para debugging

### 4. Verificar resultado
```bash
# Ver log da execução (o script grava em ./logs ou em ~/tang_nano_setup_YYYYMMDD_HHMMSS.log dependendo da configuração)
ls -l ~/tang_nano_setup_*.log || true

# Testar ferramentas
source ~/.bashrc
yosys --version || true
nextpnr-nexus --help || true
```

---

## Estrutura esperada

O script espera que `oss-cad-suite` esteja extraído em:
```
~/tools/oss-cad-suite/
├── bin/
│   ├── yosys
│   ├── nextpnr-nexus
│   ├── oss-cad-suite
│   └── (outros executáveis)
├── lib/
└── share/
```

Se você extraiu em outro lugar, mova assim:
```bash
mkdir -p ~/tools
# Se está em outro diretório
mv /caminho/para/oss-cad-suite ~/tools/
```

---

## Diferenças do script v2.0

| Aspecto | v1.0 | v2.0 |
|---------|------|------|
| **Download** | ✓ Baixa via wget | ✗ Pula (já extraído) |
| **Verificação** | Espaço/RAM | Espaço/RAM + estrutura oss-cad-suite |
| **Teste tools** | Apenas yosys | yosys + nextpnr-nexus |
| **Caminho** | Genérico | Espera ~/tools/oss-cad-suite |

---

## Evitar travamentos futuros

### Desktop (GNOME)
```bash
# Desabilitar extensões problemáticas
gnome-extensions disable tilingshell@ferrarodomenico.com
gnome-extensions disable dash-to-panel@jderose9.github.com
```

### Monitoring
```bash
# Ver logs em tempo real
journalctl -f

# Copiar script para monitoring
sudo tail -f /var/log/syslog
```

### Boas práticas
- ✅ Sempre use `set -e` em scripts
- ✅ Sempre log com tee (stdout + arquivo)
- ✅ Sempre verificar recursos antes de instalar
- ✅ Nunca use `curl | sh` sem review
- ✅ Use apt/package manager quando possível

---

## Próximas etapas

1. **Executar o script**
```bash
bash ~/github_projects/embedded_systems/scripts/setup_tang_nano_safe.sh
```

2. **Reconectar terminal**
```bash
source ~/.bashrc
```

3. **Testar Tang Nano**
```bash
# Conecte o dispositivo e teste
lsusb | grep Sipeed
openfpgaloader --detect
```

4. **Compilar projeto de teste**
```bash
# Exemplo simplificado (ajuste caminhos conforme sua placa)
cd hdl/tang_nano_1k/blink
yosys -p "read_verilog top.sv; synth_gowin -json blink.json" || true
nextpnr-nexus --json blink.json --asc blink.asc || true
```

---

## Troubleshooting

### Erro: "oss-cad-suite não encontrado"
```bash
# Verificar onde está
find ~/ -name "oss-cad-suite" -type d

# Se encontrar, mover para o lugar correto
mkdir -p ~/tools
mv /caminho/encontrado ~/tools/oss-cad-suite
```

### Se o script falhar em udev
```bash
# Fazer manualmente
sudo groupadd --system plugdev 2>/dev/null || true
sudo usermod -a -G plugdev $USER
newgrp plugdev
```

### Se openfpgaloader não instalar
```bash
# Build from source (alternativa)
git clone https://github.com/trabucayre/openFPGALoader
cd openFPGALoader
mkdir build && cd build
cmake ..
make
sudo make install
```

### Se houver conflito de PATH
```bash
# Verificar PATH atual
echo $PATH

# Remover entradas indesejadas
# Editar ~/.bashrc ou ~/.bashrc_tang_nano
```

---

**Atualizado em:** 30/04/2026  
**Versão:** 2.0 - Otimizado para oss-cad-suite já extraído
