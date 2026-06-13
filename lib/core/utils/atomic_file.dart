/// Atomic file write helpers — temp file + rename to avoid corruption on crash.
library;

import 'dart:convert';
import 'dart:io';

/// Writes [content] atomically to [path], keeping a `.bak` of the previous file.
Future<void> writeAtomic(String path, String content) async {
  final file = File(path);
  await file.parent.create(recursive: true);

  if (await file.exists()) {
    final backup = File('$path.bak');
    await file.copy(backup.path);
  }

  final temp = File('$path.tmp');
  await temp.writeAsString(content, flush: true);
  await temp.rename(path);
}

/// Reads JSON from [path], falling back to [path].bak on parse failure.
Future<Map<String, dynamic>?> readJsonWithBackup(String path) async {
  final file = File(path);
  if (!await file.exists()) return null;

  try {
    final content = await file.readAsString();
    return jsonDecode(content) as Map<String, dynamic>;
  } catch (_) {
    final backup = File('$path.bak');
    if (!await backup.exists()) rethrow;
    final content = await backup.readAsString();
    return jsonDecode(content) as Map<String, dynamic>;
  }
}
