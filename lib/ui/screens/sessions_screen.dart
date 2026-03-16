import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterclaw/core/app_providers.dart';
import 'package:flutterclaw/l10n/l10n_extension.dart';

class SessionsScreen extends ConsumerWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionManager = ref.watch(sessionManagerProvider);
    final sessions = sessionManager.listSessions();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.sessions)),
      body: sessions.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.forum_outlined,
                      size: 64, color: theme.colorScheme.primary.withAlpha(128)),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.noActiveSessions,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.startConversationToSee,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return Card(
                  child: ListTile(
                    leading: Icon(_channelIcon(session.channelType)),
                    title: Text(session.key),
                    subtitle: Text(
                      '${context.l10n.messagesCount(session.messageCount)} | '
                      '${context.l10n.tokensCount(session.totalTokens)} | '
                      '${_timeAgo(session.lastActivity, context)}',
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (action) async {
                        if (action == 'reset') {
                          await sessionManager.reset(session.key);
                          ref.invalidate(sessionManagerProvider);
                        } else if (action == 'compact') {
                          await sessionManager.compact(session.key);
                          ref.invalidate(sessionManagerProvider);
                        }
                      },
                      itemBuilder: (ctx) => [
                        PopupMenuItem(
                          value: 'compact',
                          child: ListTile(
                            leading: const Icon(Icons.compress),
                            title: Text(context.l10n.compact),
                            dense: true,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'reset',
                          child: ListTile(
                            leading: const Icon(Icons.delete_outline),
                            title: Text(context.l10n.reset),
                            dense: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  IconData _channelIcon(String channelType) => switch (channelType) {
        'telegram' => Icons.telegram,
        'discord' => Icons.discord,
        'webchat' => Icons.chat,
        _ => Icons.message,
      };

  String _timeAgo(DateTime dt, BuildContext context) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return context.l10n.justNow;
    if (diff.inMinutes < 60) return context.l10n.minutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return context.l10n.hoursAgo(diff.inHours);
    return context.l10n.daysAgo(diff.inDays);
  }
}
