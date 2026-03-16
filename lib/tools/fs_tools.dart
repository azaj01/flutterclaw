/// File system tools for FlutterClaw.
///
/// All tools restrict operations to the workspace directory.
/// Paths are resolved (including symlinks) and validated against workspace prefix.
library;

import 'dart:io';

import 'package:path/path.dart' as p;

import 'registry.dart';

/// Resolves and validates that [targetPath] is within [workspaceRoot].
/// Returns the resolved absolute path, or null if outside workspace.
/// Resolves symlinks for existing paths; for non-existing paths validates
/// that the path does not escape workspace via '..'.
Future<String?> resolveWithinWorkspace(
  String workspaceRoot,
  String targetPath,
) async {
  final ws = p.normalize(p.absolute(workspaceRoot));
  String resolvedWs;
  try {
    resolvedWs = await File(ws).resolveSymbolicLinks();
  } catch (_) {
    return null;
  }

  final isAbsolute = p.isAbsolute(targetPath);
  final combined =
      isAbsolute ? p.normalize(targetPath) : p.normalize(p.join(ws, targetPath));

  // Check path doesn't escape workspace (handles '..')
  final relative = p.relative(combined, from: ws);
  if (relative.startsWith('..') || p.isAbsolute(relative)) {
    return null;
  }

  String resolvedTarget;
  bool usedResolved = false;
  try {
    resolvedTarget = await File(combined).resolveSymbolicLinks();
    usedResolved = true;
  } catch (_) {
    // File may not exist yet (e.g. write); use normalized path
    resolvedTarget = combined;
  }

  final prefixResolved = p.normalize('$resolvedWs${p.separator}');
  final prefixLogical = p.normalize('$ws${p.separator}');
  final okResolved = resolvedTarget == resolvedWs ||
      resolvedTarget.startsWith(prefixResolved);
  final okLogical =
      resolvedTarget == ws || resolvedTarget.startsWith(prefixLogical);
  if ((usedResolved && okResolved) || (!usedResolved && okLogical)) {
    return resolvedTarget;
  }
  return null;
}

/// Base for file tools that need workspace path resolution.
abstract class WorkspaceTool extends Tool {
  final Future<String> Function() getWorkspacePath;

  WorkspaceTool(this.getWorkspacePath);
}

/// Reads file contents from the workspace.
class ReadFileTool extends WorkspaceTool {
  ReadFileTool(super.getWorkspacePath);

  @override
  String get name => 'read_file';

  @override
  String get description => 'Read the contents of a file from the workspace.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'path': {
            'type': 'string',
            'description': 'Path to the file relative to workspace or absolute.',
          },
        },
        'required': ['path'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final path = args['path'] as String?;
    if (path == null || path.isEmpty) {
      return ToolResult.error('path is required');
    }

    final workspace = await getWorkspacePath();
    final resolved = await resolveWithinWorkspace(workspace, path);
    if (resolved == null) {
      return ToolResult.error('Path is outside workspace: $path');
    }

    try {
      final file = File(resolved);
      if (!await file.exists()) {
        return ToolResult.error('File not found: $path');
      }
      final content = await file.readAsString();
      return ToolResult.success(content);
    } catch (e) {
      return ToolResult.error('Failed to read file: $e');
    }
  }
}

/// Writes content to a file in the workspace.
class WriteFileTool extends WorkspaceTool {
  WriteFileTool(super.getWorkspacePath);

  @override
  String get name => 'write_file';

  @override
  String get description => 'Write content to a file in the workspace. Overwrites if exists.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'path': {
            'type': 'string',
            'description': 'Path to the file relative to workspace or absolute.',
          },
          'content': {
            'type': 'string',
            'description': 'Content to write to the file.',
          },
        },
        'required': ['path', 'content'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final path = args['path'] as String?;
    final content = args['content'] as String?;
    if (path == null || path.isEmpty) {
      return ToolResult.error('path is required');
    }
    if (content == null) {
      return ToolResult.error('content is required');
    }

    final workspace = await getWorkspacePath();
    final resolved = await resolveWithinWorkspace(workspace, path);
    if (resolved == null) {
      return ToolResult.error('Path is outside workspace: $path');
    }

    try {
      final file = File(resolved);
      await file.parent.create(recursive: true);
      await file.writeAsString(content);
      return ToolResult.success('Wrote ${file.path}');
    } catch (e) {
      return ToolResult.error('Failed to write file: $e');
    }
  }
}

