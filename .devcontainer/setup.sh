#!/bin/bash
set -e

echo "Setting up Labgen development environment..."

# Update package lists
sudo apt-get update

# Install basic tools
sudo apt-get install -y curl wget unzip make

# Install Typst
echo "Installing Typst..."
TYPST_VERSION="v0.13.1"
wget -q https://github.com/typst/typst/releases/download/${TYPST_VERSION}/typst-x86_64-unknown-linux-musl.tar.xz
tar -xf typst-x86_64-unknown-linux-musl.tar.xz
sudo mv typst-x86_64-unknown-linux-musl/typst /usr/local/bin/
rm -rf typst-x86_64-unknown-linux-musl*

# Install UV (Python package manager)
echo "Installing UV..."
curl -LsSf https://astral.sh/uv/install.sh | sh
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/.cargo/bin:$PATH"

# Install watchexec for development
echo "Installing watchexec..."
WATCHEXEC_VERSION="2.1.1"
wget -q https://github.com/watchexec/watchexec/releases/download/v${WATCHEXEC_VERSION}/watchexec-${WATCHEXEC_VERSION}-x86_64-unknown-linux-musl.tar.xz
tar -xf watchexec-${WATCHEXEC_VERSION}-x86_64-unknown-linux-musl.tar.xz
sudo mv watchexec-${WATCHEXEC_VERSION}-x86_64-unknown-linux-musl/watchexec /usr/local/bin/
rm -rf watchexec-*

# Install Python dependencies using UV
echo "Installing Python dependencies..."
if [ -f "pyproject.toml" ]; then
    uv sync
fi

# Verify installations
echo "Verifying installations..."
typst --version
uv --version
watchexec --version
python --version

echo "Development environment setup complete!"
echo "You can now run 'make build' to compile documents or 'make dev' for development mode."