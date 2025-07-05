import 'dart:io';

import 'package:test/test.dart';

Set<String> extractTodoFiles(List<String> todos) {
  final todoFiles = <String>{};
  for (final line in todos) {
    final match = RegExp(r'^(.*\.dart):').firstMatch(line);
    if (match != null) {
      final file = match.group(1);
      if (file != null && file.isNotEmpty) {
        todoFiles.add(file);
      }
    }
  }
  return todoFiles;
}

void main() {
  group('dart_todo_check', () {
    test('TODOs found in multiple files', () async {
      final fakeOutput =
          '''lib/a.dart:1:// TODO: birinci\nlib/b.dart:2:// TODO: ikinci\nlib/a.dart:3:// TODO: üçüncü\n''';
      final todos = fakeOutput
          .trim()
          .split('\n')
          .where((line) => line.isNotEmpty)
          .toList();
      final todoFiles = extractTodoFiles(todos);
      expect(todoFiles.length, equals(2));
      expect(todoFiles.contains('lib/a.dart'), isTrue);
      expect(todoFiles.contains('lib/b.dart'), isTrue);
    });

    test('No TODOs found', () async {
      final fakeOutput = '';
      final todos = fakeOutput
          .trim()
          .split('\n')
          .where((line) => line.isNotEmpty)
          .toList();
      final todoFiles = extractTodoFiles(todos);
      expect(todoFiles.isEmpty, isTrue);
    });

    test('TODO found but file name is empty', () async {
      final fakeOutput = ':1:// TODO: bir şey\n';
      final todos = fakeOutput
          .trim()
          .split('\n')
          .where((line) => line.isNotEmpty)
          .toList();
      final todoFiles = extractTodoFiles(todos);
      expect(todoFiles.isEmpty, isTrue);
    });

    test('TODO found but not a dart file', () async {
      final fakeOutput = 'lib/a.txt:1:// TODO: bir şey\n';
      final todos = fakeOutput
          .trim()
          .split('\n')
          .where((line) => line.isNotEmpty)
          .toList();
      final todoFiles = extractTodoFiles(todos);
      expect(todoFiles.isEmpty, isTrue);
    });

    test('Find TODOs in real file: pubspec.yaml (should be empty)', () async {
      final file = File('pubspec.yaml');
      final lines = await file.readAsLines();
      final todos = lines.where((line) => line.contains('TODO')).toList();
      final todoFiles = extractTodoFiles(todos);
      expect(todoFiles.isEmpty, isTrue);
    });

    test('Find TODOs in real file: scripts/dart_todo_check.dart', () async {
      final file = File('scripts/dart_todo_check.dart');
      final lines = await file.readAsLines();
      final todos = <String>[];
      for (var i = 0; i < lines.length; i++) {
        if (lines[i].contains('TODO')) {
          todos.add('scripts/dart_todo_check.dart:${i + 1}:${lines[i]}');
        }
      }
      final todoFiles = extractTodoFiles(todos);
      expect(todoFiles.contains('scripts/dart_todo_check.dart'), isTrue);
    });

    test('Find TODOs in real file: lib/core/app.dart', () async {
      final file = File('lib/core/app.dart');
      final lines = await file.readAsLines();
      final todos = <String>[];
      for (var i = 0; i < lines.length; i++) {
        if (lines[i].contains('TODO')) {
          todos.add('lib/core/app.dart:${i + 1}:${lines[i]}');
        }
      }
      final todoFiles = extractTodoFiles(todos);
      expect(todoFiles.contains('lib/core/app.dart'), isTrue);
      expect(todos.length, equals(2)); // Dosyada 2 adet TO DO olmalı
    });
  });
}
