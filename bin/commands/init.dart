part of '../instabug.dart';

class InitOptions {
  final String token;
  final String? projectPath;
  final List<String> invocationEvents;
  final bool setupPermissions;
  final bool updatePubspec;

  InitOptions({
    required this.token,
    this.projectPath,
    required this.invocationEvents,
    required this.setupPermissions,
    required this.updatePubspec,
  });
}

// ignore: avoid_classes_with_only_static_members
/// Initializes Instabug Flutter SDK in your project.
/// Usage: dart run instabug_flutter:instabug init --token <APP_TOKEN> [options]
class InitCommand {
  static const List<String> validInvocationEvents = [
    'shake',
    'floating_button',
    'screenshot',
    'two_finger_swipe_left',
    'none',
  ];

  static ArgParser createParser() {
    final parser = ArgParser()
      ..addFlag('help', abbr: 'h', help: 'Show this help message')
      ..addOption(
        'token',
        abbr: 't',
        help: 'Your Instabug app token (required)',
        mandatory: true,
      )
      ..addOption(
        'project-path',
        abbr: 'p',
        help: 'Path to your Flutter project (defaults to current directory)',
      )
      ..addMultiOption(
        'invocation-events',
        abbr: 'i',
        help: 'Invocation events (comma-separated)',
        allowed: validInvocationEvents,
        defaultsTo: ['shake'],
      )
      ..addFlag(
        'setup-permissions',
        help: 'Setup required permissions for iOS and Android',
        defaultsTo: true,
      )
      ..addFlag(
        'update-pubspec',
        help: 'Add instabug_flutter dependency to pubspec.yaml',
        defaultsTo: true,
      );

    return parser;
  }

  static Future<void> execute(ArgResults args) async {
    final options = InitOptions(
      token: args['token'] as String,
      projectPath: args['project-path'] as String?,
      invocationEvents: args['invocation-events'] as List<String>,
      setupPermissions: args['setup-permissions'] as bool,
      updatePubspec: args['update-pubspec'] as bool,
    );

    stdout.writeln('🚀 Initializing Instabug Flutter SDK...');

    try {
      await _initializeInstabug(options);
      stdout.writeln('✅ Instabug Flutter SDK initialized successfully!');
      stdout.writeln();
      stdout.writeln('Next steps:');
      stdout.writeln('1. Run "flutter packages get" to install dependencies');
      stdout.writeln(
        '2. Replace "APP_TOKEN" with your actual app token in main.dart',
      );
      stdout.writeln(
        '3. Test the integration by shaking your device or using your configured invocation event',
      );
    } catch (e) {
      stderr.writeln('❌ Failed to initialize Instabug: $e');
      exit(1);
    }
  }

  static Future<void> _initializeInstabug(InitOptions options) async {
    final projectPath = options.projectPath ?? Directory.current.path;
    final projectDir = Directory(projectPath);

    // Verify this is a Flutter project
    final pubspecFile = File('${projectDir.path}/pubspec.yaml');
    if (!await pubspecFile.exists()) {
      throw Exception(
        "No pubspec.yaml found. Make sure you're in a Flutter project directory.",
      );
    }

    // Update pubspec.yaml if requested
    if (options.updatePubspec) {
      await _updatePubspec(pubspecFile);
    }

    // Update main.dart
    await _updateMainDart(projectDir, options);

    // Setup permissions if requested
    if (options.setupPermissions) {
      await _setupPermissions(projectDir);
    }
  }

