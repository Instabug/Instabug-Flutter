#!/usr/bin/env dart

import 'package:args/args.dart';

void main(List<String> args) {
  final parser = ArgParser()..addFlag('help', abbr: 'h');
  final result = parser.parse(args);
  if (result['help'] as bool) {
    print('Usage: instabug [options]');
    print(parser.usage);
    return;
  }
  // …call into your SDK’s API…
}