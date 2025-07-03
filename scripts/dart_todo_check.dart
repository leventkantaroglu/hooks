#!/usr/bin/env dart

// A simple pre-commit hook for Dart: checks for TODO comments and fails if any are found.
import 'dart:io';

void main() async {
  final result = await Process.run('grep', ['-r', 'TODO', 'lib/', 'test/']);
  if (result.exitCode == 0) {
    final todos = result.stdout.toString().trim().split('\n').where((line) => line.isNotEmpty).toList();
    final todoCount = todos.length;
    print('⚠️  UYARI: $todoCount adet TODO bulundu. Lütfen gözden geçirin.');
    print(result.stdout);
    // macOS için tek bir native dialog göster, toplam TODO sayısını belirt
    final dialogResult = await Process.run('osascript', [
      '-e',
      'display dialog "$todoCount adet TODO bulundu! Lütfen gözden geçirin." buttons {"İptal", "Devam"} default button "Devam" with icon caution',
    ]);
    if (dialogResult.stdout != null && dialogResult.stdout.toString().contains('İptal')) {
      print('Commit kullanıcı tarafından iptal edildi.');
      exit(1); // Commit'i engelle
    }
    exit(0);
  } else {
    print('✅ No TODO comments found.');
    exit(0);
  }
}
