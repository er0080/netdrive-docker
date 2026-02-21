# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository provides a Docker container for the mTCP NetDrive server, which allows DOS machines to mount remote disk images over UDP. The container wraps the pre-compiled NetDrive server binary (written in Go) from https://www.brutman.com/mTCP/ with environment variable configuration and multi-architecture support.

## Architecture

### Binary Distribution Model
Unlike typical Docker projects that build from source, this container **downloads pre-compiled binaries** from brutman.com during the Docker build. The binary is packaged in a zip file with this structure:
```
mTCP_NetDrive_server-bin_2025-01-10/
  ├── netdrive_linux_amd64
  ├── netdrive_linux_arm64
  ├── netdrive_linux_arm_5
  ├── netdrive_darwin_arm64
  └── netdrive_windows_amd64.exe
```

The Dockerfile uses Docker's `TARGETARCH` build argument (automatically set to `amd64` or `arm64`) to select the correct binary for each platform during multi-architecture builds.

### Multi-Architecture Builds
GitHub Actions builds two separate images (linux/amd64, linux/arm64) in parallel, then merges them into a single multi-platform manifest. This is handled by the "build-push-merge" pattern:
1. **Build job**: Builds each architecture separately, pushes by digest
2. **Merge job**: Downloads all digests, creates manifest list combining both architectures
3. **Test job**: Validates the merged image

**Important**: Artifact names in GitHub Actions cannot contain forward slashes. The workflow sanitizes platform names (e.g., `linux/amd64` → `linux-amd64`) before uploading artifacts.

### Configuration Flow
Environment variables → `entrypoint.sh` → NetDrive CLI flags:
- `NETDRIVE_PORT` → `-port`
- `NETDRIVE_VERBOSE` → `-verbose`
- `NETDRIVE_BIND_ADDRESS` → `-addr`

The entrypoint script builds command-line arguments dynamically and executes the NetDrive binary with `exec` (replacing the shell process for proper signal handling).

## Common Commands

### Local Development
```bash
# Build the container locally
docker build -t mtcp-netdrive .

# Build for specific architecture (requires buildx)
docker buildx build --platform linux/amd64 -t mtcp-netdrive:amd64 .
docker buildx build --platform linux/arm64 -t mtcp-netdrive:arm64 .

# Run with docker-compose
docker-compose up -d

# View logs
docker-compose logs -f

# Stop and remove
docker-compose down

# Test container manually
docker run --rm -it mtcp-netdrive /bin/sh
```

### Testing
```bash
# Test the entrypoint script
docker run --rm mtcp-netdrive /usr/local/bin/netdrive-server -h

# Test with verbose mode
docker run --rm -e NETDRIVE_VERBOSE=true mtcp-netdrive

# Test UDP connectivity (from another machine)
nc -u <server-ip> 2002
```

### Releasing
```bash
# Create a new release (triggers automated build and publish)
git tag -a v1.1.0 -m "Release description"
git push origin v1.1.0

# Update an existing tag (use with caution)
git tag -d v1.0.0
git push origin :refs/tags/v1.0.0
git tag -a v1.0.0 -m "New description"
git push origin v1.0.0
```

## Critical Implementation Details

### Dockerfile Binary Path
The binary path in the Dockerfile must match the zip structure exactly:
```dockerfile
mv mTCP_NetDrive_server-bin_${NETDRIVE_VERSION}/netdrive_linux_${TARGETARCH} /usr/local/bin/netdrive-server
```
If the upstream zip structure changes, this line must be updated.

### GitHub Actions Secrets
Required repository secrets for automated builds:
- `DOCKERHUB_USERNAME` - Docker Hub username (er0080)
- `DOCKERHUB_TOKEN` - Docker Hub access token with read/write/delete permissions

### NetDrive Server Binary Arguments
The mTCP NetDrive server accepts these flags (as of 2025-01-10):
- `-port <num>` - UDP port to listen on
- `-addr <ip>` - IP address to bind to
- `-verbose` - Enable verbose logging

The server serves disk images from its current working directory, which is why `entrypoint.sh` does `cd "${NETDRIVE_IMAGES_DIR}"` before executing the binary.

## File Structure

### Key Files
- `Dockerfile` - Multi-arch Alpine Linux container, downloads NetDrive binary
- `entrypoint.sh` - Converts environment variables to CLI flags, starts server
- `docker-compose.yml` - Local development/testing configuration
- `.github/workflows/docker-build.yml` - Multi-arch build, merge, and publish pipeline
- `.github/workflows/docker-test.yml` - PR validation (build-only, no push)

### Documentation Files
- `README.md` - User-facing documentation
- `CONTRIBUTING.md` - Contributor guidelines
- `DOCKER_HUB_SETUP.md` - Instructions for Docker Hub integration
- `NEXT_STEPS.md` - Post-setup guide
- `SUCCESS_SUMMARY.md` - Project completion summary

## Modifying the Container

### Updating NetDrive Version
1. Check https://www.brutman.com/mTCP/ for new releases
2. Update `NETDRIVE_VERSION` ARG in Dockerfile
3. Verify zip structure hasn't changed by downloading and inspecting
4. Test build locally before pushing

### Adding Environment Variables
1. Add default value in Dockerfile `ENV` directive
2. Add argument parsing in `entrypoint.sh`
3. Update README.md environment variables table
4. Update docker-compose.yml example

### Modifying GitHub Actions
- The workflow uses the "Prepare platform name" step to sanitize platform strings
- Artifact names must not contain `/` characters
- The merge job requires ALL build jobs to succeed before running
- Tags follow semantic versioning: `{{version}}`, `{{major}}.{{minor}}`, `{{major}}`, `latest`

## Known Limitations

- NetDrive protocol uses UDP (not TCP), which some firewalls may block
- The container downloads ~5.7MB zip during build (no caching of upstream binary)
- Server runs as root inside container (Alpine default)
- No health check configured (NetDrive server doesn't expose health endpoint)
- Binary is proprietary (GPLv3) - cannot modify server behavior without upstream changes
