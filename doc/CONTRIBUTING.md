# Contributing to mTCP NetDrive Docker

Thank you for your interest in contributing! This project provides a Docker container for the mTCP NetDrive server.

## How to Contribute

### Reporting Issues

- Check existing issues before creating a new one
- Provide detailed information:
  - Docker version
  - Host OS
  - Steps to reproduce
  - Expected vs actual behavior
  - Relevant logs

### Suggesting Enhancements

- Open an issue with the `enhancement` label
- Describe the use case
- Explain why the enhancement would be useful

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test your changes:
   ```bash
   docker-compose build
   docker-compose up
   ```
5. Commit with clear messages (`git commit -m 'Add amazing feature'`)
6. Push to your branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Coding Standards

- Keep the Docker image minimal
- Document environment variables in README.md
- Test on multiple architectures when possible
- Follow shell scripting best practices
- Keep the entrypoint script simple and maintainable

### Testing

Before submitting a PR, ensure:
- [ ] Docker image builds successfully
- [ ] Container starts without errors
- [ ] Environment variables work as expected
- [ ] Documentation is updated
- [ ] No unnecessary files are committed

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/netdrive-docker.git
cd netdrive-docker

# Build and test
docker-compose build
docker-compose up -d
docker-compose logs -f

# Make changes and rebuild
docker-compose down
# ... make changes ...
docker-compose build --no-cache
docker-compose up
```

## Questions?

Feel free to open an issue for any questions or clarifications.

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on what's best for the community
- Show empathy towards others

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
