# mTCP NetDrive Docker Container

A minimal Docker container for running the mTCP NetDrive server, which allows DOS machines to mount remote disk images over a network.

## About mTCP NetDrive

NetDrive is part of the mTCP suite of TCP/IP applications for DOS. The server component runs on modern systems (Linux, Windows, Mac) and serves disk images to DOS clients over UDP.

- **Project Homepage**: https://www.brutman.com/mTCP/
- **NetDrive Documentation**: https://www.brutman.com/mTCP/mTCP_NetDrive.html
- **License**: GPLv3

## Quick Start

### Using Pre-built Image from Docker Hub (Easiest)

```bash
# Create directory for disk images
mkdir -p images

# Run the container
docker run -d \
  --name mtcp-netdrive \
  -p 2002:2002/udp \
  -v $(pwd)/images:/data/images \
  er0080/mtcp-netdrive:latest
```

### Using Docker Compose (Recommended for local development)

1. Clone this repository:
   ```bash
   git clone https://github.com/er0080/netdrive-docker.git
   cd netdrive-docker
   ```

2. Create a directory for your disk images:
   ```bash
   mkdir -p images
   ```

3. Place your disk images (`.dsk` files) in the `images/` directory

4. Start the container:
   ```bash
   docker-compose up -d
   ```

5. View logs:
   ```bash
   docker-compose logs -f
   ```

### Building from Source

1. Clone the repository:
   ```bash
   git clone https://github.com/er0080/netdrive-docker.git
   cd netdrive-docker
   ```

2. Build the image:
   ```bash
   docker build -t mtcp-netdrive .
   ```

3. Run the container:
   ```bash
   docker run -d \
     --name mtcp-netdrive \
     -p 2002:2002/udp \
     -v $(pwd)/images:/data/images \
     -e NETDRIVE_PORT=2002 \
     mtcp-netdrive
   ```

## Environment Variables

Configure the NetDrive server using these environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `NETDRIVE_PORT` | `2002` | UDP port the server listens on |
| `NETDRIVE_IMAGES_DIR` | `/data/images` | Directory containing disk images |

## Connecting from DOS

On your DOS client with mTCP configured:

```
netdrive connect <server-ip>:2002 <image-name>.dsk <drive-letter>:
```

Example:
```
netdrive connect 192.168.1.100:2002 dos622.dsk d:
```

## Volume Mounts

- `/data/images` - Directory containing your disk images (`.dsk` files)

Mount your local directory containing disk images to this path.

## Creating Disk Images

You can create disk images using various tools:

- **On Linux**: Use `dd` or disk imaging tools
- **On Windows**: Use WinImage or similar tools
- **Existing DOS installations**: Use disk imaging utilities

Example using `dd` to create a 100MB image:
```bash
dd if=/dev/zero of=images/mydisk.dsk bs=1M count=100
```

## Ports

- **2002/udp** - NetDrive server port (configurable via `NETDRIVE_PORT`)

**Note**: NetDrive uses UDP protocol, not TCP.

## Security Considerations

- NetDrive is designed for trusted networks
- Consider firewall rules if exposing to the internet
- Use VPN for remote access over untrusted networks
- The server requires no special permissions

## Troubleshooting

### Check server logs
```bash
docker-compose logs -f
```

### List running containers
```bash
docker ps
```

### Test UDP connectivity
From another machine:
```bash
nc -u <server-ip> 2002
```

### Enable verbose logging
The server runs in headless mode by default in Docker. Check container logs with `docker-compose logs -f` to monitor server activity.

## Building from Source

The NetDrive server is written in Go. To build from source instead of using the binary:

1. Download source from https://www.brutman.com/mTCP/
2. Modify Dockerfile to build from source instead of downloading binary

## License

This Docker container configuration is provided as-is. The mTCP NetDrive software is licensed under GPLv3 by Michael Brutman.

## References

- mTCP Homepage: https://www.brutman.com/mTCP/
- NetDrive Documentation: https://www.brutman.com/mTCP/mTCP_NetDrive.html
- mTCP GitHub discussions and community support
