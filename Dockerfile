FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

# Pre-accept tshark non-root capture prompt
RUN echo 'wireshark-common wireshark-common/install-setuid boolean true' | debconf-set-selections

# Install general utilities, embedded debugging tools, and network tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    # General utilities
    fd-find \
    ripgrep \
    git \
    openssh-client \
    openssl \
    vim \
    tree \
    python3 \
    python3-pip \
    python3-venv \
    xxd \
    tmux \
    jq \
    curl \
    wget \
    file \
    strace \
    ltrace \
    telnet \
    visidata \
    # Embedded device debugging
    minicom \
    picocom \
    screen \
    lrzsz \
    openocd \
    gdb-multiarch \
    binutils-multiarch \
    i2c-tools \
    spi-tools \
    can-utils \
    usbutils \
    sigrok-cli \
    # Network tools
    netcat-openbsd \
    tshark \
    nmap \
    tcpdump \
    iperf3 \
    socat \
    mosquitto-clients \
    iw \
    wireless-tools \
    iputils-ping \
    net-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install termshark (architecture-aware binary from GitHub)
ARG TERMSHARK_VERSION=2.4.0
ARG TARGETARCH=arm64
RUN curl -fSL "https://github.com/gcla/termshark/releases/download/v${TERMSHARK_VERSION}/termshark_${TERMSHARK_VERSION}_linux_${TARGETARCH}.tar.gz" \
      -o /tmp/termshark.tar.gz \
    && tar -xzf /tmp/termshark.tar.gz -C /tmp \
    && install -m 0755 /tmp/termshark_${TERMSHARK_VERSION}_linux_${TARGETARCH}/termshark /usr/local/bin/termshark \
    && rm -rf /tmp/termshark*

# Build-time extensibility: run a user-provided setup script
ARG USER_SETUP_SCRIPT=""
COPY user-scripts/ /opt/user-scripts/
RUN if [ -n "$USER_SETUP_SCRIPT" ] && [ -f "/opt/user-scripts/$USER_SETUP_SCRIPT" ]; then \
      chmod +x "/opt/user-scripts/$USER_SETUP_SCRIPT" && \
      bash "/opt/user-scripts/$USER_SETUP_SCRIPT"; \
    fi

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
