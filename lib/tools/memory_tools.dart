/// Memory tools for FlutterClaw.
///
/// Two-tier memory matching OpenClaw:
/// - MEMORY.md: curated long-term memory (agent writes via write_file)
/// - memory/YYYY-MM-DD.md: episodic daily logs (memory_write appends here)
library;

import 'dart:io';

import 'registry.dart';

String _memoryDir(String workspaceRoot) => '$workspaceRoot/memory';

String _todayFile(String workspaceRoot) {
  final now = DateTime.now();
  final date =
      '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  return '${_memoryDir(workspaceRoot)}/$date.md';
}

/// Searches across MEMORY.md and all daily memory files.
class MemorySearchTool extends Tool {
  final Future<String> Function() getWorkspacePath;

  MemorySearchTool(this.getWorkspacePath);

  @override
  String get name => 'memory_search';

  @override
  String get description =>
      'Search memory for entries matching keywords. Searches both long-term '
      'memory (MEMORY.md) and daily episodic logs (memory/YYYY-MM-DD.md).';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'query': {
            'type': 'string',
            'description': 'Search query or keywords to find in memory.',
          },
        },
        'required': ['query'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final query = args['query'] as String?;
    if (query == null || query.isEmpty) {
      return ToolResult.error('query is required');
    }

    final workspace = await getWorkspacePath();
    final memDir = _memoryDir(workspace);
    final keywords = query.toLowerCase().split(RegExp(r'\s+'));
    final allMatches = <String>[];

    // Scan all .md files in memory directory
    final dir = Directory(memDir);
    if (await dir.exists()) {
      await for (final entity in dir.list()) {
        if (entity is! File || !entity.path.endsWith('.md')) continue;
        try {
          final content = await entity.readAsString();
          if (content.trim().isEmpty) continue;
          final fileName = entity.path.split('/').last;
          final fileMatches = _searchInContent(content, keywords);
          if (fileMatches.isNotEmpty) {
            allMatches.add('### $fileName\n${fileMatches.join('\n\n')}');
          }
        } catch (_) {}
      }
    }

    if (allMatches.isEmpty) {
      return ToolResult.success('No matching entries for: $query');
    }
    return ToolResult.success(allMatches.join('\n\n---\n\n'));
  }

  List<String> _searchInContent(String content, List<String> keywords) {
    final lines = content.split('\n');
    final matches = <String>[];
    var inBlock = false;
    var blockBuffer = <String>[];

    for (final line in lines) {
      final lower = line.toLowerCase();
      final matchesQuery = keywords.any((k) => lower.contains(k));
      if (matchesQuery) {
        if (!inBlock) {
          blockBuffer = [line];
          inBlock = true;
        } else {
          blockBuffer.add(line);
        }
      } else if (inBlock) {
        if (line.trim().isEmpty || line.startsWith('#')) {
          matches.add(blockBuffer.join('\n'));
          inBlock = false;
        } else {
          blockBuffer.add(line);
        }
      }
    }
    if (inBlock) {
      matches.add(blockBuffer.join('\n'));
    }
    return matches;
  }
}

/// Returns the full memory content (MEMORY.md + optional daily file).
class MemoryGetTool extends Tool {
  final Future<String> Function() getWorkspacePath;

  MemoryGetTool(this.getWorkspacePath);

  @override
  String get name => 'memory_get';

  @override
  String get description =>
      'Return the full content of MEMORY.md (long-term) and optionally '
      "today's daily log.";

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'daily': {
            'type': 'boolean',
            'description':
                "If true, also include today's daily log. Default: false.",
          },
        },
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final includeDaily = args['daily'] as bool? ?? false;
    final workspace = await getWorkspacePath();
    final parts = <String>[];

    // Long-term memory
    final memFile = File('${_memoryDir(workspace)}/MEMORY.md');
    if (await memFile.exists()) {
      final content = await memFile.readAsString();
      if (content.trim().isNotEmpty) {
        parts.add('# MEMORY.md (long-term)\n\n$content');
      }
    }

    // Today's daily log
    if (includeDaily) {
      final todayPath = _todayFile(workspace);
      final todayFile = File(todayPath);
      if (await todayFile.exists()) {
        final content = await todayFile.readAsString();
        if (content.trim().isNotEmpty) {
          parts.add("# Today's log\n\n$content");
        }
      }
    }

    if (parts.isEmpty) {
      return ToolResult.success('Memory is empty.');
    }
    return ToolResult.success(parts.join('\n\n---\n\n'));
  }
}

/// Writes to today's episodic daily log (memory/YYYY-MM-DD.md).
class MemoryWriteTool extends Tool {
  final Future<String> Function() getWorkspacePath;

  MemoryWriteTool(this.getWorkspacePath);

  @override
  String get name => 'memory_write';

  @override
  String get description =>
      "Append an entry to today's daily memory log (memory/YYYY-MM-DD.md). "
      'Use for notes, observations, and running context. '
      'For curated long-term memory, use write_file on MEMORY.md instead.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'content': {
            'type': 'string',
            'description': 'Content to append to daily memory.',
          },
        },
        'required': ['content'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final content = args['content'] as String?;
    if (content == null || content.isEmpty) {
      return ToolResult.error('content is required');
    }

    final workspace = await getWorkspacePath();
    final path = _todayFile(workspace);

    try {
      final file = File(path);
      await file.parent.create(recursive: true);
      final timestamp = DateTime.now().toIso8601String().split('.').first;
      final entry = '\n\n## $timestamp\n$content';
      await file.writeAsString(entry, mode: FileMode.append);
      return ToolResult.success('Daily memory updated (${file.path.split('/').last}).');
    } catch (e) {
      return ToolResult.error('Memory write failed: $e');
    }
  }
}
