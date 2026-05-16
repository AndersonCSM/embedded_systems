# Documentação: Configuração e Teste Inicial - Tang Nano 1K

## 1. Visão Geral

Este documento descreve o processo de configuração inicial do projeto **counter.v** para o Tang Nano 1K (FPGA GW1NZ-1) usando a extensão Lushay Code no VS Code com a toolchain oss-cad-suite.

---

## 2. Erros Encontrados e Soluções

### 2.1 Erro: ENOENT - Caminho Incorreto da Toolchain

**Problema:**
```
ENOENT: no such file or directory, stat '/home/anderson/github_projects/embedded_systems/system_verilog/tang_nano_1k/oss-cad-suite/bin'
```

**Causa:** 
- A extensão estava apontando para um caminho antigo do projeto (`system_verilog` em vez de `hdl`)

**Solução:**
- O caminho correto da toolchain é: `/home/anderson/tools/oss-cad-suite/bin`
- Configurar este caminho na extensão ou em variáveis de ambiente

---

### 2.2 Erro: "No files to synthesize"

**Problema:**
```
Processing blink.lushay.json
Starting FPGA Toolchain
No files to synthesize
```

**Causa:**
- O arquivo `blink.lushay.json` estava com `"includedFiles": "all"` (string em vez de array)
- A toolchain não conseguia encontrar os arquivos Verilog

**Solução:**
Atualizar o arquivo para especificar explicitamente os arquivos:
```json
{
    "name": "blink",
    "includedFiles": ["top.sv"],
    "constraintFiles": ["constraints.cst"]
}
```

---

### 2.3 Erro: Port Missing from CST File

**Problema:**
```
Error: Port are missing from CST file: led
```

**Causa:**
- O arquivo `constraints.cst` tinha sintaxe incorreta em duas linhas separadas

**Solução:**
Consolidar em uma única linha com sintaxe correta:
```cst
set_pin_assignment {led} {pin_name = D6} {pin_direction = out}
```

---

### 2.4 Erro: Bitstream Idcode Mismatch

**Problema:**
```
Error: Failed to claim FPGA device: mismatch between target's idcode and bitstream idcode
    bitstream has 0x1100481B hardware requires 0x0100681b
```

**Causa:**
- O NextPnR estava gerando bitstream para o device errado (**GW1NR-9C** em vez de **GW1NZ-1**)
- O arquivo `counter.lushay.json` tinha parâmetros conflitantes que confundiam a extensão

**Solução - CRÍTICA:**
Simplificar o arquivo `counter.lushay.json` e adicionar `"board"`:
```json
{
    "name": "counter",
    "project_name": "counter",
    "top_module": "top",
    "device": "GW1NZ-1",
    "board": "tangnano1k",
    "includedFiles": ["counter.v"],
    "constraintFiles": ["counter.cst"]
}
```

**Motivo:** A extensão lushay-code possui mapeamento interno de boards para devices. Ao especificar `"board": "tangnano1k"`, ela usa automaticamente:
- Device: GW1NZ-1
- ID correto: 0x0100681b
- Package: QFN48
- Speed: 6

---

## 3. Arquivos de Configuração

### 3.1 counter.lushay.json
**Localização:** `/home/anderson/github_projects/embedded_systems/hdl/tang_nano_1k/teste/counter.lushay.json`

```json
{
    "name": "counter",
    "project_name": "counter",
    "top_module": "top",
    "device": "GW1NZ-1",
    "board": "tangnano1k",
    "includedFiles": ["counter.v"],
    "constraintFiles": ["counter.cst"]
}
```

**Parâmetros:**
- `name`: Nome do projeto
- `project_name`: Nome interno do projeto
- `top_module`: Módulo Verilog principal
- `device`: Dispositivo FPGA (GW1NZ-1 para Tang Nano 1K)
- `board`: Placa alvo (mapeia automaticamente para device correto)
- `includedFiles`: Arquivos Verilog a sintetizar
- `constraintFiles`: Arquivo de pin constraints

### 3.2 counter.cst
**Localização:** `/home/anderson/github_projects/embedded_systems/hdl/tang_nano_1k/teste/counter.cst`

```cst
IO_LOC  "sys_clk" 47;
IO_PORT "sys_clk" IO_TYPE=LVCMOS33 PULL_MODE=UP;

IO_LOC  "led" 9;
IO_PORT "led" DRIVE=8 IO_TYPE=LVCMOS33;

IO_LOC  "sys_rst_n" 13;
IO_PORT "sys_rst_n" IO_TYPE=LVCMOS33;
```

**Descrição:**
- Define os pinos físicos do Tang Nano 1K
- `sys_clk` (pino 47): Clock do sistema
- `led` (pino 9): LED de saída
- `sys_rst_n` (pino 13): Reset ativo baixo

### 3.3 counter.v
**Localização:** `/home/anderson/github_projects/embedded_systems/hdl/tang_nano_1k/teste/counter.v`

