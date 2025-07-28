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
        stderr.writeln('[Instabug-CLI] Error: File not found: ${options.file}');
        throw Exception('File not found: ${options.file}');
      }

      // validate file is a zip file
      if (!file.path.endsWith('.zip')) {
        stderr.writeln(
            '[Instabug-CLI] Error: File is not a zip file: ${options.file}');
        throw Exception('File is not a zip file: ${options.file}');
      }

      // Validate architecture
      if (!validArchs.contains(options.arch)) {
        stderr.writeln(
            '[Instabug-CLI] Error: Invalid architecture: ${options.arch}. Valid options: ${validArchs.join(', ')}');
        throw Exception(
            'Invalid architecture: ${options.arch}. Valid options: ${validArchs.join(', ')}');
      }

      stdout.writeln('Uploading .so files...');
      stdout.writeln('Architecture: ${options.arch}');
      stdout.writeln('File: ${options.file}');
      stdout.writeln('App Version: ${options.name}');

      const endPoint = 'https://api.instabug.com/api/web/public/so_files';

      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse(endPoint));

      // Add form fields
      request.fields['arch'] = options.arch;
      request.fields['api_key'] = options.apiKey;
      request.fields['application_token'] = options.token;
      request.fields['app_version'] = options.name;

      // Add the zip file
      final fileStream = http.ByteStream(file.openRead());
      final fileLength = await file.length();
      final multipartFile = http.MultipartFile(
        'so_file',
        fileStream,
        fileLength,
        filename: file.path.split('/').last,
      );
      request.files.add(multipartFile);

      final response = await request.send();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final responseBody = await response.stream.bytesToString();
        stderr.writeln('[Instabug-CLI] Error: Failed to upload .so files');
        stderr.writeln('Status Code: ${response.statusCode}');
        stderr.writeln('Response: $responseBody');
        exit(1);
      }

      stdout.writeln(
          'Successfully uploaded .so files for version: ${options.name} with arch ${options.arch}');
      exit(0);
    } catch (e) {
      stderr.writeln('[Instabug-CLI] Error uploading .so files, $e');
      stderr.writeln('[Instabug-CLI] Error Stack Trace: ${StackTrace.current}');
      exit(1);
    }
  }
}
