import 'package:test/test.dart';

Set<String> extractTodoFiles(List<String> todos) {
  final todoFiles = <String>{};
  for (final line in todos) {
    final parts = line.split(':');
    if (parts.length > 1) {
      final file = parts[0].trim();
      if (file.isNotEmpty && file.endsWith('.dart')) {
        todoFiles.add(file);
      }
    }
  }
  return todoFiles;
}

void main() {
  group('dart_todo_check', () {
    test('TODOs found in multiple files', () async {
      final fakeOutput = '''lib/a.dart:1:// TODO: birinci\nlib/b.dart:2:// TODO: ikinci\nlib/a.dart:3:// TODO: üçüncü\n''';
      final todos = fakeOutput.trim().split('\n').where((line) => line.isNotEmpty).toList();
      final todoFiles = extractTodoFiles(todos);
      expect(todoFiles.length, equals(2));
      expect(todoFiles.contains('lib/a.dart'), isTrue);
      expect(todoFiles.contains('lib/b.dart'), isTrue);
    });

    test('No TODOs found', () async {
      final fakeOutput = '';
      final todos = fakeOutput.trim().split('\n').where((line) => line.isNotEmpty).toList();
      final todoFiles = extractTodoFiles(todos);
      expect(todoFiles.isEmpty, isTrue);
    });

    test('TODO found but file name is empty', () async {
      final fakeOutput = ':1:// TODO: bir şey\n';
      final todos = fakeOutput.trim().split('\n').where((line) => line.isNotEmpty).toList();
      final todoFiles = extractTodoFiles(todos);
      expect(todoFiles.isEmpty, isTrue);
    });

    test('TODO found but not a dart file', () async {
      final fakeOutput = 'lib/a.txt:1:// TODO: bir şey\n';
      final todos = fakeOutput.trim().split('\n').where((line) => line.isNotEmpty).toList();
      final todoFiles = extractTodoFiles(todos);
      expect(todoFiles.isEmpty, isTrue);
    });
  });
}
