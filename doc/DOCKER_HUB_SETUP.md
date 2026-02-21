# Docker Hub Setup Guide

This guide walks you through setting up automated Docker Hub builds linked to your GitHub repository.

## Prerequisites

- Docker Hub account (free at https://hub.docker.com)
- GitHub repository created (done via this setup)
- Docker Hub access token

## Step 1: Create Docker Hub Access Token

1. Log in to [Docker Hub](https://hub.docker.com)
2. Click on your username (top right) → **Account Settings**
3. Go to **Security** → **New Access Token**
4. Token description: `GitHub Actions - mTCP NetDrive`
5. Access permissions: **Read, Write, Delete**
6. Click **Generate**
7. **IMPORTANT**: Copy the token immediately (you won't see it again)

## Step 2: Add Secrets to GitHub Repository

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add two secrets:

   **Secret 1:**
   - Name: `DOCKERHUB_USERNAME`
   - Value: Your Docker Hub username

   **Secret 2:**
   - Name: `DOCKERHUB_TOKEN`
   - Value: The access token you created in Step 1

## Step 3: Create Docker Hub Repository (Optional)

You can either:
- Let GitHub Actions create it automatically on first push, OR
- Create it manually:

### Manual Creation:
1. Go to [Docker Hub](https://hub.docker.com)
2. Click **Repositories** → **Create Repository**
3. Repository name: `mtcp-netdrive`
4. Description: `Minimal Docker container for mTCP NetDrive server`
5. Visibility: **Public**
6. Click **Create**

## Step 4: Verify GitHub Actions

The workflows are already configured. When you push to GitHub:

1. **On every push to main**:
   - Builds multi-architecture images (amd64, arm64)
   - Pushes to Docker Hub with `latest` tag

2. **On version tags** (e.g., `v1.0.0`):
   - Creates versioned releases
   - Tags: `1.0.0`, `1.0`, `1`, `latest`

3. **On pull requests**:
   - Tests the build (doesn't push to Docker Hub)

## Step 5: Test the Setup

After pushing to GitHub, check:

1. **GitHub Actions**: Repository → **Actions** tab
   - Verify the workflow runs successfully

2. **Docker Hub**: hub.docker.com → Your repository
   - Verify the image was pushed
   - Check tags are correct

## Step 6: Create Your First Release

```bash
# Tag a release
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0
```

This will:
- Trigger the build workflow
- Create versioned Docker images
- Make them available on Docker Hub

## Usage After Setup

Users can now pull your image directly:

```bash
docker pull YOUR_USERNAME/mtcp-netdrive:latest
```

Or use in docker-compose.yml:

```yaml
services:
  netdrive:
    image: YOUR_USERNAME/mtcp-netdrive:latest
    # ... rest of config
```

## Updating the README on Docker Hub

1. Go to your Docker Hub repository
2. Click **Edit** on the repository page
3. You can either:
   - Link to GitHub README (recommended)
   - Or copy the README content manually

To link to GitHub:
- Check **FROM GITHUB** option
- Select your repository
- Choose `README.md`

## Troubleshooting

### Build fails on GitHub Actions
- Check the Actions logs for errors
- Verify secrets are set correctly
- Ensure Docker Hub credentials are valid

### Image not appearing on Docker Hub
- Verify `DOCKERHUB_USERNAME` matches exactly
- Check that the token has write permissions
- Review GitHub Actions logs

### Multi-architecture builds failing
- This is normal for some runners
- The merge job combines available architectures
- At minimum, amd64 should always work

## Maintenance

### Updating Docker Hub Token
If you need to rotate your token:
1. Create a new token on Docker Hub
2. Update the `DOCKERHUB_TOKEN` secret in GitHub
3. Old token will stop working immediately

### Monitoring Builds
- Enable GitHub Actions email notifications
- Watch the Docker Hub repository
- Monitor image pull statistics

## Additional Resources

- [Docker Hub Documentation](https://docs.docker.com/docker-hub/)
- [GitHub Actions Docker Build](https://github.com/docker/build-push-action)
- [Multi-platform Builds](https://docs.docker.com/build/building/multi-platform/)
