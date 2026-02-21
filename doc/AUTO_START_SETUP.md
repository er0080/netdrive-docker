# Auto-Start Setup Guide

This guide explains how to configure the mTCP NetDrive Docker container to start automatically on system boot.

## Method 1: Docker Restart Policy (Recommended - Already Configured!)

Your `docker-compose.yml` already includes `restart: unless-stopped`, which provides automatic restart functionality.

### Setup Steps:

1. **Enable Docker to start on boot:**
   ```bash
   sudo systemctl enable docker
   sudo systemctl start docker
   ```

2. **Start your container once:**
   ```bash
   cd /path/to/netdrive-docker
   docker-compose up -d
   ```

3. **Verify it's running:**
   ```bash
   docker-compose ps
   ```

That's it! The container will now:
- ✅ Start automatically when the system boots
- ✅ Restart automatically if it crashes
- ✅ Remain running until you manually stop it

### Verify Auto-Start After Reboot:

```bash
# Reboot the system
sudo reboot

# After reboot, check if container is running
docker ps
docker-compose ps
```

---

## Method 2: Systemd Service (Advanced)

If you need more control (custom startup order, dependencies, logging), use a systemd service.

### Installation:

1. **Copy the service file:**
   ```bash
   sudo cp doc/netdrive-docker.service /etc/systemd/system/
   ```

2. **Edit the service file to set the correct path:**
   ```bash
   sudo nano /etc/systemd/system/netdrive-docker.service
   ```

   Change `/path/to/netdrive-docker` to your actual path, e.g.:
   ```
   WorkingDirectory=/home/user/netdrive-docker
   ```

3. **Reload systemd and enable the service:**
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable netdrive-docker.service
   sudo systemctl start netdrive-docker.service
   ```

4. **Check status:**
   ```bash
   sudo systemctl status netdrive-docker.service
   ```

### Systemd Service Commands:

```bash
# Start the service
sudo systemctl start netdrive-docker

# Stop the service
sudo systemctl stop netdrive-docker

# Restart the service
sudo systemctl restart netdrive-docker

# Check status
sudo systemctl status netdrive-docker

# View logs
sudo journalctl -u netdrive-docker -f

# Disable auto-start
sudo systemctl disable netdrive-docker
```

---

## Method 3: Cron @reboot (Simple Alternative)

If you don't want to use systemd, use cron:

1. **Edit crontab:**
   ```bash
   crontab -e
   ```

2. **Add this line:**
   ```bash
   @reboot sleep 30 && cd /path/to/netdrive-docker && /usr/bin/docker-compose up -d
   ```

The `sleep 30` ensures Docker daemon is fully started before launching the container.

---

## Troubleshooting

### Container doesn't start on boot

1. **Check if Docker is enabled:**
   ```bash
   sudo systemctl is-enabled docker
   ```
   If not enabled: `sudo systemctl enable docker`

2. **Check Docker service status:**
   ```bash
   sudo systemctl status docker
   ```

3. **Check container restart policy:**
   ```bash
   docker inspect mtcp-netdrive | grep -A 5 RestartPolicy
   ```
   Should show: `"Name": "unless-stopped"`

4. **View container logs:**
   ```bash
   docker-compose logs
   ```

### Docker daemon not starting

```bash
# Check Docker service status
sudo systemctl status docker

# Check Docker logs
sudo journalctl -u docker -n 50

# Restart Docker
sudo systemctl restart docker
```

### Container starts but crashes

```bash
# View container logs
docker-compose logs -f

# Check if port is already in use
sudo netstat -tulpn | grep 2002

# Check disk space
df -h
```

---

## Recommended Setup (Most Reliable)

For the most reliable auto-start configuration:

1. ✅ **Use the built-in Docker restart policy** (already configured)
2. ✅ **Enable Docker daemon on boot** (`systemctl enable docker`)
3. ✅ **Start container once** (`docker-compose up -d`)
4. ✅ **Verify after reboot** (`docker ps`)

This combination provides:
- Automatic start on system boot
- Automatic restart on container crash
- Minimal configuration complexity
- Works across all Linux distributions

---

## Testing Auto-Start

```bash
# Method 1: Soft reboot
sudo reboot

# Method 2: Test without reboot
docker-compose down
sudo systemctl restart docker
# Wait a few seconds for Docker to fully start
docker-compose up -d
docker-compose ps
```

---

## Additional Tips

### Start container on specific network interface ready:
If you need to wait for a specific network interface:

```bash
# In systemd service, add:
After=docker.service network-online.target
Wants=network-online.target
```

### Delay start for other services:
If NetDrive needs to wait for other services (NAS mounts, VPN, etc.):

```bash
# In systemd service, add:
After=docker.service your-other-service.service
Requires=your-other-service.service
```

### Email notification on failure:
```bash
# In systemd service, add:
OnFailure=status-email@%n.service
```

---

## See Also

- Docker documentation: https://docs.docker.com/config/containers/start-containers-automatically/
- Systemd documentation: `man systemd.service`
- Docker Compose restart policies: https://docs.docker.com/compose/compose-file/compose-file-v3/#restart
