#!/bin/bash

##############################################################################
# Script SEGURO para configurar Tang Nano 9K com oss-cad-suite + openFPGALoader
# Evita travamentos e logs detalhados de cada etapa
##############################################################################

set -e  # Sair se houver erro

# Caminhos baseados na localização do script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
OSS_CAD_DIR="$PROJECT_DIR/oss-cad-suite"
LOG_FILE="$PROJECT_DIR/setup_tang_nano_$(date +%Y%m%d_%H%M%S).log"

echo "========================================" | tee "$LOG_FILE"
echo "Tang Nano 9K - Setup Seguro" | tee -a "$LOG_FILE"
echo "Log: $LOG_FILE" | tee -a "$LOG_FILE"
echo "Projeto: $PROJECT_DIR" | tee -a "$LOG_FILE"
echo "oss-cad-suite: $OSS_CAD_DIR" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"

# ============================================================================
# ETAPA 1: Verificar espaço em disco e RAM
# ============================================================================
echo "" | tee -a "$LOG_FILE"
echo "[1/5] Verificando recursos do sistema..." | tee -a "$LOG_FILE"

DISK_FREE=$(df /home | tail -1 | awk '{print $4}')
RAM_AVAILABLE=$(free | grep Mem | awk '{print $7}')

echo "  ✓ Espaço livre em /home: $((DISK_FREE / 1024 / 1024))GB" | tee -a "$LOG_FILE"
echo "  ✓ RAM disponível: $((RAM_AVAILABLE / 1024 / 1024))GB" | tee -a "$LOG_FILE"

if [ "$DISK_FREE" -lt 5242880 ]; then
    echo "  ✗ ERRO: Menos de 5GB livres! Libere espaço antes de continuar." | tee -a "$LOG_FILE"
    exit 1
fi

if [ "$RAM_AVAILABLE" -lt 1048576 ]; then
    echo "  ⚠ AVISO: Menos de 1GB RAM disponível. Isso pode causar lentidão." | tee -a "$LOG_FILE"
fi

# ============================================================================
# ETAPA 2: Baixar e instalar oss-cad-suite (se não existir)
# ============================================================================
echo "" | tee -a "$LOG_FILE"
echo "[2/5] Verificando oss-cad-suite..." | tee -a "$LOG_FILE"

if [ -d "$OSS_CAD_DIR" ]; then
    echo "  ✓ oss-cad-suite encontrado em $OSS_CAD_DIR" | tee -a "$LOG_FILE"
    
    # Verificar se contém os binários principais
    if [ -f "$OSS_CAD_DIR/bin/yosys" ]; then
        echo "  ✓ yosys encontrado" | tee -a "$LOG_FILE"
    else
        echo "  ⚠ AVISO: yosys não encontrado, estrutura pode estar incorreta" | tee -a "$LOG_FILE"
    fi
else
    echo "  ✗ ERRO: oss-cad-suite não encontrado em $OSS_CAD_DIR" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
    echo "  Estrutura esperada:" | tee -a "$LOG_FILE"
    echo "     $PROJECT_DIR/" | tee -a "$LOG_FILE"
    echo "     ├── config/" | tee -a "$LOG_FILE"
    echo "     │   └── setup_tang_nano_safe.sh" | tee -a "$LOG_FILE"
    echo "     └── oss-cad-suite/" | tee -a "$LOG_FILE"
    echo "         ├── bin/  (yosys, nextpnr-nexus, etc)" | tee -a "$LOG_FILE"
    echo "         ├── lib/" | tee -a "$LOG_FILE"
    echo "         └── share/" | tee -a "$LOG_FILE"
    exit 1
fi

# ============================================================================
# ETAPA 3: Configurar PATH
# ============================================================================
echo "" | tee -a "$LOG_FILE"
echo "[3/5] Configurando PATH..." | tee -a "$LOG_FILE"

# Criar/atualizar arquivo de configuração no diretório do projeto
BASHRC_TANG="$PROJECT_DIR/.bashrc_tang_nano"
cat > "$BASHRC_TANG" << EOF
# Tang Nano 9K Configuration
export OSS_CAD_SUITE_PATH="$OSS_CAD_DIR/bin"
export PATH="\$OSS_CAD_SUITE_PATH:\$PATH"
EOF

