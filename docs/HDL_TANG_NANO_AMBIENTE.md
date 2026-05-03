# Ambiente de desenvolvimento para placas Tang Nano

Guia generico para configurar o ambiente de FPGA da familia Tang Nano (1K, 20K e similares).

## Escopo

Este documento cobre o ambiente comum entre as placas Tang Nano:
- Toolchain open-source com oss-cad-suite
- Sintese/place-route para fluxo Gowin
- Programacao via openFPGALoader

## Importante

A pasta `oss-cad-suite/` nao e versionada no Git porque e muito pesada.
Apos clonar o repositorio, cada usuario deve baixar/instalar localmente.

## Estrutura recomendada por placa

```text
hdl/
  tang_nano_1k/
    blink/
    config/
    oss-cad-suite/   # local, ignorado no Git
  tang_nano_20k/
    ...
```

## Pre-requisitos

- Linux/macOS/WSL
- Espaco em disco (recomendado: >= 5 GB)
- Internet para baixar toolchain

## Instalacao do oss-cad-suite

Opcao A (recomendada): usar script da pasta da placa, quando existir.

Exemplo para Tang Nano 1K:

```bash
cd ~/github_projects/embedded_systems/hdl/tang_nano_1k
bash config/setup_tang_nano_safe.sh
```

Opcao B (manual):

```bash
wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/VERSAO/oss-cad-suite-linux-x64.tgz
tar -xzf oss-cad-suite-linux-x64.tgz
```

Extraia para dentro da pasta da placa, por exemplo:
- `hdl/tang_nano_1k/oss-cad-suite/`
- `hdl/tang_nano_20k/oss-cad-suite/`

## Ferramentas esperadas

- `yosys`
- `nextpnr-*` (varia conforme fluxo)
- `gowin_pack`
- `openFPGALoader`

## Verificacao rapida

```bash
yosys --version
openFPGALoader --version
```

## Build e programacao (exemplo)

```bash
cd hdl/tang_nano_1k/blink
make all
make program
```

## Troubleshooting rapido

### oss-cad-suite not found
- Verifique se a pasta `oss-cad-suite/` foi extraida no diretorio correto da placa.
- Verifique variaveis de ambiente/shell profile da placa.

### Permissao USB ao programar
- Reaplique regras udev e reconecte a placa.
- Reabra sessao para aplicar grupos de permissao.

## Referencias

- https://github.com/YosysHQ/oss-cad-suite-build
- https://github.com/trabucayre/openFPGALoader
- https://www.gowinsemi.com/
