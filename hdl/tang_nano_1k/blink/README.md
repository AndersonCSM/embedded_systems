# Tang Nano 1K Blink Project

Simples projeto de LED piscante para a placa **Tang Nano 1K** usando toolchain open-source.

## Hardware

- **Placa**: Tang Nano 1K
- **FPGA**: Gowin GW1NZ-1 (1K LUTs)
- **Oscilador**: 27MHz interno
- **LED**: D6 (LED vermelho padrão)

## Funcionalidade

O projeto implementa um LED piscante com frequência de **1Hz** (0.5s ON / 0.5s OFF).

### Arquitetura

```
Oscilador 27MHz 
    ↓
Contador (divisor de frequência)
    ↓
Flip-Flop toggle
    ↓
LED Output (D6)
```

## Compilação

### Pré-requisitos

- oss-cad-suite (yosys, nextpnr-nexus, apicula) instalado em `../oss-cad-suite/`
- Executar setup_tang_nano_safe.sh previamente
- make
- bash

### Build

```bash
# Compilar tudo (synth + place & route + pack)
make all

# Ou passo-a-passo
make synth      # Synthesis (Yosys)
make place      # Place & Route (nextpnr)
make pack       # Generate bitstream (apicula)
```

## Programação

### Via openFPGALoader (recomendado)

```bash
make program
```

### Manual

```bash
openFPGALoader -b tangnano1k blink.fs
```

## Arquivos do Projeto

| Arquivo | Descrição |
|---------|-----------|
| `top.sv` | Código SystemVerilog principal |
| `constraints.cst` | Mapeamento de pinos (Gowin format) |
| `Makefile` | Build system |
| `build.sh` | Script automático de build |
| `blink.json` | Síntese intermediária (gerado) |
| `blink.config` | Place & Route intermediário (gerado) |
| `blink.fs` | Bitstream final (gerado) |

## Pinos

| Nome | Pino | Função |
|------|------|--------|
| `led` | D6 | Saída digital (LED vermelho) |
| `clk` | Interno | Oscilador 27MHz |

## Troubleshooting

### Erro: "Toolchain not found"

```bash
source ../../.bashrc_tang_nano
```

### Erro: "OSS Cad Suite not available"

Verifique se `../oss-cad-suite/bin/yosys` existe:

```bash
ls -la ../oss-cad-suite/bin/
```

### FPGA não programa

1. Verifique cabo USB
2. Tente modo bootloader:
   ```bash
   openFPGALoader -b tangnano1k -m JTAG blink.fs
   ```

## Próximas Etapas

- Adicionar botão para controlar LED
- Implementar PWM para controlar brilho
- Adicionar UART para comunicação
- Usar PLL para clock de maior frequência

## Referências

- [Gowin FPGA Documentation](https://www.gowinsemi.com/)
- [oss-cad-suite](https://github.com/YosysHQ/oss-cad-suite-build)
- [Tang Nano 1K Schematic](https://dl.sipeed.com/shareURL/TANG/Nano%201k/7_Schematic)
