# Configuração de Ambiente SystemVerilog no Linux

Este guia detalha a configuração de um ambiente de desenvolvimento moderno e otimizado no Linux para a descrição de hardware utilizando **SystemVerilog**, focado na produtividade via terminal e editores de texto modernos, evitando interfaces gráficas pesadas (GUIs).



## Objetivo
Configurar ferramentas de desenvolvimento em um sistema Linux para a prática de descrição, simulação e síntese de hardware em SystemVerilog.

## Hardware Alvo
* **Altera CPLD MAX II** (Suportado pelo Quartus Prime)
* **Altera DE2-115** (Suportado pelo Quartus Prime)
* **Tang Nano 20K** (FPGA Gowin - Suportado por Yosys/NextPNR ou Gowin EDA)

## Softwares Necessários
* **Quartus Prime Lite Edition (Linux):** Para síntese, roteamento e gravação das placas Altera.
* **OSS CAD Suite (Yosys / NextPNR / openFPGALoader):** Para síntese e gravação da Tang Nano 20K.
* **VS Code:** Editor de código principal.
* **Verilator:** Para simulação de alta performance.
* **Verible:** Para formatação e linting (análise de erros) de SystemVerilog.

---

## Etapas de Configuração

### 1. Editor de Código: VS Code + Verible
Para ter autocompletar e detecção de erros em tempo real:

1. Instale o VS Code.
2. No Linux, instale o Verible (ferramenta do Google para SystemVerilog):
```bash
wget [https://github.com/chipsalliance/verible/releases/latest/download/verible-linux-x86_64.tar.gz](https://github.com/chipsalliance/verible/releases/latest/download/verible-linux-x86_64.tar.gz)
tar -xvf verible-linux-x86_64.tar.gz
sudo cp verible-*/bin/* /usr/local/bin/
```


No VS Code, instale a extensão Verible ou TerosHDL e aponte para o executável recém-instalado.

**Dica de Produtividade:** Crie um Profile (Perfil) específico no VS Code chamado "Hardware/Verilog". Nele, deixe ativas apenas as extensões de SystemVerilog, C++ (para o Verilator) e Makefile. Isso mantém sua IDE leve e evita conflitos com extensões de outras linguagens (como Java ou Python).

### 2. Simulação: Verilator
O Verilator converte seu código SystemVerilog para C++, gerando um executável extremamente rápido para simulação.

Instale as dependências e o Verilator via gerenciador de pacotes:
```bash
sudo apt update
sudo apt install verilator g++ make
```
### 3. Fluxo de Síntese: Makefile
O uso de um Makefile unifica os comandos de síntese tanto para as placas da Altera quanto para a Tang Nano, permitindo compilar projetos com um único comando.

Crie um arquivo chamado Makefile na raiz do seu projeto:
```bash
# Variáveis Gerais
PROJECT = top_module
SV_FILES = src/top_module.sv

# ==========================================
# Alvo: Altera DE2-115 (Quartus)
# ==========================================
FAMILY_DE2 = "Cyclone IV E"
PART_DE2 = EP4CE115F29C7

quartus_de2:
	quartus_sh --prepare -f $(FAMILY_DE2) -d $(PART_DE2) -t $(PROJECT) $(PROJECT)
	echo "set_global_assignment -name SYSTEMVERILOG_FILE $(SV_FILES)" >> $(PROJECT).qsf
	quartus_map $(PROJECT)
	quartus_fit $(PROJECT)
	quartus_asm $(PROJECT)

prog_de2:
	quartus_pgm -c USB-Blaster -m jtag -o "p;$(PROJECT).sof"

# ==========================================
# Alvo: Tang Nano 20K (Yosys/NextPNR)
# ==========================================
tang20k:
	yosys -p "read_verilog -sv $(SV_FILES); synth_gowin -top $(PROJECT) -json $(PROJECT).json"
	nextpnr-gowin --json $(PROJECT).json --write $(PROJECT)_pnr.json --device GW2AR-LV18QN88C8/I7 --cst src/pins.cst
	gowin_pack -d GW2AR-18 -o $(PROJECT).fs $(PROJECT)_pnr.json

prog_tang20k:
	openFPGALoader -b tangnano20k $(PROJECT).fs

# ==========================================
# Limpeza
# ==========================================
clean:
	rm -rf db incremental_db output_files *.json *.fs *.sof *.qpf *.qsf
```
### 4. Como Usar
O ciclo de desenvolvimento segue estes passos no terminal integrado do VS Code:

**1. Escrever:** Edite seus arquivos .sv na pasta src/. O Verible apontará erros de sintaxe em tempo real.

**2. Simular:** Use o Verilator para testar a lógica antes de ir para a placa (requer a criação de um arquivo testbench em C++).
```bash
verilator --cc src/top_module.sv --exe tb_top.cpp
make -C obj_dir -f Vtop_module.mk
./obj_dir/Vtop_module
```
**3. Sintetizar:** Dependendo da placa que vai usar, chame o alvo correspondente no Makefile:

Para DE2-115: make quartus_de2

Para Tang Nano 20k: make tang20k

**4. Gravar:** Conecte a placa no USB e execute:

Para DE2-115: make prog_de2

Para Tang Nano 20k: make prog_tang20k

### 5. Exemplo (Blinky em SystemVerilog)
Crie o arquivo src/top_module.sv:
```bash
module top_module (
    input  logic clk,
    output logic led
);

    logic [24:0] counter;

    always_ff @(posedge clk) begin
        counter <= counter + 1'b1;
    end

    assign led = counter[24];

endmodule
```
### 6. Referências
- Verilator Manual: https://verilator.org/guide/latest/
- Verible Repository: https://github.com/chipsalliance/verible
- Lushay Labs (Tutoriais Tang Nano no Linux): https://learn.lushaylabs.com/
- Quartus Command-Line Scripting: Documentação oficial da Intel FPGA.

