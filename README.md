# Instabug Flutter SDK

Welcome to the Instabug Flutter SDK monorepo! This repository contains the official Flutter packages for integrating [Instabug](https://instabug.com/) - a comprehensive bug reporting, crash monitoring, and user feedback platform for mobile apps.

## What's Inside

This monorepo houses four interconnected packages that work together to provide seamless Instabug integration for Flutter applications:

### Core Package
- **[instabug_flutter](packages/instabug_flutter/)** - The main SDK with bug reporting, crash monitoring, APM, surveys, and more

### Network Logging Add-ons  
- **[instabug_dio_interceptor](packages/instabug_dio_interceptor/)** - Network request logging for [Dio](https://pub.dev/packages/dio) HTTP client
- **[instabug_http_client](packages/instabug_http_client/)** - Network request logging for the standard [http](https://pub.dev/packages/http) package

### Navigation Integration
- **[instabug_flutter_modular](packages/instabug_flutter_modular/)** - Screen loading tracking for [Flutter Modular](https://pub.dev/packages/flutter_modular) routing

Each package has its own README with detailed usage instructions and examples.

## Development Setup

Contributing to this project? Here's how to get your development environment ready.

### Prerequisites

- **Flutter SDK** (3.0.0 or higher recommended)
- **[FVM](https://fvm.app/)** for Flutter version management (optional but recommended)
- **Git** for version control

### Quick Start for Developers

1. **Clone the repository**
   ```bash
   git clone https://github.com/Instabug/Instabug-Flutter.git
   cd Instabug-Flutter
   ```

2. **Set up Flutter version** (if using FVM)
   ```bash
   fvm use
   fvm flutter --version
   ```

3. **Navigate to the package you want to work on**
   ```bash
   cd packages/instabug_flutter  # or any other package
   ```

4. **Install dependencies**
   ```bash
   fvm flutter pub get  # or just 'flutter pub get' if not using FVM
   ```

5. **Generate required code** (important!)
   ```bash
   # Generate Pigeon API bindings (in instabug_flutter package)
   ./scripts/pigeon.sh
   
   # Generate mock files for testing (in any package with tests)
   fvm dart run build_runner build
   ```

### Why the Code Generation Step?

This project uses [Pigeon](https://pub.dev/packages/pigeon) to generate type-safe platform channel code and [build_runner](https://pub.dev/packages/build_runner) with [Mockito](https://pub.dev/packages/mockito) for test mocks. If you see import errors in your IDE after cloning, running the generation commands above will resolve them.

**Note**: Generated files are git-ignored (as they should be), so you'll need to run these commands whenever you:
- Clone the repo fresh
- Switch branches that modify Pigeon definitions  
- Add new test files that need mocks

## Repository Structure

```
packages/
├── instabug_flutter/          # Main SDK package
│   ├── lib/                   # Dart source code
│   ├── android/               # Android platform code  
│   ├── ios/                   # iOS platform code
│   ├── pigeons/               # Pigeon API definitions
│   ├── scripts/               # Development scripts
│   └── test/                  # Unit tests
├── instabug_dio_interceptor/  # Dio HTTP integration  
├── instabug_http_client/      # Standard HTTP integration
└── instabug_flutter_modular/  # Flutter Modular integration
```

Each package is independently published to pub.dev but they're developed together in this monorepo for easier maintenance and testing.

## Working with Individual Packages

### Running Tests
```bash
cd packages/[package-name]
fvm flutter test
```

### Running Example Apps
Most packages include example apps to test functionality:
```bash
cd packages/[package-name]/example
fvm flutter run
```

### Adding Dependencies
Each package manages its own `pubspec.yaml`. Make sure to:
1. Add dependencies to the correct package
2. Run `flutter pub get` in that package directory
3. Update version constraints appropriately

## Common Issues & Solutions

### "Target of URI doesn't exist" Errors
**Problem**: IDE shows import errors for generated files  
**Solution**: Run the code generation steps above

### Permission Denied on Shell Scripts
**Problem**: `./scripts/pigeon.sh: Permission denied`  
**Solution**: Make the script executable: `chmod +x scripts/pigeon.sh`

### Missing Flutter SDK Path
**Problem**: IDE can't find Flutter SDK when using FVM  
**Solution**: Point your IDE to the FVM Flutter path (usually `~/.fvm/versions/[version]`)

### Build Failures After Switching Branches  
**Problem**: Cached build artifacts cause issues  
**Solution**: Clean and regenerate:
```bash
fvm flutter clean
fvm flutter pub get
./scripts/pigeon.sh  # if in instabug_flutter package
fvm dart run build_runner build
```

## Contributing

We welcome contributions! Here's how to get started:

1. **Fork the repository** and create a feature branch
2. **Set up your development environment** (follow steps above)
3. **Make your changes** with appropriate tests
4. **Run the test suite** to ensure nothing breaks
5. **Submit a pull request** with a clear description

### Before Submitting PRs
- Run `flutter analyze` to catch static analysis issues
- Run `flutter test` to ensure all tests pass  
- Update documentation if you're changing public APIs
- Follow the existing code style and conventions

## Getting Help

- ** Documentation**: Check individual package READMEs for usage examples
- ** Bug Reports**: [Create an issue](https://github.com/Instabug/Instabug-Flutter/issues) with reproduction steps
- ** Questions**: Use [GitHub Discussions](https://github.com/Instabug/Instabug-Flutter/discussions) for general questions
