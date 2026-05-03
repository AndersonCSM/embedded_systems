# Primeiro setup apos o clone

Este guia resume o que precisa ser feito logo apos clonar o repositorio.

## 1) Clonar e entrar no projeto

```bash
git clone https://github.com/AndersonCSM/EmbeddedSystems.git
cd EmbeddedSystems
```

## 2) Conferir a estrutura principal

- `hdl/`: projetos FPGA/HDL
- `embedded/`: projetos de microcontroladores
- `scripts/`: scripts de setup e automacao

## 3) Dependencias pesadas (instalacao local)

Pastas de toolchain pesado, como `oss-cad-suite/`, sao ignoradas no Git por tamanho.
Cada usuario deve instalar localmente na pasta esperada do projeto.

### Tang Nano 1K (HDL)

```bash
cd hdl/tang_nano_1k
bash config/setup_tang_nano_safe.sh
```

Se necessario, baixe manualmente o oss-cad-suite e extraia em `hdl/tang_nano_1k/`.

## 4) Primeiro build (exemplo)

### Tang Nano 1K

```bash
cd hdl/tang_nano_1k/blink
make all
```

### Pico (exemplos CMake)

```bash
cd embedded/pico/blink
cmake -S . -B build
cmake --build build
```

## 5) Boas praticas

- Nao versione pastas de toolchain baixadas localmente.
- Mantenha artefatos de build fora do controle de versao.
- Sempre consultar o README da pasta da placa antes de compilar.
