#!/bin/sh

set -e

echo "========================================="
echo "mTCP NetDrive Server Container"
echo "========================================="
echo "Port: ${NETDRIVE_PORT}"
echo "Images Directory: ${NETDRIVE_IMAGES_DIR}"
echo "========================================="

# Ensure images directory exists
mkdir -p "${NETDRIVE_IMAGES_DIR}"

# Build serve command arguments
# Format: netdrive serve [flags]
SERVE_ARGS="-headless"

if [ -n "${NETDRIVE_PORT}" ]; then
    SERVE_ARGS="${SERVE_ARGS} -port ${NETDRIVE_PORT}"
fi

if [ -n "${NETDRIVE_IMAGES_DIR}" ]; then
    SERVE_ARGS="${SERVE_ARGS} -image_dir ${NETDRIVE_IMAGES_DIR}"
fi

echo "Starting NetDrive server with: serve ${SERVE_ARGS}"
echo "Available disk images:"
ls -lh "${NETDRIVE_IMAGES_DIR}"/ 2>/dev/null || echo "  (none yet)"
echo "========================================="

# Execute NetDrive server with serve command and arguments
# Note: -headless flag is required for Docker (non-interactive mode)
exec /usr/local/bin/netdrive-server serve ${SERVE_ARGS}
