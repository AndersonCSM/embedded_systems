# Workflow de Desenvolvimento — Projeto Blink

Guia de desenvolvimento do mesmo projeto **Blink** em três ambientes diferentes:
- **Gowin IDE** (Windows, interface gráfica)
- **Quartus Prime Lite** (Windows/Linux, interface gráfica)
- **VS Code + oss-cad-suite** (Linux, terminal + editor)

Cada seção é um guia completo do projeto, desde criação até programação.

---

## 📋 Índice

1. [Projeto: Blink — Visão Geral](#projeto-blink--visão-geral)
2. [Workflow 1: Gowin IDE (Windows)](#workflow-1-gowin-ide-windows)
3. [Workflow 2: Quartus Prime Lite](#workflow-2-quartus-prime-lite)
4. [Workflow 3: VS Code + oss-cad-suite (Linux)](#workflow-3-vs-code--oss-cad-suite-linux)
5. [Comparação de Workflows](#comparação-de-workflows)

---

## Projeto: Blink — Visão Geral

### Objetivo

Criar um projeto simples que pisca 3 LEDs RGB na placa **Tang Nano 1K** ou **MAX II**.

### Hardware

**Tang Nano 1K (Gowin):**
- **Clock:** 27MHz (pino 47)
- **Reset:** Botão (pino 13, ativo baixo)
- **LEDs:** RGB (pinos 10, 9, 11)

**MAX II (Altera):**
- **Clock:** 50MHz (depende da placa)
- **Reset:** Botão (depende da placa)
- **LEDs:** Depende da placa (verificar documentação)

### Código Verilog (Comum)

```verilog
//=======================================================
// Projeto: Blink LED
// Placa:   Tang Nano 1K (Gowin) ou MAX II (Altera)
// Clock:   27MHz (Tang Nano) ou 50MHz (MAX II)
// LEDs:    led[0]=R, led[1]=G, led[2]=B (RGB)
//=======================================================

module top (
    input        sys_clk,    // clock
    input        sys_rst_n,  // reset ativo baixo (botão)
    output reg [2:0] led     // 3 LEDs: R=led[0], G=led[1], B=led[2]
);

    // Contador de 24 bits (~0.6s para 27MHz)
    reg [23:0] counter;

    // Incrementa o contador
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            counter <= 24'd0;
        else if (counter < 24'd13499999)
            counter <= counter + 1'b1;
        else
            counter <= 24'd0;
    end

    // Rotaciona os LEDs a cada ciclo do contador
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            led <= 3'b110;
        else if (counter == 24'd13499999)
            led[2:0] <= {led[1:0], led[2]};
        else
            led <= led;
    end

endmodule
```

> 💡 **Nota:** Para MAX II, ajuste o valor do contador para a frequência de clock da placa.

---

---

# Workflow 1: Gowin IDE (Windows)

Desenvolvimento usando **Gowin FPGA Designer** — interface gráfica completa.

**Pré-requisito:** Leia [`GOWIN_INSTALL.md`](GOWIN_INSTALL.md) para instalar o Gowin IDE.

---

## 1. Criar Projeto

1. Abra o **Gowin FPGA Designer**
2. `File` → `New` → **FPGA Design Project** → OK
3. Configure:
   - **Project Name:** `blink` (use apenas letras e `_`)
   - **Project Path:** ex. `C:\fpga\tang_nano_1k\blink` (sem espaços)
4. Clique em **Next**
5. Selecione o dispositivo:
   - **Series:** GW1NZ
   - **Device:** GW1NZ-1
   - **Package:** QN48
   - **Speed:** C6/I5
   - **Part Number:** `GW1NZ-LV1QN48C6/I5`
6. Clique em **Finish**

---

## 2. Criar Arquivo Verilog

1. `File` → `New` → **Verilog File** → OK
2. Salve como `top.v` dentro da pasta `src/`
3. Copie o código Verilog da [seção anterior](#código-verilog-comum)

---

## 3. Síntese (Synthesize)

1. No painel **Process** (lado esquerdo), dê duplo clique em **Synthesize**
2. Aguarde a conclusão (normalmente 1-2 minutos)

### Mensagens esperadas (normais)

| Tipo | Código | Mensagem |
|------|--------|----------|
| NOTE | EX0101 | Current top module is "top" |
| WARN | TA1132 | 'sys_clk' was determined to be a clock... |

✅ Sucesso: `Finish synthesis, 0 error(s)`

---

## 4. Constraints Físicas (`.cst`)

Mapeia as portas Verilog aos pinos físicos.

### Opção A: Usar Floorplanner (Recomendado)

1. No painel **Process**, clique em **Floorplanner**
2. Arraste as portas para os pinos correspondentes:
   - `sys_clk` → pino 47
   - `sys_rst_n` → pino 13
   - `led[0]` → pino 10
   - `led[1]` → pino 9
   - `led[2]` → pino 11
3. Salve (Ctrl+S)

O arquivo `top.cst` é gerado automaticamente.

### Opção B: Criar Arquivo Manualmente

1. `File` → `New` → **Physical Constraints File** → OK
2. Salve como `top.cst`
3. Copie o conteúdo:

```
IO_LOC "sys_clk"  47;
IO_PORT "sys_clk"  IO_TYPE=LVCMOS18 PULL_MODE=UP BANK_VCCIO=1.8;

IO_LOC "sys_rst_n" 13;
IO_PORT "sys_rst_n" IO_TYPE=LVCMOS18 PULL_MODE=UP BANK_VCCIO=1.8;

IO_LOC "led[0]" 10;
IO_PORT "led[0]" IO_TYPE=LVCMOS18 PULL_MODE=UP DRIVE=8 BANK_VCCIO=1.8;

IO_LOC "led[1]" 9;
IO_PORT "led[1]" IO_TYPE=LVCMOS18 PULL_MODE=UP DRIVE=8 BANK_VCCIO=1.8;

IO_LOC "led[2]" 11;
IO_PORT "led[2]" IO_TYPE=LVCMOS18 PULL_MODE=UP DRIVE=8 BANK_VCCIO=1.8;
```

---

## 5. Constraints de Timing (`.sdc`)

Opcional, mas recomendado para resolver warnings.

1. `File` → `New` → **Timing Constraints File** → OK
2. Salve como `top.sdc`
3. Copie:

```tcl
# Clock de 27MHz — período = 37.037ns
create_clock -name sys_clk -period 37.037 -waveform {0 18.518} [get_ports {sys_clk}]
```

---

## 6. Place & Route

1. No painel **Process**, dê duplo clique em **Place & Route**
2. Aguarde a conclusão

✅ Sucesso: `Finish place and route, 0 error(s)`

O bitstream é gerado em: `impl/pnr/top.fs`

---

## 7. Programação

1. No painel **Process**, dê duplo clique em **Program Device**
2. O **Gowin Programmer** abrirá automaticamente

### Configuração do Cabo

1. `Edit` → `Cable Setting`
2. Clique em **Query/Detect Cable**
3. Verifique:
   - **Cable:** USB Debugger A
   - **Port:** USB Debugger A/0/...
   - ✅ **using ftd2xx driver**
4. Clique **Save**

### Programar

1. Verifique:
   - **Device:** GW1NZ-1
   - **Operation:** SRAM Program (temporário) ou Flash Program (permanente)
   - **FS File:** caminho para `top.fs`
2. Clique **Program/Configure** (▶ verde)
3. Aguarde: `Program Done`

---

## Troubleshooting (Gowin IDE)

### Programmer trava

```
Solução: Gerenciador de Dispositivos → desinstalar JTAG Debugger
        Desconectar/reconectar USB → driver FTDI é reinstalado
```

### "No USB Cable Connection"

```
Solução: Mesmo acima (driver incompatível)
```

### Caminho inválido / caracteres especiais

```
Solução: Mova projeto para C:\fpga\meu_projeto\ (sem espaços/acentos)
```

### LEDs não piscam

```
Possíveis causas:
1. Gravou em SRAM mas desligou → use Flash Program
2. Arquivo .fs desatualizado → recompile
3. Pinos errados → verificar constraints
```

---

---

# Workflow 2: Quartus Prime Lite

Desenvolvimento usando **Quartus Prime Lite** — plataforma Altera.

**Pré-requisito:** Leia [`QUARTUS_INSTALL.md`](QUARTUS_INSTALL.md) para instalar o Quartus.

---

## 1. Criar Projeto

1. Abra o **Quartus Prime Lite**
2. `File` → `New Project Wizard`
3. Configure:
   - **Project Name:** `blink`
   - **Project Directory:** ex. `C:\fpga\max_ii\blink\` ou `/home/user/fpga/max_ii/blink/`
   - **Add Files to Project:** (deixe em branco por enquanto)
4. Clique **Next**
5. Selecione o dispositivo MAX II:
   - **Family:** MAX II
   - **Device:** EPM570T100C5 (ou outro MAX II compatível)
6. Clique **Finish**

---

## 2. Criar Arquivo Verilog

1. `File` → `New`
2. Selecione **Verilog HDL File**
3. Copie o código da [seção inicial](#código-verilog-comum)
4. Salve como `top.v`
5. `File` → `Project` → `Add Files...`
6. Selecione `top.v` e clique **Add**

---

## 3. Síntese

1. `Processing` → `Start Compilation`
2. Aguarde a compilação completa

✅ Sucesso: Sem erros críticos na aba **Messages**.

---

## 4. Constraints Físicos (`.qsf`)

1. `Assignments` → `Pins`
2. Configure os pinos:

| Port Name | Pin # | IO Type |
|-----------|-------|---------|
| sys_clk | (verificar placa) | LVCMOS |
| sys_rst_n | (verificar placa) | LVCMOS |
| led[0] | (verificar placa) | LVCMOS |
| led[1] | (verificar placa) | LVCMOS |
| led[2] | (verificar placa) | LVCMOS |

> **Nota:** Os pinos dependem da placa MAX II específica. Consulte a documentação da placa.

3. Salve o projeto (Ctrl+S)

---

## 5. Place & Route

Já é feito durante a compilação (passo 3).

---

## 6. Gerar Arquivo de Programação

1. `File` → `Convert Programming Files`
2. Configure:
   - **Programming File Type:** SRAM Object File (`.svf`)
   - **Output File Name:** `blink.svf`
3. Clique **Convert**

---

## 7. Programação

1. Conecte a placa via **USB Blaster**
2. `Tools` → `Programmer`
3. Clique **Hardware Setup** e selecione a porta USB Blaster
4. Clique **Start** para programar

---

## Troubleshooting (Quartus)

### USB Blaster não aparece

```
Solução: Verificar drivers (QUARTUS_INSTALL.md, seção Windows)
        Reconectar cabo USB
        jtagconfig (listar dispositivos)
```

### Erros de compilação

```
Solução: Verificar nomes dos pinos
        Confirmar dispositivo MAX II correto
        Revisar código Verilog
```

---

---

# Workflow 3: VS Code + oss-cad-suite (Linux)

Desenvolvimento usando **editor VS Code** + **toolchain oss-cad-suite** — ambiente open-source.

**Pré-requisito:** Leia [`TANG_NANO_LINUX.md`](TANG_NANO_LINUX.md) para instalar oss-cad-suite.

---

## 1. Estrutura de Projeto

Crie a estrutura:

```bash
mkdir -p ~/fpga/tang_nano_blink
cd ~/fpga/tang_nano_blink

# Criar pastas
mkdir -p src constraints build
```

---

## 2. Arquivo Verilog

Crie `src/top.v` com o código da [seção inicial](#código-verilog-comum).

```bash
nano src/top.v
# ou abra no VS Code
code src/top.v
```

---

## 3. Constraints Físicos

Crie `constraints/pins.cst` (Gowin):

```bash
cat > constraints/pins.cst << 'EOF'
IO_LOC "sys_clk"  47;
IO_PORT "sys_clk"  IO_TYPE=LVCMOS18 PULL_MODE=UP BANK_VCCIO=1.8;

IO_LOC "sys_rst_n" 13;
IO_PORT "sys_rst_n" IO_TYPE=LVCMOS18 PULL_MODE=UP BANK_VCCIO=1.8;

IO_LOC "led[0]" 10;
IO_PORT "led[0]" IO_TYPE=LVCMOS18 PULL_MODE=UP DRIVE=8 BANK_VCCIO=1.8;

IO_LOC "led[1]" 9;
IO_PORT "led[1]" IO_TYPE=LVCMOS18 PULL_MODE=UP DRIVE=8 BANK_VCCIO=1.8;

IO_LOC "led[2]" 11;
IO_PORT "led[2]" IO_TYPE=LVCMOS18 PULL_MODE=UP DRIVE=8 BANK_VCCIO=1.8;
EOF
```

---

## 4. Makefile

Crie `Makefile` para automatizar compilação:

```makefile
# Tang Nano 1K (Gowin) Makefile

PROJ_NAME := top
DEVICE := GW1NZ-1
SRC_DIR := src
BUILD_DIR := build
CONSTR_DIR := constraints

# Ferramentas
YOSYS := yosys
NEXTPNR := nextpnr-gowin
PACK := gowin_pack
LOADER := openFPGALoader

# Arquivos
VERILOG := $(wildcard $(SRC_DIR)/*.v)
CONSTRAINTS := $(CONSTR_DIR)/pins.cst
TIMING := $(CONSTR_DIR)/timing.sdc

# Targets
.PHONY: all clean program detect

all: $(BUILD_DIR)/$(PROJ_NAME).fs

$(BUILD_DIR)/$(PROJ_NAME).json: $(VERILOG)
	mkdir -p $(BUILD_DIR)
	$(YOSYS) -m gw1n -d gw1n -p "synth_gowin -json $@ $(VERILOG)"

$(BUILD_DIR)/$(PROJ_NAME).asc: $(BUILD_DIR)/$(PROJ_NAME).json $(CONSTRAINTS)
	$(NEXTPNR) --json $< --asc $@ --device $(DEVICE) --cst $(CONSTRAINTS)

$(BUILD_DIR)/$(PROJ_NAME).fs: $(BUILD_DIR)/$(PROJ_NAME).asc
	$(PACK) -d $(DEVICE) -o $@ $<

program: $(BUILD_DIR)/$(PROJ_NAME).fs
	$(LOADER) -b tangnano1k -f $<

detect:
	$(LOADER) --detect

clean:
	rm -rf $(BUILD_DIR)
```

---

## 5. Compilação

```bash
# Compilar tudo
make all

# Ou passo a passo
make detect              # Detectar FPGA
make                    # Compilar (cria top.fs)
```

---

## 6. Programação

```bash
# Programar FPGA
make program

# Ou manual
openFPGALoader -b tangnano1k build/top.fs
```

---

## 7. Workflow Completo

```bash
cd ~/fpga/tang_nano_blink

# 1. Conectar Tang Nano via USB

# 2. Detectar dispositivo
make detect

# 3. Modificar código se necessário
code src/top.v

# 4. Compilar
make clean
make all

# 5. Programar
make program

# 6. Verificar LEDs piscando! 🎉
```

---

## Troubleshooting (VS Code + oss-cad-suite)

### "Command not found: yosys"

```bash
# Verificar variáveis de ambiente
echo $PATH | grep oss-cad-suite

# Se não aparecer, adicionar ao ~/.bashrc
export PATH="/home/tools/oss-cad-suite/bin:$PATH"
source ~/.bashrc
```

### "Device not found"

```bash
# Verificar conexão USB
lsusb | grep -i ftdi

# Testar permissões
openFPGALoader --detect

# Se falhar, pode precisar de sudo
sudo openFPGALoader --detect

# Ou aplicar regras udev (TANG_NANO_LINUX.md)
```

### Erros de compilação

```bash
# Limpar build
make clean

# Recompilar com verbose
yosys -v -m gw1n -d gw1n -p "synth_gowin -json build/top.json src/top.v"
```

---

---

# Comparação de Workflows

| Aspecto | Gowin IDE | Quartus | VS Code + oss-cad-suite |
|--------|-----------|---------|-------------------------|
| **SO** | Windows | Windows/Linux | Linux/macOS |
| **Interface** | GUI gráfica | GUI gráfica | Terminal + Editor |
| **Licença** | Gratuita (Education) | Gratuita (Lite) | Open-source |
| **Curva de Aprendizado** | ⭐⭐⭐ Fácil | ⭐⭐ Média | ⭐ Avançada |
| **Personalização** | ⭐ Limitada | ⭐⭐ Média | ⭐⭐⭐ Total |
| **Suporte para Scripts** | ❌ Não | ⭐ Sim (TCL) | ⭐⭐⭐ Sim (Makefile) |
| **Debugging** | ⭐⭐ Simulação | ⭐⭐ Simulação | ⭐ RTL-level |
| **Tempo de Compilação** | ⭐⭐ ~2-3 min | ⭐⭐ ~2-3 min | ⭐⭐⭐ <1 min |
| **Tamanho do Toolchain** | ~2GB | ~10GB | ~1GB |

---

## Quando Usar?

### 🎯 Gowin IDE
- ✅ Iniciantes com interface gráfica
- ✅ Desenvolvimento rápido e visual
- ✅ Exclusively Windows
- ✅ Tang Nano com Gowin

### 🎯 Quartus Prime
- ✅ Projetos profissionais
- ✅ Dispositivos Altera/Intel
- ✅ Suporte de licença (importante)
- ✅ Integração com EDA

### 🎯 VS Code + oss-cad-suite
- ✅ Workflows automatizados
- ✅ Controle total (scripts/Makefile)
- ✅ Ambiente open-source
- ✅ Integração com Git
- ✅ Linux/macOS

---

**Última atualização:** 6 de maio de 2026
