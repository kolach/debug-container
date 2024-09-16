FROM rust:latest as local

ARG NVIM_VERSION=0.10.0
ARG GO_VERSION=1.23.1
ARG NODE_VERSION=20.x

RUN apt update \
    # Install dependencies
    && apt install -y curl ripgrep xz-utils tmux locales htop \
    # Install node.js
    && curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - \
    && apt-get install -y nodejs \
    # Download and extract Neovim
    && curl -sLO https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux64.tar.gz \
    && tar -xzf nvim-linux64.tar.gz \
    && mv nvim-linux64 /usr/local/nvim \
    && ln -s /usr/local/nvim/bin/nvim /usr/bin/nvim \
    # Download and install Go
    && curl -sLO https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    # Clean up
    && apt clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm go${GO_VERSION}.linux-amd64.tar.gz \
    && rm nvim-linux64.tar.gz

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8

# Set up Go environment variables
ENV PATH="/usr/local/go/bin:${PATH}"

# Configure neovim and add plugins
RUN git clone https://github.com/kolach/nvim.git ~/.config/nvim

# Install plugins
RUN nvim --headless "+Lazy! sync" +qa

# Install LSP servers
RUN nvim --headless "+MasonInstall rust-analyzer codelldb" +qa
RUN nvim --headless "+MasonInstall gopls delve" +qa

COPY tmux.conf /root/.tmux.conf
# Install tmux plugins manager and plugins
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
RUN /root/.tmux/plugins/tpm/bin/install_plugins


# Setup the entrypoint
COPY keep-alive.sh /keep-alive.sh
RUN chmod +x /keep-alive.sh
ENTRYPOINT ["/keep-alive.sh"]
