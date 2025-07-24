part of '../instabug.dart';

/**
 * This script uploads .so files to the specified endpoint used in NDK crash reporting.
 * Usage: dart run instabug_flutter:instabug upload-so-files --arch <arch> --file <path> --api_key <key> --token <token> --name <name>
 */

class UploadSoFilesOptions {
  final String arch;
  final String file;
  final String apiKey;
  final String token;
  final String name;

  UploadSoFilesOptions({
    required this.arch,
    required this.file,
    required this.apiKey,
    required this.token,
    required this.name,
  });
}

// ignore: avoid_classes_with_only_static_members
class UploadSoFilesCommand {
  static const List<String> validArchs = [
    'x86',
    'x86_64',
    'arm64-v8a',
    'armeabi-v7a',
  ];

  static ArgParser createParser() {
    final parser = ArgParser()
      ..addFlag('help', abbr: 'h', help: 'Show this help message')
      ..addOption(
        'arch',
        abbr: 'a',
        help: 'Architecture',
        allowed: validArchs,
        mandatory: true,
      )
      ..addOption(
        'file',
        abbr: 'f',
        help: 'The path of the symbol files in Zip format',
        mandatory: true,
      )
      ..addOption(
        'api_key',
        help: 'Your App key',
        mandatory: true,
      )
      ..addOption(
        'token',
        abbr: 't',
        help: 'Your App Token',
        mandatory: true,
      )
      ..addOption(
        'name',
        abbr: 'n',
        help: 'The app version name',
        mandatory: true,
      );

    return parser;
  }

  static void execute(ArgResults results) {
    final options = UploadSoFilesOptions(
      arch: results['arch'] as String,
      file: results['file'] as String,
      apiKey: results['api_key'] as String,
      token: results['token'] as String,
      name: results['name'] as String,
    );

    uploadSoFiles(options);
  }

  static Future<void> uploadSoFiles(UploadSoFilesOptions options) async {
    try {
      // Validate file exists
      final file = File(options.file);
      if (!await file.exists()) {
        print('[Instabug-CLI] Error: File not found: ${options.file}');
        throw Exception('File not found: ${options.file}');
      }

      // validate file is a zip file
      if (!file.path.endsWith('.zip')) {
        print('[Instabug-CLI] Error: File is not a zip file: ${options.file}');
        throw Exception('File is not a zip file: ${options.file}');
      }

      // Validate architecture
      if (!validArchs.contains(options.arch)) {
        print('[Instabug-CLI] Error: Invalid architecture: ${options.arch}. Valid options: ${validArchs.join(', ')}');
        throw Exception(
            'Invalid architecture: ${options.arch}. Valid options: ${validArchs.join(', ')}');
      }

      print('Uploading .so files...');
      print('Architecture: ${options.arch}');
      print('File: ${options.file}');
      print('App Version: ${options.name}');

      // TODO: Implement the actual upload logic here
      // This would typically involve:
      // 1. Reading the zip file
      // 2. Making an HTTP request to the upload endpoint
      // 3. Handling the response

      // Make an HTTP request to the upload endpoint
      final body = {
        'arch': options.arch,
        'api_key': options.apiKey,
        'application_token': options.token,
        'so_file': options.file,
        'app_version': options.name,
      };

      const endPoint = 'https://api.instabug.com/api/web/public/so_files';

      final response = await makeHttpPostRequest(
        url: endPoint,
        body: body,
      );

      print('Successfully uploaded .so files for version: ${options.name} with arch ${options.arch}');
    } catch (e) {
      print('[Instabug-CLI] Error: Error uploading .so files: $e');
      exit(1);
    }
  }
}
