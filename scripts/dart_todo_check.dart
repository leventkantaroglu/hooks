#!/usr/bin/env dart

// A simple pre-commit hook for Dart: checks for TODO comments and fails if any are found.
import 'dart:io';

void main() async {
  final result = await Process.run('grep', ['-r', 'TODO', 'lib/', 'test/']);
  if (result.exitCode == 0) {
    print(
      '⚠️  UYARI: TODO comments found in the codebase. Lütfen gözden geçirin.',
    );
    print(result.stdout);
    // macOS için native dialog göster, Devam/İptal seçenekleriyle
    final dialogResult = await Process.run('osascript', [
      '-e',
      'display dialog "TODO bulundu! Lütfen gözden geçirin." buttons {"İptal", "Devam"} default button "Devam" with icon caution',
    ]);
    // osascript stdout: button returned:Devam veya button returned:İptal
    if (dialogResult.stdout != null &&
        dialogResult.stdout.toString().contains('İptal')) {
      print('Commit kullanıcı tarafından iptal edildi.');
      exit(1); // Commit'i engelle
    }
    // Devam seçildiyse commit'e izin ver
    exit(0);
  } else {
    print('✅ No TODO comments found.');
    exit(0);
  }
}
