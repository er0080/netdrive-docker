#!/bin/sh

set -e

echo "========================================="
echo "mTCP NetDrive Server Container"
echo "========================================="
echo "Port: ${NETDRIVE_PORT}"
echo "Images Directory: ${NETDRIVE_IMAGES_DIR}"
echo "Bind Address: ${NETDRIVE_BIND_ADDRESS}"
echo "Verbose: ${NETDRIVE_VERBOSE}"
echo "========================================="

# Ensure images directory exists
mkdir -p "${NETDRIVE_IMAGES_DIR}"

# Build command arguments
CMD_ARGS=""

if [ "${NETDRIVE_VERBOSE}" = "true" ]; then
    CMD_ARGS="${CMD_ARGS} -verbose"
fi

if [ -n "${NETDRIVE_PORT}" ]; then
    CMD_ARGS="${CMD_ARGS} -port ${NETDRIVE_PORT}"
fi

if [ -n "${NETDRIVE_BIND_ADDRESS}" ]; then
    CMD_ARGS="${CMD_ARGS} -addr ${NETDRIVE_BIND_ADDRESS}"
fi

# Change to images directory
cd "${NETDRIVE_IMAGES_DIR}"

echo "Starting NetDrive server with args: ${CMD_ARGS}"
echo "Available disk images:"
ls -lh "${NETDRIVE_IMAGES_DIR}"/ 2>/dev/null || echo "  (none yet)"
echo "========================================="

# Execute NetDrive server with arguments
exec /usr/local/bin/netdrive-server ${CMD_ARGS}
