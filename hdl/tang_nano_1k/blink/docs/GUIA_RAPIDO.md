# GUIA RÁPIDO: Configuração Tang Nano 1K

## ✅ Status Atual
- **Projeto:** counter.v (LED piscante a ~1Hz)
- **FPGA:** Tang Nano 1K (GW1NZ-1)
- **Status:** ✓ Testado e funcionando
- **Toolchain:** oss-cad-suite (/home/anderson/tools/oss-cad-suite)

---

## 🔧 Configuração Necessária

### Arquivo: `teste/counter.lushay.json`
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

**Parâmetro crítico:** `"board": "tangnano1k"` - sem isso, o device fica errado!

### Arquivo: `teste/counter.cst`
- Define pinos: sys_clk (47), led (9), sys_rst_n (13)
- Todos em LVCMOS33 (3.3V)

---

## 🚀 Como Compilar

### Via Extensão (recomendado)
1. Abrir `teste/counter.lushay.json` no VS Code
2. Menu → "Processing" → "Build & Write"
3. Aguardar conclusão

### Via Terminal
```bash
cd /home/anderson/github_projects/embedded_systems/hdl/tang_nano_1k/teste

# Limpar cache
rm -f counter.json counter_pnr.json counter.fs

# Compilar (se tiver Makefile ou script)
make
```

---

## 📊 Erros Comuns Resolvidos

| Erro | Solução |
|------|---------|
| "No files to synthesize" | Usar array em `includedFiles`, não string |
| "Port missing from CST" | Consolidar linhas do .cst |
| **Bitstream mismatch** | **Adicionar `"board": "tangnano1k"`** ← CRÍTICO |
| Idcode 0x1100481B vs 0x0100681b | Erro de device (ver acima) |

---

## 📁 Arquivos Importantes

```
teste/
├── counter.v           ← Código HDL principal
├── counter.cst         ← Pin constraints
├── counter.lushay.json ← Configuração (NÃO MUDAR!)
├── counter_tb.v        ← Testbench
└── CONFIGURACAO_E_TESTE.md ← Documentação completa
```

---

## 🧪 Testando Simulação

```bash
cd teste
/home/anderson/tools/oss-cad-suite/bin/iverilog -o counter_tb.vvp counter.v counter_tb.v
/home/anderson/tools/oss-cad-suite/bin/vvp counter_tb.vvp
```

---

## 📖 Mais Detalhes

Ver arquivo: `teste/CONFIGURACAO_E_TESTE.md` (documentação completa)

---

**Última atualização:** 5 de Maio de 2026  
**Status:** ✓ Pronto para produção
