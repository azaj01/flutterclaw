import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterclaw/core/app_providers.dart';
import 'package:flutterclaw/l10n/l10n_extension.dart';
import 'package:flutterclaw/ui/screens/create_agent_screen.dart';

class AgentsListScreen extends ConsumerWidget {
  const AgentsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final agents = ref.watch(agentProfilesProvider);
    final activeAgent = ref.watch(activeAgentProvider);
    final configManager = ref.read(configManagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.agents),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const CreateAgentScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: agents.isEmpty
          ? _buildEmptyState(context, colors)
          : ListView(
              padding: const EdgeInsets.all(16),
              children: _buildAgentCards(
                agents,
                activeAgent,
                context,
                configManager,
                ref,
              ),
            ),
    );
  }

  List<Widget> _buildAgentCards(
    List agents,
    activeAgent,
    BuildContext context,
    configManager,
    WidgetRef ref,
  ) {
    final sortedAgents = agents.toList()
      ..sort((a, b) {
        if (a.id == activeAgent?.id) return -1;
        if (b.id == activeAgent?.id) return 1;
        return b.lastUsedAt.compareTo(a.lastUsedAt);
      });

    return sortedAgents.map((agent) {
      return _AgentCard(
        agent: agent,
        isActive: agent.id == activeAgent?.id,
        onTap: () {
          // TODO: Navigate to details screen
        },
        onLongPress: () {
          _showAgentMenu(
            context,
            agent,
            agent.id == activeAgent?.id,
            configManager,
            ref,
          );
        },
      );
    }).toList();
  }

  Widget _buildEmptyState(BuildContext context, ColorScheme colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_outlined,
              size: 80,
              color: colors.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.noAgentsYet,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.createYourFirstAgent,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAgentMenu(
    BuildContext context,
    agent,
    bool isActive,
    configManager,
    WidgetRef ref,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!agent.isDefault)
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: Text(context.l10n.setAsDefault),
                onTap: () {
                  Navigator.pop(ctx);
                  _setAsDefault(agent, configManager, ref);
                },
              ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(context.l10n.editAgent),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => CreateAgentScreen(agent: agent),
                  ),
                );
              },
            ),
            if (!isActive)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(context.l10n.delete),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmDelete(context, agent, configManager, ref);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _setAsDefault(dynamic agent, dynamic configManager, WidgetRef ref) async {
    final config = configManager.config;
    final updatedProfiles = config.agentProfiles.map((a) {
      return a.copyWith(isDefault: a.id == agent.id);
    }).toList();

    configManager.update(config.copyWith(agentProfiles: updatedProfiles));
    await configManager.save();
    ref.invalidate(agentProfilesProvider);
    ref.invalidate(activeAgentProvider);
    ref.invalidate(activeWorkspacePathProvider);
    ref.invalidate(activeModelSupportsVisionProvider);
  }

  Future<void> _confirmDelete(
    BuildContext context,
    dynamic agent,
    dynamic configManager,
    WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.delete),
        content: Text(
          context.l10n.deleteAgentConfirm(agent.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await _deleteAgent(context, agent, configManager, ref);
    }
  }

  Future<void> _deleteAgent(
    BuildContext context,
    dynamic agent,
    dynamic configManager,
    WidgetRef ref,
  ) async {
    final config = configManager.config;
    final activeAgent = config.activeAgent;

    // Remove from profiles
    final updatedProfiles =
        config.agentProfiles.where((a) => a.id != agent.id).toList();

    // If deleting active agent, switch to first remaining agent
    String? newActiveAgentId = config.activeAgentId;
    if (agent.id == activeAgent?.id && updatedProfiles.isNotEmpty) {
      newActiveAgentId = updatedProfiles.first.id;
    }

    configManager.update(config.copyWith(
      agentProfiles: updatedProfiles,
      activeAgentId: newActiveAgentId,
    ));
    await configManager.save();

    // Delete workspace directory
    try {
      final workspacePath = await configManager.getAgentWorkspace(agent.id);
      await Directory(workspacePath).delete(recursive: true);
    } catch (e) {
      // Workspace might not exist or already deleted
    }

    ref.invalidate(agentProfilesProvider);
    ref.invalidate(activeAgentProvider);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.agentDeleted)),
      );
    }
  }
}

class _AgentCard extends StatelessWidget {
  final dynamic agent;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _AgentCard({
    required this.agent,
    required this.isActive,
    required this.onTap,
    required this.onLongPress,
  });

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Emoji container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isActive
                      ? colors.primaryContainer
                      : colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    agent.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Agent info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            agent.name,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (agent.isDefault) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Default',
                              style: TextStyle(
                                color: colors.primary,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${agent.modelName} • ${isActive ? 'Active' : _formatTimeAgo(agent.lastUsedAt)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Active indicator or chevron
              if (isActive)
                Icon(
                  Icons.check_circle,
                  color: colors.primary,
                  size: 20,
                )
              else
                Icon(
                  Icons.chevron_right,
                  color: colors.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
