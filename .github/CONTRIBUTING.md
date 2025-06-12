# Contributing to LLM Dart

Thank you for your interest in contributing! 🎉

## Quick Start

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/llm_dart.git`
3. Create a branch: `git checkout -b feature/your-feature-name`
4. Make your changes
5. **Run code quality checks**:
   - `dart analyze` - Check for code issues
   - `dart test` - Run all tests
6. Submit a pull request

## How to Contribute

- 🐛 **Bug Reports**: Use the Bug Report template
- ✨ **Feature Requests**: Use the Feature Request template
- 🤖 **New Providers**: Use the Provider Request template
- 📚 **Documentation**: Use the Documentation template

## Development Guidelines

- Follow standard Dart conventions
- **Run `dart analyze` before marking PR as ready** - Fix all warnings and errors
- **Run `dart test` before marking PR as ready** - Ensure all tests pass
- Add tests for new features
- Update documentation when needed
- Test with real API keys when possible

## Code Quality Requirements

Before marking your pull request as **ready for review**, you **must** run:

```bash
# Check for code issues and style violations
dart analyze

# Run all tests to ensure nothing is broken
dart test
```

All analysis issues must be resolved and all tests must pass before your PR can be merged.

💡 **Tip**: You can create a Draft PR while still working on your changes, and only run these checks when you're ready for review.

## Commit Messages

Use conventional commits:

- `feat:` new features
- `fix:` bug fixes
- `docs:` documentation changes

## Getting Help

- 💬 [GitHub Discussions](https://github.com/Latias94/llm_dart/discussions)
- 🐛 [Issues](https://github.com/Latias94/llm_dart/issues)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