echo "  ✓ Configuração salva em: $BASHRC_TANG" | tee -a "$LOG_FILE"
echo "  → Para usar, execute:" | tee -a "$LOG_FILE"
echo "    source $BASHRC_TANG" | tee -a "$LOG_FILE"

# Carregar configuração
source "$BASHRC_TANG"

# Testar
echo "  → Testando ferramentas..." | tee -a "$LOG_FILE"
if "$OSS_CAD_DIR/bin/yosys" --version >> "$LOG_FILE" 2>&1; then
    YOSYS_VERSION=$("$OSS_CAD_DIR/bin/yosys" --version 2>/dev/null | head -1)
    echo "  ✓ yosys disponível: $YOSYS_VERSION" | tee -a "$LOG_FILE"
else
    echo "  ✗ ERRO: yosys não funcionou" | tee -a "$LOG_FILE"
    exit 1
fi

if "$OSS_CAD_DIR/bin/nextpnr-nexus" --help >> "$LOG_FILE" 2>&1 | head -1; then
    echo "  ✓ nextpnr-nexus disponível" | tee -a "$LOG_FILE"
fi

# ============================================================================
# ETAPA 4: Instalar openFPGALoader (seguro)
# ============================================================================
echo "" | tee -a "$LOG_FILE"
echo "[4/5] Configurando openFPGALoader..." | tee -a "$LOG_FILE"

# Instalar com apt (mais seguro)
echo "  → Instalando openFPGALoader via apt..." | tee -a "$LOG_FILE"

if ! sudo apt-get update >> "$LOG_FILE" 2>&1; then
    echo "  ⚠ AVISO: apt update falhou, continuando..." | tee -a "$LOG_FILE"
fi

if sudo apt-get install -y openfpgaloader >> "$LOG_FILE" 2>&1; then
    echo "  ✓ openFPGALoader instalado" | tee -a "$LOG_FILE"
    if openfpgaloader --help >> "$LOG_FILE" 2>&1; then
        echo "  ✓ openFPGALoader funcional" | tee -a "$LOG_FILE"
    fi
else
    echo "  ⚠ AVISO: Instalação via apt falhou. Pulando openFPGALoader por agora." | tee -a "$LOG_FILE"
fi

# ============================================================================
# ETAPA 5: Configurar regras udev (se necessário)
# ============================================================================
echo "" | tee -a "$LOG_FILE"
echo "[5/5] Configurando permissões de dispositivo..." | tee -a "$LOG_FILE"

# Apenas copiar regras existentes, sem script externo
if [ -f /usr/lib/udev/rules.d/99-openfpgaloader.rules ]; then
    echo "  → Copiando regras udev..." | tee -a "$LOG_FILE"
    sudo cp /usr/lib/udev/rules.d/99-openfpgaloader.rules /etc/udev/rules.d/ 2>> "$LOG_FILE"
    
    echo "  → Recarregando regras udev..." | tee -a "$LOG_FILE"
    sudo udevadm control --reload-rules 2>> "$LOG_FILE"
    sudo udevadm trigger 2>> "$LOG_FILE"
    echo "  ✓ Permissões configuradas" | tee -a "$LOG_FILE"
else
    echo "  ⚠ AVISO: Regras padrão não encontradas" | tee -a "$LOG_FILE"
fi

# ============================================================================
# CONCLUSÃO
# ============================================================================
echo "" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"
echo "✓ Setup concluído com sucesso!" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"
echo "Próximos passos:" | tee -a "$LOG_FILE"
echo "  1. Configure o PATH em novo terminal:" | tee -a "$LOG_FILE"
echo "     source $BASHRC_TANG" | tee -a "$LOG_FILE"
echo "  2. Teste os comandos:" | tee -a "$LOG_FILE"
echo "     yosys --version" | tee -a "$LOG_FILE"
echo "     nextpnr-nexus --help" | tee -a "$LOG_FILE"
echo "  3. Conecte a Tang Nano e teste:" | tee -a "$LOG_FILE"
echo "     lsusb  # Procure por Sipeed" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"
echo "Log completo salvo em: $LOG_FILE" | tee -a "$LOG_FILE"
