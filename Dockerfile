FROM alpine:latest

# Install ca-certificates for HTTPS downloads
RUN apk add --no-cache ca-certificates wget unzip

# Set NetDrive version
ARG NETDRIVE_VERSION=2025-01-10
ARG NETDRIVE_URL=https://www.brutman.com/mTCP/download/mTCP_NetDrive_server-bin_${NETDRIVE_VERSION}.zip

# Download and extract NetDrive server
WORKDIR /tmp
RUN wget ${NETDRIVE_URL} && \
    unzip mTCP_NetDrive_server-bin_${NETDRIVE_VERSION}.zip && \
    mv NetDrive_server_linux_x86_64 /usr/local/bin/netdrive-server && \
    chmod +x /usr/local/bin/netdrive-server && \
    rm -rf /tmp/*

# Create directories for disk images and config
RUN mkdir -p /data/images /config

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Environment variables with defaults
ENV NETDRIVE_PORT=2002 \
    NETDRIVE_VERBOSE=false \
    NETDRIVE_IMAGES_DIR=/data/images \
    NETDRIVE_BIND_ADDRESS=0.0.0.0

# Expose the NetDrive port (UDP)
EXPOSE 2002/udp

# Set working directory
WORKDIR /data

# Use entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
