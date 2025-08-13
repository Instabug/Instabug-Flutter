# Instabug Flutter CLI Tool

A command-line tool for managing Instabug Flutter SDK integration and utilities.

## Available Commands

### `init` - Initialize Instabug Flutter SDK

Automatically sets up the Instabug Flutter SDK in your project with basic instrumentation.

#### Usage

```bash
dart run instabug_flutter:instabug init --token YOUR_APP_TOKEN [options]
```

#### Options

- `--token, -t` (required): Your Instabug app token
- `--project-path, -p`: Path to your Flutter project (defaults to current directory)
- `--invocation-events, -i`: Comma-separated list of invocation events (default: shake)
  - Available events: `shake`, `floating_button`, `screenshot`, `two_finger_swipe_left`, `none`
- `--setup-permissions`: Setup required permissions for iOS and Android (default: true)
- `--update-pubspec`: Add instabug_flutter dependency to pubspec.yaml (default: true)
- `--help, -h`: Show help message

#### What it does

1. **Updates pubspec.yaml**: Automatically fetches and adds the latest `instabug_flutter` dependency from pub.dev
2. **Updates main.dart**: Adds the Instabug import and initialization code in the `main()` function before `runApp()`
3. **Sets up permissions**: 
   - **iOS**: Adds required usage descriptions to Info.plist for microphone and photo library access
   - **Android**: Permissions are automatically handled by the plugin
4. **Configures invocation events**: Sets up how users can invoke Instabug (shake, floating button, etc.)
5. **Latest version detection**: Automatically fetches the most recent version from pub.dev with fallback support

#### Examples

**Basic initialization with shake gesture:**
```bash
dart run instabug_flutter:instabug init --token YOUR_APP_TOKEN
```

**Initialize with multiple invocation events:**
```bash
dart run instabug_flutter:instabug init --token YOUR_APP_TOKEN --invocation-events shake,floating_button
```

**Initialize without automatic permission setup:**
```bash
dart run instabug_flutter:instabug init --token YOUR_APP_TOKEN --no-setup-permissions
```

**Initialize for a specific project path:**
```bash
dart run instabug_flutter:instabug init --token YOUR_APP_TOKEN --project-path /path/to/my/flutter/project
```

#### After running the command

1. Run `flutter packages get` to install the new dependency
2. If using a placeholder token, replace `YOUR_APP_TOKEN` in your main.dart with your actual Instabug app token
3. Test the integration by using your configured invocation event (e.g., shake the device)

#### Finding your App Token

You can find your app token by:
1. Going to your [Instabug dashboard](https://dashboard.instabug.com)
2. Selecting **SDK Integration** in the **Settings** menu
3. Your app token will be displayed there

### `upload-so-files` - Upload Symbol Files

Uploads .so files for NDK crash reporting (existing command).

## Getting Help

For help on any command:
```bash
dart run instabug_flutter:instabug <command> --help
```

For general help:
```bash
dart run instabug_flutter:instabug --help
```

## Requirements

- Flutter SDK
- Dart SDK
- Valid Instabug app token

## Documentation

For more detailed information about Instabug Flutter integration, visit the [official documentation](https://docs.instabug.com/docs/flutter-integration).