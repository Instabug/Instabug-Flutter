#!/usr/bin/env dart

import 'dart:developer';
import 'dart:io';

import 'package:args/args.dart';

import 'commands/upload_so_files.dart';

// Command registry for easy management
class CommandRegistry {
  static final Map<String, CommandHandler> _commands = {
    'upload-so-files': CommandHandler(
      parser: UploadSoFilesCommand.createParser(),
      execute: UploadSoFilesCommand.execute,
    ),
  };

  static Map<String, CommandHandler> get commands => _commands;
  static List<String> get commandNames => _commands.keys.toList();
}

class CommandHandler {
  final ArgParser parser;
  final Function(ArgResults) execute;

  CommandHandler({required this.parser, required this.execute});
}

void main(List<String> args) async {
  final parser = ArgParser()..addFlag('help', abbr: 'h');

  // Add all commands to the parser
  for (final entry in CommandRegistry.commands.entries) {
    parser.addCommand(entry.key, entry.value.parser);
  }

  print('--------------------------------');

  try {
    final result = parser.parse(args);

    final command = result.command;
    if (command != null) {
      // Check if help is requested for the subcommand (before mandatory validation)
      if (command['help'] == true) {
        final commandHandler = CommandRegistry.commands[command.name];
        if (commandHandler != null) {
          print('Usage: instabug ${command.name} [options]');
          print(commandHandler.parser.usage);
        }
        return;
      }

      final commandHandler = CommandRegistry.commands[command.name];
      // Extra safety check just in case
      if (commandHandler != null) {
        commandHandler.execute(command);
      } else {
        print('Unknown command: ${command.name}');
        print('Available commands: ${CommandRegistry.commandNames.join(', ')}');
        exit(1);
      }
    } else {
      print('No applicable command found');
      print('Usage: instabug [options] <command>');
      print('Available commands: ${CommandRegistry.commandNames.join(', ')}');
      print('\nFor help on a specific command:');
      print('  instabug <command> --help\n');
      print(parser.usage);
    }
  } catch (e) {
    print('[Instabug-CLI] Error: $e');
    print(parser.usage);
    exit(1);
  }
}
