#!/usr/bin/env dart

import 'dart:io';

void main() async {
  print('Current working directory: ${Directory.current.path}');

  // git ile staged dosyaları bul
  final gitResult = await Process.run('git', [
    'diff',
    '--cached',
    '--name-only',
  ]);

  print('Kontrol edilen dosyalar:');
  for (final file in gitResult.stdout.toString().split('\n')) {
    print('- $file');
  }
  final files = gitResult.stdout
      .toString()
      .split('\n')
      .where((f) => f.endsWith('.dart'))
      .toList();
  if (files.isEmpty) {
    print('✅ No staged Dart files to check.');
    exit(0);
  }

  // Sadece bu dosyalarda TO DO ara
  final grepArgs = <String>['-n', 'TODO', ...files];
  final result = await Process.run('grep', grepArgs);

  if (result.exitCode == 0) {
    final todos = result.stdout
        .toString()
        .trim()
        .split('\n')
        .where((line) => line.isNotEmpty)
        .toList();
    final todoCount = todos.length;
    print(
      '⚠️  UYARI: $todoCount adet TODO bulundu. Sadece işlem yapılan dosyalarda arandı.',
    );
    print(result.stdout);
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
    if (todoFiles.isEmpty) {
      print('UYARI: TODO bulundu ama dosya adı tespit edilemedi!');
    } else {
      print('Aşağıdaki dosyalarda TODO bulundu:');
      for (final file in todoFiles) {
        print('- $file');
      }
      // macOS için tek bir native dialog göster, toplam TO DO sayısını ve dosya listesini belirt
      final fileList = todoFiles.join("\n");
      final dialogResult = await Process.run('osascript', [
        '-e',
        'display dialog "$todoCount adet TODO bulundu!\nAşağıdaki dosyalarda TODO bulundu:\n$fileList\nLütfen gözden geçirin." buttons {"Vazgeç", "Yine de Devam Et"} default button "Yine de Devam Et" with icon caution',
      ]);
      if (dialogResult.stdout != null &&
          dialogResult.stdout.toString().contains('Vazgeç')) {
        print('Commit kullanıcı tarafından iptal edildi.');
        exit(1); // Commit'i engelle
      }
    }
    exit(0);
  } else {
    print('✅ No TODO comments found in staged files.');
    exit(0);
  }
}
