import 'package:flutter/material.dart';
import 'package:flutterclaw/l10n/l10n_extension.dart';

/// Inline editor for a channel allowlist (`allow_from`).
///
/// Shows a prominent warning when the list is empty, since an empty
/// allowlist means open access on Slack/Signal-style channels.
class AllowlistEditor extends StatefulWidget {
  const AllowlistEditor({
    super.key,
    required this.entries,
    required this.onChanged,
    this.hintText,
  });

  final List<String> entries;
  final ValueChanged<List<String>> onChanged;
  final String? hintText;

  @override
  State<AllowlistEditor> createState() => _AllowlistEditorState();
}

class _AllowlistEditorState extends State<AllowlistEditor> {
  final _addCtrl = TextEditingController();

  @override
  void dispose() {
    _addCtrl.dispose();
    super.dispose();
  }

  void _add() {
    final value = _addCtrl.text.trim();
    if (value.isEmpty || widget.entries.contains(value)) return;
    widget.onChanged([...widget.entries, value]);
    _addCtrl.clear();
  }

  void _remove(String value) {
    widget.onChanged(widget.entries.where((e) => e != value).toList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.allowedUsersTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        if (widget.entries.isEmpty)
          Card(
            color: colors.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: colors.onErrorContainer),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.l10n.allowlistEmptyWarning,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final entry in widget.entries)
                InputChip(
                  label: Text(entry),
                  onDeleted: () => _remove(entry),
                ),
            ],
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _addCtrl,
                decoration: InputDecoration(
                  hintText: widget.hintText ?? context.l10n.allowFromAddHint,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                onSubmitted: (_) => _add(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              icon: const Icon(Icons.add),
              tooltip: context.l10n.add,
              onPressed: _add,
            ),
          ],
        ),
      ],
    );
  }
}
