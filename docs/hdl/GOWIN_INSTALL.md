# Guide — Gowin IDE on Windows for Tang Nano 1K

> **Board:** Sipeed Tang Nano 1K (GW1NZ-LV1QN48C6/I5)  
> **Software:** Gowin FPGA Designer (Education) V1.9.11.03  
> **System:** Windows 10/11  

---

## 📋 Index

1. [Download](#download)
2. [Installation](#installation)
3. [Verification](#verification)
4. [Next Steps](#next-steps)
5. [Troubleshooting](#troubleshooting)

---

## Download

Acesse o site oficial da Gowin:  
🔗 https://www.gowinsemi.com/en/support/download_eda/

Baixe a versão **Education** (gratuita, sem necessidade de licença) para Windows.

---

## Instalação

### Executar Instalador

1. Execute o instalador **como Administrador**
2. Aceite os termos de licença
3. Siga o wizard padrão

### O que é Instalado

O instalador também instala automaticamente:
- **Gowin Programmer** (ferramenta para gravar a FPGA)
- **Drivers USB FTDI** (comunicação com a placa)

### Verificar Instalação

Após a instalação:
1. Abra o **Gowin FPGA Designer**
2. Se abrir sem erros, a instalação foi bem-sucedida ✅

---

## Verificação

### Requisito Importante

⚠️ **O caminho de instalação e dos projetos deve conter apenas letras, números e `_`.**

Evite:
- ❌ Acentos (ex: `Área de Trabalho`)
- ❌ Espaços (ex: `Meus Documentos`)
- ❌ Caracteres especiais (ex: `@`, `#`, `&`)

### Teste

Crie um caminho seguro:

```
C:\fpga\
C:\fpga\my_project\
C:\fpga\tang_nano_1k\
```

---

## Próximos Passos

Após instalar o Gowin IDE, siga um dos guias:

### Desenvolver Projeto
→ Consulte [`WORKFLOW.md`](WORKFLOW.md) — **Seção 1: Gowin IDE (Windows)**

Para um projeto de exemplo (Blink), veja:
- Criação de projeto
- Código Verilog
- Síntese
- Constraints
- Programação

### Alternativas

Se preferir outro ambiente:
- **Quartus Prime Lite** → [`QUARTUS_INSTALL.md`](QUARTUS_INSTALL.md)
- **VS Code + oss-cad-suite (Linux)** → [`TANG_NANO_LINUX.md`](TANG_NANO_LINUX.md)

---

## Troubleshooting

### Instalação lenta / trava

**Causa:** Antivírus ou tráfego de rede.

**Solução:**
1. Desabilitar temporariamente antivírus
2. Usar conexão de rede estável
3. Tentar novamente

### "Invalid path" após instalação

**Causa:** Caminho com espaços, acentos ou caracteres especiais.

**Solução:**
1. Desinstalar Gowin
2. Reinstalar em caminho sem caracteres especiais: `C:\fpga\`

### IDE não abre

**Causa:** Drivers USB ou dependências faltando.

**Solução:**
1. Reinstalar o Gowin IDE
2. Se persistir, reinstalar drivers FTDI manualmente

### Drivers USB não instalados

**Solução:**
1. Conecte a placa Tang Nano via USB-C
2. Abra **Gerenciador de Dispositivos**
3. Localize o dispositivo desconhecido
4. Clique direito → **Atualizar driver** → procurar em `C:\Program Files\Gowin EDA\drivers\`

---

**Última atualização:** 6 de maio de 2026
- Pinos invertidos no `.cst` → verifique o pinout

---

## Referências

- 📖 [Sipeed Wiki — Tang Nano 1K](https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-1K/Nano-1K.html)
- 📖 [Exemplos oficiais Tang Nano 1K](https://github.com/sipeed/TangNano-1K-examples)
- 📖 [Gowin Software User Guide](https://www.gowinsemi.com/upload/database_doc/1/document/5bfcfcab42d1c.pdf)
- 📖 [Gowin User Messages Reference](https://cdn.gowinsemi.com.cn/SUG937E.pdf)

---

*Guia elaborado com base na experiência prática de configuração no Windows 11 com Tang Nano 1K e Gowin IDE Education V1.9.11.03*
