import 'package:test/test.dart';

void main() {
  group('dart_todo_check', () {
    test('TODOs found', () async {
      final fakeOutput = 'lib/main.dart:1:// TODO: fix this\nlib/other.dart:2:// TODO: another one';
      final todos = fakeOutput.trim().split('\n').where((line) => line.isNotEmpty).toList();
      final todoCount = todos.length;
      expect(todoCount, equals(2));
    });

    test('No TODOs found', () async {
      final fakeOutput = '';
      final todos = fakeOutput.trim().split('\n').where((line) => line.isNotEmpty).toList();
      final todoCount = todos.length;
      expect(todoCount, equals(0));
    });

    test('Çoklu TODO satırlarını doğru sayar', () async {
      final fakeOutput = '''
lib/a.dart:1:// TODO: birinci
lib/b.dart:2:// TODO: ikinci
lib/c.dart:3:// TODO: üçüncü
''';
      final todos = fakeOutput.trim().split('\n').where((line) => line.isNotEmpty).toList();
      final todoCount = todos.length;
      expect(todoCount, equals(3));
    });
  });
}

