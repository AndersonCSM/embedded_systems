# ============================================================================
# Makefile: UART Echo TestBench
# Descrição: Compila e roda simulação do UART Echo
# ============================================================================

# Compilador e simulador
IVERILOG = iverilog
VVP = vvp

# Diretórios
SIM_DIR = ./

# Arquivos
VERILOG_FILES = top.sv baud_rate_generator.sv uart_rx.sv uart_tx.sv tb_top.sv
TB_FILE = tb_top
EXECUTABLE = $(SIM_DIR)/sim
LOG_FILE = simulation_log.txt

# Flags do compilador
IVERILOG_FLAGS = -g2009 -o $(EXECUTABLE)

# ============================================================================
# REGRAS PRINCIPAIS
# ============================================================================

.PHONY: all run_test clean view_log help

# Compilar e rodar teste (regra padrão)
all: run_test

# Compilar e executar a simulação
run_test: compile
	@echo "=========================================="
	@echo "  Executando simulação..."
	@echo "=========================================="
	$(VVP) $(EXECUTABLE) -n 2>&1 | tee $(LOG_FILE)
	@echo ""
	@echo "Teste concluído! Verifique o arquivo: $(LOG_FILE)"
	@echo ""

# Compilar o testbench
compile: $(VERILOG_FILES)
	@echo "=========================================="
	@echo "  Compilando testbench..."
	@echo "=========================================="
	$(IVERILOG) $(IVERILOG_FLAGS) $^
	@echo "Compilação concluída!"
	@echo ""

# Visualizar o arquivo de log
view_log: $(LOG_FILE)
	@echo "=========================================="
	@echo "  Conteúdo do arquivo de log:"
	@echo "=========================================="
	@cat $(LOG_FILE)

# Visualizar apenas o resumo (últimas linhas)
view_summary: $(LOG_FILE)
	@echo "=========================================="
	@echo "  Resumo do teste:"
	@echo "=========================================="
	@tail -20 $(LOG_FILE)

# Limpar arquivos de compilação
clean:
	@echo "Limpando arquivos temporários..."
	rm -f $(EXECUTABLE)
	rm -f $(LOG_FILE)
	@echo "Limpeza concluída!"

# Limpar tudo (incluindo logs)
clean_all: clean
	@echo "Removendo todos os arquivos gerados..."

# Mostrar ajuda
help:
	@echo "=========================================="
	@echo "  UART Echo - Makefile Help"
	@echo "=========================================="
	@echo ""
	@echo "Targets disponíveis:"
	@echo ""
	@echo "  make run_test    - Compila e roda a simulação"
	@echo "  make compile     - Apenas compila o testbench"
	@echo "  make view_log    - Exibe o arquivo de log completo"
	@echo "  make view_summary- Exibe apenas o resumo do teste"
	@echo "  make clean       - Remove arquivos de compilação"
	@echo "  make clean_all   - Remove tudo (compilação + logs)"
	@echo "  make help        - Mostra esta mensagem"
	@echo ""
	@echo "Uso típico:"
	@echo "  make run_test   # Rodar simulação"
	@echo "  make view_log   # Ver resultados"
	@echo ""

# ============================================================================
# VARIÁVEIS ESPECIAIS
# ============================================================================

# Sempre executar estas regras (mesmo que o arquivo exista)
.PHONY: all run_test compile clean clean_all view_log view_summary help
