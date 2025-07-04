#!/usr/bin/env dart

import 'dart:io';

Future<void> main() async {
  final result = await Process.run('git', [
    'rev-parse',
    '--abbrev-ref',
    'HEAD',
  ]);
  final branch = result.stdout.toString().trim();
  if (branch == 'master' || branch == 'develop') {
    print('❌ Do not push directly to $branch. Please use a pull request!');
    exit(1);
  }
  exit(0);
}