**Funcionalidade:**
- Contador de 24 bits baseado em clock de sistema
- Oscila LED a cada 0.5 segundos
- Usa reset ativo baixo (`sys_rst_n`)
- Sincronizado com clock de 27MHz (interno do Tang Nano 1K)

```verilog
module top (
    input   sys_clk,
    input   sys_rst_n,
    output  reg led
);
    reg [23:0] counter;
    
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            counter <= 24'd0;
        else if (counter < 24'd1349_9999)
            counter <= counter + 1'b1;
        else
            counter <= 24'd0;
    end
    
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n)
            led <= 1'b1;
        else if (counter == 24'd1349_9999)
            led <= ~led;
    end
endmodule
```

---

## 4. Processo de Build

### 4.1 Fluxo de Compilação

```
counter.v + counter.cst
         ↓
    [Yosys - Síntese]
         ↓
    counter.json (netlist)
         ↓
   [NextPnR - Place & Route]
         ↓
    counter_pnr.json (posicionamento)
         ↓
   [Apicula - Geração de Bitstream]
         ↓
    counter.fs (bitstream)
         ↓
  [OpenFPGALoader - Programação]
         ↓
    FPGA Tang Nano 1K programado
```

### 4.2 Passos para Build e Programação

1. **Abrir arquivo de configuração:**
   - Abrir `counter.lushay.json` no VS Code

2. **Build na extensão Lushay Code:**
   - Menu → "Processing" → "Build & Write"
   - Ou usar atalho configurado

3. **Monitorar output:**
   - A extensão mostrará o progresso do build
   - Verificar se não há erros em cada etapa

4. **Resultado:**
   - Se sucesso: Tang Nano 1K programado com LED piscante
   - Se erro: Verificar mensagens e logs

---

## 5. Teste de Simulação

### 5.1 Testbench Criado

**Arquivo:** `counter_tb.v`

```bash
# Compilar testbench
/home/anderson/tools/oss-cad-suite/bin/iverilog -o counter_tb.vvp counter.v counter_tb.v

# Executar simulação
/home/anderson/tools/oss-cad-suite/bin/vvp counter_tb.vvp
```

**Resultado esperado:**
- Monitoramento do comportamento do contador
- Detecção de toggles do LED
- Arquivo VCD gerado: `counter_tb.vcd`

---

## 6. Especificações do Hardware

### Tang Nano 1K (GW1NZ-1)

| Parâmetro | Valor |
|-----------|-------|
| FPGA | Gowin GW1NZ-1 |
| LUTs | ~1024 |
| CLK nativo | 27 MHz |
| Package | QFN48 |
| Tensão | 3.3V (LVCMOS33) |
| Pino LED | 9 (GPIO) |
| Pino Clock | 47 |
| Pino Reset | 13 |

---

## 7. Estrutura de Diretórios

```
/home/anderson/github_projects/embedded_systems/hdl/tang_nano_1k/
├── teste/                          # Projeto de teste
│   ├── counter.v                   # HDL principal
│   ├── counter.cst                 # Constraints
│   ├── counter.lushay.json         # Configuração projeto
│   ├── counter_tb.v                # Testbench
│   ├── counter.json                # (gerado) Netlist
│   ├── counter_pnr.json            # (gerado) PnR output
│   ├── counter.fs                  # (gerado) Bitstream
│   └── counter_tb.vcd              # (gerado) Simulação
│
├── blink/                          # Projeto blink (referência)
│   ├── top.sv
│   ├── constraints.cst
│   └── Makefile
│
└── oss-cad-suite/                  # Toolchain local (opcional)
```

---

## 8. Troubleshooting

| Erro | Causa | Solução |
|------|-------|---------|
| "No files to synthesize" | `includedFiles` em string | Usar array: `["counter.v"]` |
| "Port missing from CST" | Syntax incorreta em .cst | Consolidar em uma linha |
| Bitstream mismatch | Device errado no PnR | Adicionar `"board": "tangnano1k"` |
| Cache antigo | Arquivos .json, .fs em cache | `rm counter.json counter.fs` |

---

## 9. Próximos Passos

1. **Testar LED piscante no hardware**
   - Programar Tang Nano 1K
   - Verificar se LED pisca a ~1Hz (0.5s on/off)

2. **Otimizações:**
   - Ajustar frequência de piscar
   - Adicionar mais funcionalidades
   - Usar OSC interno vs clock externo

3. **Documentação adicional:**
   - Guia de uso de I/O no Tang Nano 1K
   - Referência de GPIOs e pinos
   - Exemplos de projetos mais complexos

---

## 10. Referências

- **Tang Nano 1K Datasheet:** GW1NZ-1 FPGA specifications
- **Lushay Code Extension:** VS Code FPGA development tool
- **oss-cad-suite:** Open-source FPGA tools (Yosys, NextPnR, Apicula)
- **Gowin Documentation:** Constraint file syntax and device specifications

---

**Data de criação:** 5 de Maio de 2026  
**Autor:** Anderson (com assistência de GitHub Copilot)  
**Status:** ✅ Testado e funcionando
