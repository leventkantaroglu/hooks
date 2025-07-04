import 'package:test/test.dart';

void main() {
  group('dart_todo_check', () {
    test('TODOs found in multiple files', () async {
      final fakeOutput = '''lib/a.dart:1:// TODO: birinci
lib/b.dart:2:// TODO: ikinci
lib/a.dart:3:// TODO: üçüncü
''';
      final todos = fakeOutput.trim().split('\n').where((line) => line.isNotEmpty).toList();
      final todoFiles = <String>{};
      for (final line in todos) {
        final parts = line.split(':');
        if (parts.length > 1) {
          final file = parts[0];
          if (file.endsWith('.dart')) {
            todoFiles.add(file);
          }
        }
      }
      expect(todoFiles.length, equals(2));
      expect(todoFiles.contains('lib/a.dart'), isTrue);
      expect(todoFiles.contains('lib/b.dart'), isTrue);
    });

    test('No TODOs found', () async {
      final fakeOutput = '';
      final todos = fakeOutput.trim().split('\n').where((line) => line.isNotEmpty).toList();
      final todoFiles = <String>{};
      for (final line in todos) {
        final parts = line.split(':');
        if (parts.length > 1) {
          final file = parts[0];
          if (file.endsWith('.dart')) {
            todoFiles.add(file);
          }
        }
      }
      expect(todoFiles.isEmpty, isTrue);
    });
  });
}

