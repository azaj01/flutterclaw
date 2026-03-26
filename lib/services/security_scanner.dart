/// Security pattern scanner for tool arguments and generated code.
///
/// Detects dangerous patterns in tool arguments before execution,
/// matching the security guidance from OpenClaw's security-guidance plugin.
library;

import 'package:logging/logging.dart';

final _log = Logger('flutterclaw.security_scanner');

/// Severity of a detected security issue.
enum SecuritySeverity { warning, block }

/// A detected security issue.
class SecurityIssue {
  final String description;
  final SecuritySeverity severity;
  final String location;

  const SecurityIssue({
    required this.description,
    required this.severity,
    required this.location,
  });

  @override
  String toString() =>
      '[${severity.name.toUpperCase()}] $description (in $location)';
}

/// Result of a security scan.
class ScanResult {
  final List<SecurityIssue> issues;

  const ScanResult(this.issues);

  bool get isClean => issues.isEmpty;

  bool get hasBlock =>
      issues.any((i) => i.severity == SecuritySeverity.block);

  List<SecurityIssue> get warnings =>
      issues.where((i) => i.severity == SecuritySeverity.warning).toList();

  List<SecurityIssue> get blocks =>
      issues.where((i) => i.severity == SecuritySeverity.block).toList();

  String get summary {
    if (isClean) return '';
    final parts = <String>[];
    for (final issue in issues) {
      parts.add(issue.toString());
    }
    return parts.join('\n');
  }
}

class _Pattern {
  final RegExp regex;
  final String description;
  final SecuritySeverity severity;

  _Pattern(String pattern, this.description, this.severity)
      : regex = RegExp(pattern, caseSensitive: false, dotAll: false);
}

/// Scans tool arguments for dangerous patterns before execution.
class SecurityScanner {
  static final _patterns = <_Pattern>[
    // ── BLOCK: high-confidence destructive patterns ──────────────────────────
    _Pattern(
      r'(?:;|\|{1,2}|&&)\s*rm\s+-[a-z]*rf?',
      'Chained rm -rf (shell injection)',
      SecuritySeverity.block,
    ),
    _Pattern(
      r'>\s*/dev/sd[a-z]',
      'Write to raw block device',
      SecuritySeverity.block,
    ),
    _Pattern(
      r'\bdd\s+(?:.*?\s+)?of=/dev/(?:sd|nvme|vd)',
      'dd overwrite to block device',
      SecuritySeverity.block,
    ),
    _Pattern(
      r'curl\s+[^|]*\|\s*(?:sudo\s+)?(?:ba)?sh',
      'curl-pipe-shell (remote code execution)',
      SecuritySeverity.block,
    ),
    _Pattern(
      r'wget\s+[^|]*\|\s*(?:sudo\s+)?(?:ba)?sh',
      'wget-pipe-shell (remote code execution)',
      SecuritySeverity.block,
    ),
    _Pattern(
      r'base64\s+--?decode\s+.*\|\s*(?:ba)?sh',
      'base64-decode-pipe-shell',
      SecuritySeverity.block,
    ),
    _Pattern(
      r'__import__\s*\(\s*.os.\s*\)',
      '__import__("os") dynamic import',
      SecuritySeverity.block,
    ),

    // ── WARN: potentially dangerous but context-dependent ────────────────────
    _Pattern(
      r'\bos\.system\s*\(',
      'os.system() call',
      SecuritySeverity.warning,
    ),
    _Pattern(
      r'\bsubprocess\.(?:run|call|Popen|check_output)\s*\(',
      'subprocess call',
      SecuritySeverity.warning,
    ),
    _Pattern(
      r'\beval\s*\(',
      'eval() call',
      SecuritySeverity.warning,
    ),
    _Pattern(
      r'\bexec\s*\(',
      'exec() call',
      SecuritySeverity.warning,
    ),
    _Pattern(
      r'\bpickle\.loads?\s*\(',
      'pickle deserialization (untrusted data risk)',
      SecuritySeverity.warning,
    ),
    _Pattern(
      r'\byaml\.load\s*\([^,)]+\)',
      'yaml.load without Loader (use yaml.safe_load)',
      SecuritySeverity.warning,
    ),
    _Pattern(
      r'\bmarshal\.loads?\s*\(',
      'marshal deserialization',
      SecuritySeverity.warning,
    ),
    _Pattern(
      r'(?:\.\./){3,}',
      'Deep path traversal (../../../)',
      SecuritySeverity.warning,
    ),
    _Pattern(
      r'%2e%2e(?:%2f|/)',
      'URL-encoded path traversal',
      SecuritySeverity.warning,
    ),
    _Pattern(
      r'<script[\s>]',
      'Script tag injection (XSS risk)',
      SecuritySeverity.warning,
    ),
    _Pattern(
      r'\bjavascript\s*:',
      'javascript: URI scheme (XSS risk)',
      SecuritySeverity.warning,
    ),
    _Pattern(
      r'\bon(?:load|error|click|mouse\w+)\s*=\s*.',
      'Inline event handler (XSS risk)',
      SecuritySeverity.warning,
    ),
  ];

  /// Scans tool arguments for dangerous patterns.
  ///
  /// Returns a [ScanResult] containing all issues found.
  /// An empty [ScanResult.issues] means the args are clean.
  ScanResult scan(String toolName, Map<String, dynamic> args) {
    final issues = <SecurityIssue>[];
    _scanValue(toolName, args, '', issues);
    if (issues.isNotEmpty) {
      _log.info('Security scan for $toolName: ${issues.length} issue(s)');
    }
    return ScanResult(issues);
  }

  void _scanValue(
    String toolName,
    dynamic value,
    String path,
    List<SecurityIssue> issues,
  ) {
    if (value is String) {
      _scanString(toolName, value, path, issues);
    } else if (value is Map) {
      for (final entry in value.entries) {
        final childPath = path.isEmpty ? '${entry.key}' : '$path.${entry.key}';
        _scanValue(toolName, entry.value, childPath, issues);
      }
    } else if (value is List) {
      for (var i = 0; i < value.length; i++) {
        _scanValue(toolName, value[i], '$path[$i]', issues);
      }
    }
  }

  void _scanString(
    String toolName,
    String text,
    String path,
    List<SecurityIssue> issues,
  ) {
    final location = path.isEmpty ? toolName : '$toolName.$path';
    for (final p in _patterns) {
      if (p.regex.hasMatch(text)) {
        issues.add(SecurityIssue(
          description: p.description,
          severity: p.severity,
          location: location,
        ));
      }
    }
  }
}
