# LabGen

Lab report generation system using Typst and Python.

## Requirements

### uv
[[site](https://astral.sh/uv)] [[docs](https://docs.astral.sh/uv/)] [[install](https://docs.astral.sh/uv/getting-started/installation/)]

### Make
[[tutorial](https://learnxinyminutes.com/make/)] [[install](https://itsfoss.com/make-command-not-found-ubuntu/)]

### Python
[[site](https://www.python.org/)] [[docs](https://docs.python.org/)] [[install](https://realpython.com/installing-python/)]

### Typst
[[site](https://typst.app/)] [[docs](https://typst.app/docs/)] [[install](https://github.com/typst/typst#installation)]

### watchexec
[[site](https://watchexec.github.io/)] [[docs](https://watchexec.github.io/)] [[install](https://github.com/watchexec/watchexec#install)]

## Setup

```bash
uv sync
```

## Usage

Navigate to a lab directory (e.g., `L1`) and run:

```bash
make build
```

This will:
1. Run calculations (`calc.py` if present)
2. Compile the Typst document to PDF

## Development

For auto-rebuild on file changes:

```bash
make dev
```

## Configuration

Edit `config.toml` in the project root for course info and student details.

Each lab has its own `input.toml` for lab-specific parameters.

## Structure

- `L1/`, `L2/`, etc. - Individual lab directories
- `common.typ` - Shared Typst templates
- `fonts/` - Custom fonts for Typst compilation
- `Makefile.tpl` - Shared build configuration