/// Replaces old_string with new_string in a file.
class EditFileTool extends WorkspaceTool {
  EditFileTool(super.getWorkspacePath);

  @override
  String get name => 'edit_file';

  @override
  String get description =>
      'Replace a string in a file. Finds old_string and replaces it with new_string.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'path': {
            'type': 'string',
            'description': 'Path to the file relative to workspace or absolute.',
          },
          'old_string': {
            'type': 'string',
            'description': 'The exact string to find and replace.',
          },
          'new_string': {
            'type': 'string',
            'description': 'The replacement string.',
          },
        },
        'required': ['path', 'old_string', 'new_string'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final path = args['path'] as String?;
    final oldStr = args['old_string'] as String?;
    final newStr = args['new_string'] as String?;
    if (path == null || path.isEmpty) {
      return ToolResult.error('path is required');
    }
    if (oldStr == null) {
      return ToolResult.error('old_string is required');
    }
    if (newStr == null) {
      return ToolResult.error('new_string is required');
    }

    final workspace = await getWorkspacePath();
    final resolved = await resolveWithinWorkspace(workspace, path);
    if (resolved == null) {
      return ToolResult.error('Path is outside workspace: $path');
    }

    try {
      final file = File(resolved);
      if (!await file.exists()) {
        return ToolResult.error('File not found: $path');
      }
      var content = await file.readAsString();
      if (!content.contains(oldStr)) {
        return ToolResult.error('old_string not found in file');
      }
      content = content.replaceFirst(oldStr, newStr);
      await file.writeAsString(content);
      return ToolResult.success('Edited ${file.path}');
    } catch (e) {
      return ToolResult.error('Failed to edit file: $e');
    }
  }
}

/// Lists directory contents in the workspace.
class ListDirTool extends WorkspaceTool {
  ListDirTool(super.getWorkspacePath);

  @override
  String get name => 'list_dir';

  @override
  String get description => 'List the contents of a directory in the workspace.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'path': {
            'type': 'string',
            'description': 'Path to the directory relative to workspace or absolute.',
          },
        },
        'required': ['path'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final path = args['path'] as String?;
    if (path == null || path.isEmpty) {
      return ToolResult.error('path is required');
    }

    final workspace = await getWorkspacePath();
    final resolved = await resolveWithinWorkspace(workspace, path);
    if (resolved == null) {
      return ToolResult.error('Path is outside workspace: $path');
    }

    try {
      final dir = Directory(resolved);
      if (!await dir.exists()) {
        return ToolResult.error('Directory not found: $path');
      }
      final list = await dir.list().toList();
      final names = list.map((e) => p.basename(e.path)).toList()..sort();
      return ToolResult.success(names.join('\n'));
    } catch (e) {
      return ToolResult.error('Failed to list directory: $e');
    }
  }
}

/// Appends content to a file in the workspace.
class AppendFileTool extends WorkspaceTool {
  AppendFileTool(super.getWorkspacePath);

  @override
  String get name => 'append_file';

  @override
  String get description => 'Append content to the end of a file in the workspace.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'path': {
            'type': 'string',
            'description': 'Path to the file relative to workspace or absolute.',
          },
          'content': {
            'type': 'string',
            'description': 'Content to append to the file.',
          },
        },
        'required': ['path', 'content'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final path = args['path'] as String?;
    final content = args['content'] as String?;
    if (path == null || path.isEmpty) {
      return ToolResult.error('path is required');
    }
    if (content == null) {
      return ToolResult.error('content is required');
    }

    final workspace = await getWorkspacePath();
    final resolved = await resolveWithinWorkspace(workspace, path);
    if (resolved == null) {
      return ToolResult.error('Path is outside workspace: $path');
    }

    try {
      final file = File(resolved);
      await file.parent.create(recursive: true);
      await file.writeAsString(content, mode: FileMode.append);
      return ToolResult.success('Appended to ${file.path}');
    } catch (e) {
      return ToolResult.error('Failed to append to file: $e');
    }
  }
}
