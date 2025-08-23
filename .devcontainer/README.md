# Devcontainer Setup for Labgen

Two devcontainer configurations are provided:

## Option 1: Simple Setup (Recommended)
Uses `devcontainer.json` with post-create script.

## Option 2: Dockerfile Setup
Uses `devcontainer.dockerfile.json` with custom Dockerfile for faster rebuilds.

## Usage

1. Install [VS Code](https://code.visualstudio.com/) and the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

2. Open the project in VS Code

3. When prompted "Reopen in Container", click **Reopen in Container**
   
   Or manually: `Ctrl+Shift+P` → "Dev Containers: Reopen in Container"

4. Choose your configuration:
   - **Default**: Uses the simple setup
   - **Dockerfile**: Rename `devcontainer.dockerfile.json` to `devcontainer.json`

## What's Included

- **Python 3.12** with UV package manager
- **Typst 0.13.1** for document compilation  
- **Watchexec 2.1.1** for file watching during development
- **Make** for build automation
- **VS Code extensions**:
  - Tinymist (Typst language support)
  - Python tools
  - Ruff linting

## Basic Commands

After container starts:

```bash
# Build current lab
make build

# Development mode with auto-rebuild
make dev

# Run Python calculations
make calc

# Check tool versions
typst --version
uv --version
python --version
```

## Troubleshooting

**Container won't start**: Check Docker is running

**Slow first startup**: Container is installing tools, subsequent starts are faster

**Permission issues**: The setup script makes everything executable automatically