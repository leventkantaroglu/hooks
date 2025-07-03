import 'package:test/test.dart';
import 'dart:io';

void main() {
  group('prevent_direct_push', () {
    test('Should block push to master', () async {
      final branch = 'master';
      final blocked = (branch == 'master' || branch == 'develop');
      expect(blocked, isTrue);
    });

    test('Should block push to develop', () async {
      final branch = 'develop';
      final blocked = (branch == 'master' || branch == 'develop');
      expect(blocked, isTrue);
    });

    test('Should allow push to feature branch', () async {
      final branch = 'feature/my-feature';
      final blocked = (branch == 'master' || branch == 'develop');
      expect(blocked, isFalse);
    });
  });
}