  static Future<void> _updatePubspec(File pubspecFile) async {
    stdout.writeln('📝 Updating pubspec.yaml...');

    final content = await pubspecFile.readAsString();

    // Check if instabug_flutter is already added
    if (content.contains('instabug_flutter:')) {
      stdout.writeln('ℹ️  instabug_flutter already exists in pubspec.yaml');
      return;
    }

    // Find dependencies section and add instabug_flutter
    final lines = content.split('\n');
    var foundDependencies = false;
    var insertIndex = -1;

    for (var i = 0; i < lines.length; i++) {
      if (lines[i].trim() == 'dependencies:') {
        foundDependencies = true;
        continue;
      }

      if (foundDependencies && lines[i].trim().startsWith('flutter:')) {
        // Look for the end of the flutter dependency block
        for (var j = i + 1; j < lines.length; j++) {
          // If we find a line that doesn't start with spaces (new top-level key)
          // or find another dependency, insert before it
          if (lines[j].trim().isEmpty) {
            continue; // Skip empty lines
          }
          if (!lines[j].startsWith('  ') ||
              (lines[j].trim().contains(':') &&
                  !lines[j].trim().startsWith('sdk:'))) {
            insertIndex = j;
            break;
          }
        }
        break;
      }
    }

    if (insertIndex == -1) {
      throw Exception(
        'Could not find suitable location to add instabug_flutter dependency',
      );
    }

    // Get the latest version and insert the dependency
    final latestVersion = await _getLatestInstabugVersion();
    lines.insert(insertIndex, '  instabug_flutter: $latestVersion');

    await pubspecFile.writeAsString(lines.join('\n'));
    stdout.writeln('✅ Added instabug_flutter dependency to pubspec.yaml');
  }

