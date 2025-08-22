FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system packages (changes infrequently)
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
    sudo \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/bin/python3.12 /usr/local/bin/python

# Create user early (rarely changes)
RUN useradd -m -s /bin/bash vscode && \
    usermod -aG sudo vscode && \
    echo 'vscode ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install Rust toolchain as root (changes infrequently)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"

# Install all tools system-wide (changes less frequently than project dependencies)
ENV CARGO_INSTALL_ROOT=/usr/local
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    mv /root/.local/bin/uv /usr/local/bin/uv && \
    mv /root/.local/bin/uvx /usr/local/bin/uvx

RUN curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash

RUN cargo binstall -y --disable-telemetry typst-cli
RUN cargo binstall -y --disable-telemetry watchexec-cli

# Switch to user and set workdir
USER vscode
WORKDIR /workspaces/labgen

# Version checks at the end (for debugging, doesn't affect caching much)
RUN typst --version && \
    uv --version && \
    watchexec --version && \
    python --version

CMD ["/bin/bash"]
