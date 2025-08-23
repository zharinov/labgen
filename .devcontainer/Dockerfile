FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    make \
    git \
    ca-certificates \
    build-essential \
    python3.12 \
    python3.12-dev \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Create symlink for python
RUN ln -sf /usr/bin/python3.12 /usr/local/bin/python

# Install UV (Python package manager)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.cargo/bin:$PATH"

# Install Typst
RUN TYPST_VERSION="v0.13.1" && \
    wget -q https://github.com/typst/typst/releases/download/${TYPST_VERSION}/typst-x86_64-unknown-linux-musl.tar.xz && \
    tar -xf typst-x86_64-unknown-linux-musl.tar.xz && \
    mv typst-x86_64-unknown-linux-musl/typst /usr/local/bin/ && \
    rm -rf typst-x86_64-unknown-linux-musl*

# Install Watchexec
RUN WATCHEXEC_VERSION="2.1.1" && \
    wget -q https://github.com/watchexec/watchexec/releases/download/v${WATCHEXEC_VERSION}/watchexec-${WATCHEXEC_VERSION}-x86_64-unknown-linux-musl.tar.xz && \
    tar -xf watchexec-${WATCHEXEC_VERSION}-x86_64-unknown-linux-musl.tar.xz && \
    mv watchexec-${WATCHEXEC_VERSION}-x86_64-unknown-linux-musl/watchexec /usr/local/bin/ && \
    rm -rf watchexec-*

# Create vscode user
RUN useradd -m -s /bin/bash vscode && \
    usermod -aG sudo vscode && \
    echo 'vscode ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to vscode user
USER vscode
WORKDIR /home/vscode

# Install UV for vscode user
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/home/vscode/.cargo/bin:$PATH"

# Set working directory
WORKDIR /workspaces/labgen

# Verify installations
RUN typst --version && \
    uv --version && \
    watchexec --version && \
    python --version

CMD ["/bin/bash"]