  static Future<void> _updateMainDart(
    Directory projectDir,
    InitOptions options,
  ) async {
    stdout.writeln('📝 Updating main.dart...');

    final mainDartFile = File('${projectDir.path}/lib/main.dart');
    if (!await mainDartFile.exists()) {
      throw Exception('main.dart not found in lib directory');
    }

    final content = await mainDartFile.readAsString();

    // Check if Instabug is already imported
    if (content.contains('instabug_flutter/instabug_flutter.dart')) {
      stdout.writeln('ℹ️  Instabug import already exists in main.dart');
      return;
    }

    final lines = content.split('\n');

    // Find import section and add Instabug import
    var importInsertIndex = 0;
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].startsWith("import 'package:flutter/")) {
        importInsertIndex = i + 1;
      }
    }

    lines.insert(
      importInsertIndex,
      "import 'package:instabug_flutter/instabug_flutter.dart';",
    );

    // Find main function and add Instabug initialization before runApp()
    final invocationEventsCode =
        _generateInvocationEventsCode(options.invocationEvents);
    final initCode = '''
  // Initialize Instabug
 
  Instabug.init(
    token: '${options.token}',
    invocationEvents: $invocationEventsCode,
  );

''';

    // Look for main function and runApp call
    var addedInit = false;
    var inMainFunction = false;

    for (var i = 0; i < lines.length; i++) {
      // Find the main function
      if (lines[i].trim().startsWith('void main(') ||
          lines[i].trim() == 'void main() {' ||
          lines[i].trim().startsWith('main(')) {
        inMainFunction = true;
        continue;
      }

      // If we're in main function, look for runApp call
      if (inMainFunction && lines[i].trim().startsWith('runApp(')) {
        // Insert Instabug initialization before runApp
        lines.insert(i, initCode);
        addedInit = true;
        break;
      }

      // If we encounter a closing brace at the beginning of a line while in main, we've left main
      if (inMainFunction && lines[i].trim() == '}') {
        inMainFunction = false;
      }
    }

    if (!addedInit) {
      // If no main/runApp found, add a comment for manual setup
      lines.add('');
      lines.add(
        '// TODO: Add Instabug initialization to your main() function before runApp():',
      );
      lines.add('// ${initCode.replaceAll('\n', '\n// ')}');
    }

    await mainDartFile.writeAsString(lines.join('\n'));
    stdout.writeln('✅ Updated main.dart with Instabug initialization');

    if (!addedInit) {
      stdout.writeln('⚠️  Could not automatically add initialization code.');
      stdout.writeln(
        '   Please manually add the initialization code to your main() function before runApp().',
      );
    }
  }

  static String _generateInvocationEventsCode(List<String> events) {
    final dartEvents = events.map((event) {
      switch (event) {
        case 'shake':
          return 'InvocationEvent.shake';
        case 'floating_button':
          return 'InvocationEvent.floatingButton';
        case 'screenshot':
          return 'InvocationEvent.screenshot';
        case 'two_finger_swipe_left':
          return 'InvocationEvent.twoFingersSwipeLeft';
        case 'none':
          return 'InvocationEvent.none';
        default:
          return 'InvocationEvent.shake';
      }
    }).toList();

    return '[${dartEvents.join(', ')}]';
  }

  static Future<void> _setupPermissions(Directory projectDir) async {
    stdout.writeln('🔐 Setting up permissions...');

    // Setup iOS permissions
    await _setupIOSPermissions(projectDir);

    // Setup Android permissions
    await _setupAndroidPermissions(projectDir);

    stdout.writeln('✅ Permissions setup completed');
  }

  static Future<void> _setupIOSPermissions(Directory projectDir) async {
    final infoPlistPath = '${projectDir.path}/ios/Runner/Info.plist';
    final infoPlistFile = File(infoPlistPath);

    if (!await infoPlistFile.exists()) {
      stdout.writeln(
        '⚠️  iOS Info.plist not found, skipping iOS permission setup',
      );
      return;
    }

    final content = await infoPlistFile.readAsString();

    const microphonePermission =
        '<key>NSMicrophoneUsageDescription</key>\n\t<string>\$(PRODUCT_NAME) needs access to your microphone so you can attach voice notes.</string>';
    const photoLibraryPermission =
        '<key>NSPhotoLibraryUsageDescription</key>\n\t<string>\$(PRODUCT_NAME) needs access to your photo library so you can attach images.</string>';

    if (!content.contains('NSMicrophoneUsageDescription') ||
        !content.contains('NSPhotoLibraryUsageDescription')) {
      // Find the closing </dict> tag before </plist>
      final lines = content.split('\n');
      var insertIndex = -1;

      for (var i = lines.length - 1; i >= 0; i--) {
        if (lines[i].trim() == '</dict>' && i < lines.length - 2) {
          insertIndex = i;
          break;
        }
      }

      if (insertIndex != -1) {
        if (!content.contains('NSMicrophoneUsageDescription')) {
          lines.insert(insertIndex, '\t$microphonePermission');
          insertIndex++;
        }
        if (!content.contains('NSPhotoLibraryUsageDescription')) {
          lines.insert(insertIndex, '\t$photoLibraryPermission');
        }

        await infoPlistFile.writeAsString(lines.join('\n'));
        stdout.writeln('✅ Added iOS permissions to Info.plist');
      }
    } else {
      stdout.writeln('ℹ️  iOS permissions already exist in Info.plist');
    }
  }

  static Future<void> _setupAndroidPermissions(Directory projectDir) async {
    final manifestPath =
        '${projectDir.path}/android/app/src/main/AndroidManifest.xml';
    final manifestFile = File(manifestPath);

    if (!await manifestFile.exists()) {
      stdout.writeln(
        '⚠️  Android AndroidManifest.xml not found, skipping Android permission setup',
      );
      return;
    }

    stdout.writeln(
      'ℹ️  Android permissions are automatically added by the Instabug Flutter plugin',
    );
    stdout.writeln('   No manual setup required for Android permissions');
  }

  static Future<String> _getLatestInstabugVersion() async {
    try {
      stdout.writeln('🔍 Fetching latest instabug_flutter version...');

      final response = await http.get(
        Uri.parse('https://pub.dev/api/packages/instabug_flutter'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final latest = data['latest'] as Map<String, dynamic>;
        final version = latest['version'] as String;

        stdout.writeln('✅ Found latest version: $version');
        return '^$version';
      } else {
        stdout.writeln(
          '⚠️  Failed to fetch latest version from pub.dev, using fallback',
        );
        return '^13.0.0'; // Fallback version
      }
    } catch (e) {
      stdout.writeln('⚠️  Error fetching latest version: $e');
      stdout.writeln('   Using fallback version');
      return '^13.0.0'; // Fallback version
    }
  }
}
