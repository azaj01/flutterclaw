import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterclaw/core/agent/session_manager.dart';
import 'package:flutterclaw/core/app_providers.dart';
import 'package:flutterclaw/services/cron_service.dart';
import 'package:flutterclaw/services/skills_service.dart';

class AgentScreen extends ConsumerStatefulWidget {
  const AgentScreen({super.key});

  @override
  ConsumerState<AgentScreen> createState() => _AgentScreenState();
}

class _AgentScreenState extends ConsumerState<AgentScreen> {
  Map<String, String> _files = {};
  bool _loading = true;
  List<SessionMeta> _sessions = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    final configManager = ref.read(configManagerProvider);
    final ws = await configManager.workspacePath;
    final fileNames = [
      'IDENTITY.md',
      'SOUL.md',
      'USER.md',
      'AGENTS.md',
      'TOOLS.md',
      'HEARTBEAT.md',
    ];

    final loaded = <String, String>{};
    for (final name in fileNames) {
      try {
        final file = File('$ws/$name');
        if (await file.exists()) {
          loaded[name] = await file.readAsString();
        }
      } catch (_) {}
    }

    if (mounted) {
      final sessionManager = ref.read(sessionManagerProvider);
      setState(() {
        _files = loaded;
        _sessions = sessionManager.listSessions();
        _loading = false;
      });
    }
  }

  String _parseAgentName() {
    final identity = _files['IDENTITY.md'] ?? '';
    final nameMatch = RegExp(r'(?:Name|name)[:\s]+(.+)').firstMatch(identity);
    return nameMatch?.group(1)?.trim() ?? 'FlutterClaw';
  }

  String _parseAgentEmoji() {
    final identity = _files['IDENTITY.md'] ?? '';
    final emojiMatch =
        RegExp(r'(?:Emoji|emoji)[:\s]+(.+)').firstMatch(identity);
    var raw = emojiMatch?.group(1)?.trim() ?? '';
    raw = raw.replaceAll('*', '').replaceAll('_', '').trim();
    if (raw.isNotEmpty) return raw;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final sessions = _sessions;

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Agent')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final agentName = _parseAgentName();
    final agentEmoji = _parseAgentEmoji();

    return Scaffold(
      appBar: AppBar(title: const Text('Agent')),
      body: RefreshIndicator(
        onRefresh: _loadFiles,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Agent identity header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [colors.primary, colors.tertiary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          agentEmoji.isNotEmpty ? agentEmoji : '🤖',
                          style: const TextStyle(
                            fontSize: 28,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            agentName,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Personal AI Assistant',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _showFileEditor(context, 'IDENTITY.md'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Workspace files
            _SectionTitle(title: 'Workspace Files'),
            ..._files.entries.map((e) => _FileCard(
                  fileName: e.key,
                  preview: _previewText(e.value),
                  onTap: () => _showFileEditor(context, e.key),
                )),

            const SizedBox(height: 20),

            // Sessions
            _SectionTitle(title: 'Sessions (${sessions.length})'),
            if (sessions.isEmpty)
              Card(
                child: ListTile(
                  leading: Icon(Icons.forum_outlined,
                      color: colors.onSurfaceVariant),
                  title: const Text('No active sessions'),
                  subtitle: const Text('Start a conversation to create one'),
                ),
              )
            else
              ...sessions.map((s) => Card(
                    child: ListTile(
                      leading: Icon(_channelIcon(s.channelType)),
                      title: Text(s.key),
                      subtitle: Text(
                        '${s.messageCount} msgs | ${s.totalTokens} tokens | ${_timeAgo(s.lastActivity)}',
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (action) async {
                          if (action == 'reset') {
                            final sm = ref.read(sessionManagerProvider);
                            await sm.reset(s.key);
                            await _loadFiles();
                          }
                        },
                        itemBuilder: (ctx) => [
                          const PopupMenuItem(
                            value: 'reset',
                            child: ListTile(
                              leading: Icon(Icons.delete_outline),
                              title: Text('Reset'),
                              dense: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),

            const SizedBox(height: 20),

            // Cron Jobs
            _SectionTitle(
              title: 'Cron Jobs',
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showAddCronJob(context),
              ),
            ),
            _buildCronSection(),

            const SizedBox(height: 20),

            // Skills
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(
                    'Skills',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (ref.read(skillsServiceProvider).isClawHubAuthenticated)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle,
                              size: 14, color: Colors.green.shade800),
                          const SizedBox(width: 4),
                          Text(
                            'ClawHub',
                            style: TextStyle(
                              color: Colors.green.shade800,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  FilledButton.tonalIcon(
                    onPressed: () => _showClawHubBrowser(context),
                    icon: const Icon(Icons.explore, size: 18),
                    label: const Text('Browse'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
            _buildSkillsSection(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCronSection() {
    final cronService = ref.read(cronServiceProvider);
    final jobs = cronService.jobs;

    if (jobs.isEmpty) {
      return Card(
        child: ListTile(
          leading: Icon(Icons.schedule,
              color: Theme.of(context).colorScheme.onSurfaceVariant),
          title: const Text('No cron jobs'),
          subtitle: const Text('Add scheduled tasks for your agent'),
        ),
      );
    }

    return Column(
      children: jobs
          .map((job) {
            final statusColor = switch (job.lastStatus.name) {
              'success' => Colors.green,
              'failed'  => Theme.of(context).colorScheme.error,
              'running' => Colors.orange,
              _         => Theme.of(context).colorScheme.onSurfaceVariant,
            };
            return Card(
                child: ListTile(
                  onTap: () => _showCronJobDetail(context, job),
                  leading: Icon(
                    job.enabled ? Icons.timer : Icons.timer_off,
                    color: job.enabled ? Colors.green : Colors.grey,
                  ),
                  title: Text(job.name),
                  subtitle: Text(
                    '${job.scheduleDisplay} • ${job.lastStatus.name} • '
                    'Next: ${job.nextRunAt != null ? _timeAgo(job.nextRunAt!) : "N/A"}',
                    style: TextStyle(color: statusColor, fontSize: 12),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (action) async {
                      if (action == 'run') {
                        await cronService.runJob(job.id);
                        setState(() {});
                      } else if (action == 'toggle') {
                        await cronService.updateJob(
                          job.id,
                          enabled: !job.enabled,
                        );
                        setState(() {});
                      } else if (action == 'delete') {
                        await cronService.removeJob(job.id);
                        setState(() {});
                      }
                    },
                    itemBuilder: (ctx) => [
                      PopupMenuItem(
                        value: 'run',
                        child: ListTile(
                          leading: const Icon(Icons.play_arrow),
                          title: const Text('Run Now'),
                          dense: true,
                        ),
                      ),
                      PopupMenuItem(
                        value: 'toggle',
                        child: ListTile(
                          leading: Icon(
                              job.enabled ? Icons.pause : Icons.play_arrow),
                          title:
                              Text(job.enabled ? 'Disable' : 'Enable'),
                          dense: true,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading:
                              Icon(Icons.delete_outline, color: Colors.red),
                          title: Text('Delete',
                              style: TextStyle(color: Colors.red)),
                          dense: true,
                        ),
                      ),
                    ],
                  ),
                ),
              );
          })
          .toList(),
    );
  }

  Widget _buildSkillsSection() {
    final skillsService = ref.read(skillsServiceProvider);
    final skills = skillsService.skills;

    if (skills.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.extension_outlined,
                  size: 40,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(height: 12),
              const Text('No skills installed',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                'Browse ClawHub to discover and install skills',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _showClawHubBrowser(context),
                icon: const Icon(Icons.explore),
                label: const Text('Browse Skills'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: skills.map((skill) => Card(
        child: ListTile(
          leading: Text(
            skill.emoji ?? '🔧',
            style: const TextStyle(fontSize: 22),
          ),
          title: Text(skill.name),
          subtitle: Text(
            skill.description.isNotEmpty
                ? skill.description
                : skill.location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  skill.location,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: skill.enabled,
                onChanged: (val) {
                  skillsService.toggleSkill(skill.name, val);
                  setState(() {});
                },
              ),
            ],
          ),
          onTap: () => _showSkillDetail(context, skill),
          onLongPress: skill.location == 'workspace'
              ? () => _confirmRemoveSkill(context, skill.name)
              : null,
        ),
      )).toList(),
    );
  }

  void _showSkillDetail(BuildContext context, Skill skill) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar: AppBar(
            title: Text('${skill.emoji ?? '🔧'} ${skill.name}'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              skill.instructions,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmRemoveSkill(BuildContext context, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: const Text('Remove skill?'),
        content: Text('Remove "$name" from your skills?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(d, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final skillsService = ref.read(skillsServiceProvider);
    await skillsService.removeSkill(name);
    setState(() {});
  }

  void _showClawHubBrowser(BuildContext context) {
    final searchCtl = TextEditingController();
    final skillsService = ref.read(skillsServiceProvider);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar: AppBar(
            title: const Text('ClawHub Skills'),
            actions: [
              IconButton(
                icon: Icon(
                  skillsService.isClawHubAuthenticated
                      ? Icons.account_circle
                      : Icons.login,
                ),
                tooltip: skillsService.isClawHubAuthenticated
                    ? 'Account'
                    : 'Login to ClawHub',
                onPressed: () => _showClawHubAuth(context),
              ),
            ],
          ),
          body: StatefulBuilder(
            builder: (ctx, setSheetState) {
              return Column(
                children: [
                  // Auth status banner
                  if (!skillsService.isClawHubAuthenticated)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Login to ClawHub to access premium skills and install packages',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          const SizedBox(width: 8),
                          FilledButton.tonal(
                            onPressed: () => _showClawHubAuth(context),
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: searchCtl,
                      decoration: InputDecoration(
                        hintText: 'Search skills...',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () => setSheetState(() {}),
                        ),
                      ),
                      onSubmitted: (_) => setSheetState(() {}),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<ClawHubSkill>>(
                      future: skillsService.searchClawHub(
                        searchCtl.text.trim().isEmpty
                            ? 'popular'
                            : searchCtl.text.trim(),
                      ),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final results = snapshot.data ?? [];
                        if (results.isEmpty) {
                          return const Center(
                            child: Text('No skills found. Try a different search.'),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: results.length,
                          itemBuilder: (ctx, i) {
                            final skill = results[i];
                            return Card(
                              child: ListTile(
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                        .withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      skill.emoji ?? '🔧',
                                      style: const TextStyle(fontSize: 22),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  skill.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    skill.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => _showSkillDetailFromHub(context, skill),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showClawHubAuth(BuildContext context) {
    final skillsService = ref.read(skillsServiceProvider);

    if (skillsService.isClawHubAuthenticated) {
      // Show account options (logout)
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('ClawHub Account'),
          content: const Text('You are currently logged in to ClawHub.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
            FilledButton(
              onPressed: () async {
                await skillsService.logoutClawHub();
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('Logged out from ClawHub')),
                  );
                }
                setState(() {});
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      );
      return;
    }

    // Show login dialog
    final tokenCtl = TextEditingController();
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Connect to ClawHub',
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tokenCtl,
                decoration: const InputDecoration(
                  labelText: 'API Token',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.key),
                  hintText: 'Paste your ClawHub API token',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(ctx)
                      .colorScheme
                      .primaryContainer
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            size: 18,
                            color: Theme.of(ctx).colorScheme.onSurfaceVariant),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'How to get your API token:',
                            style: Theme.of(ctx).textTheme.labelLarge,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '1. Visit clawhub.ai and login with GitHub\n'
                      '2. Run "clawhub login" in terminal\n'
                      '3. Copy your token and paste it here',
                      style: Theme.of(ctx).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (tokenCtl.text.trim().isEmpty) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter an API token'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        setSheetState(() => isLoading = true);

                        final result = await skillsService.authenticateClawHub(
                          token: tokenCtl.text.trim(),
                        );

                        if (ctx.mounted) {
                          setSheetState(() => isLoading = false);

                          if (result.success) {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(
                                content: Text('Successfully connected to ClawHub'),
                              ),
                            );
                            setState(() {});
                          } else {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Connection failed: ${result.error ?? "Invalid token"}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Connect'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCronJobDetail(BuildContext context, CronJob job) {
    final taskCtl = TextEditingController(text: job.task);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final dirty = taskCtl.text.trim() != job.task.trim();
          final statusColor = switch (job.lastStatus.name) {
            'success' => Colors.green,
            'failed'  => colors.error,
            'running' => Colors.orange,
            _         => colors.onSurfaceVariant,
          };

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(job.name, style: theme.textTheme.titleLarge),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.schedule, size: 14),
                        label: Text(job.scheduleDisplay,
                            style: theme.textTheme.labelSmall),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                      ),
                      Chip(
                        label: Text(job.lastStatus.name,
                            style: theme.textTheme.labelSmall
                                ?.copyWith(color: statusColor)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                      ),
                      if (job.runCount > 0)
                        Chip(
                          avatar: const Icon(Icons.replay, size: 14),
                          label: Text('${job.runCount} runs',
                              style: theme.textTheme.labelSmall),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                        ),
                    ],
                  ),
                  if (job.nextRunAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Next run: ${_timeAgo(job.nextRunAt!)}',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ],
                  if (job.lastError != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colors.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Last error: ${job.lastError}',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: colors.onErrorContainer),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text('Task prompt', style: theme.textTheme.labelLarge),
                  const SizedBox(height: 6),
                  TextField(
                    controller: taskCtl,
                    maxLines: 8,
                    minLines: 4,
                    onChanged: (_) => setSheetState(() {}),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Instructions for the agent when this job fires…',
                      filled: true,
                      fillColor: colors.surfaceContainerHighest,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: dirty
                            ? () async {
                                final cronService =
                                    ref.read(cronServiceProvider);
                                await cronService.updateJob(
                                  job.id,
                                  task: taskCtl.text.trim(),
                                );
                                if (ctx.mounted) Navigator.pop(ctx);
                                setState(() {});
                              }
                            : null,
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
          );
        },
      ),
    );
  }

  void _showAddCronJob(BuildContext context) {
    final nameCtl = TextEditingController();
    final taskCtl = TextEditingController();
    int intervalMinutes = 60;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Cron Job',
                  style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtl,
                decoration: const InputDecoration(
                  labelText: 'Job Name',
                  border: OutlineInputBorder(),
                  hintText: 'e.g. Daily Summary',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: taskCtl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Task Prompt',
                  border: OutlineInputBorder(),
                  hintText: 'What should the agent do?',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: intervalMinutes,
                decoration: const InputDecoration(
                  labelText: 'Interval',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 5, child: Text('Every 5 minutes')),
                  DropdownMenuItem(
                      value: 15, child: Text('Every 15 minutes')),
                  DropdownMenuItem(
                      value: 30, child: Text('Every 30 minutes')),
                  DropdownMenuItem(value: 60, child: Text('Every hour')),
                  DropdownMenuItem(
                      value: 360, child: Text('Every 6 hours')),
                  DropdownMenuItem(
                      value: 720, child: Text('Every 12 hours')),
                  DropdownMenuItem(
                      value: 1440, child: Text('Every 24 hours')),
                ],
                onChanged: (v) {
                  if (v != null) {
                    setSheetState(() => intervalMinutes = v);
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () async {
                      if (nameCtl.text.trim().isEmpty ||
                          taskCtl.text.trim().isEmpty) return;
                      final cronService = ref.read(cronServiceProvider);
                      await cronService.addJob(CronJob(
                        name: nameCtl.text.trim(),
                        task: taskCtl.text.trim(),
                        interval:
                            Duration(minutes: intervalMinutes),
                      ));
                      if (ctx.mounted) Navigator.pop(ctx);
                      setState(() {});
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFileEditor(BuildContext context, String fileName) {
    final content = _files[fileName] ?? '';
    final ctl = TextEditingController(text: content);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar: AppBar(
            title: Text(fileName),
            actions: [
              TextButton(
                onPressed: () async {
                  final configManager = ref.read(configManagerProvider);
                  final ws = await configManager.workspacePath;
                  await File('$ws/$fileName').writeAsString(ctl.text);
                  // If IDENTITY.md changed, sync name/emoji back into AgentProfile
                  if (fileName == 'IDENTITY.md') {
                    await configManager.syncAgentIdentitiesFromWorkspace();
                    ref.invalidate(activeAgentProvider);
                    ref.invalidate(agentProfilesProvider);
                  }
                  if (ctx.mounted) Navigator.pop(ctx);
                  await _loadFiles();
                },
                child: const Text('Save'),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: ctl,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _previewText(String content) {
    final lines = content.trim().split('\n');
    final nonEmpty =
        lines.where((l) => l.trim().isNotEmpty && !l.startsWith('#')).toList();
    if (nonEmpty.isEmpty) return '(empty)';
    final preview = nonEmpty.take(2).join(' ').trim();
    return preview.length > 80 ? '${preview.substring(0, 80)}...' : preview;
  }

  IconData _channelIcon(String channelType) => switch (channelType) {
        'telegram' => Icons.telegram,
        'discord' => Icons.discord,
        'webchat' => Icons.chat,
        'system' => Icons.settings,
        _ => Icons.message,
      };

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.isNegative) {
      final abs = diff.abs();
      if (abs.inMinutes < 60) return 'in ${abs.inMinutes}m';
      if (abs.inHours < 24) return 'in ${abs.inHours}h';
      return 'in ${abs.inDays}d';
    }
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  String _formatNumber(int num) {
    if (num >= 1000000) return '${(num / 1000000).toStringAsFixed(1)}M';
    if (num >= 1000) return '${(num / 1000).toStringAsFixed(1)}k';
    return num.toString();
  }

  void _showSkillDetailFromHub(BuildContext context, ClawHubSkill skill) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (ctx, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Theme.of(ctx)
                          .colorScheme
                          .primaryContainer
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        skill.emoji ?? '🔧',
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          skill.name,
                          style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (skill.author != null)
                          Text(
                            'by @${skill.author}',
                            style:
                                Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(ctx)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (skill.downloads > 0 || skill.stars > 0 || skill.version != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      if (skill.downloads > 0)
                        _StatChip(
                          icon: Icons.download,
                          label: _formatNumber(skill.downloads),
                        ),
                      if (skill.downloads > 0 && skill.stars > 0)
                        const SizedBox(width: 8),
                      if (skill.stars > 0)
                        _StatChip(
                          icon: Icons.star,
                          label: '${skill.stars}',
                        ),
                      if (skill.version != null) ...[
                        const SizedBox(width: 8),
                        _StatChip(
                          icon: Icons.label,
                          label: 'v${skill.version}',
                        ),
                      ],
                    ],
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        skill.description,
                        style: Theme.of(ctx).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: () async {
                    final service = ref.read(skillsServiceProvider);

                    // Download content first for compatibility check
                    final content = await service.downloadSkillContent(skill.name);
                    if (content == null) {
                      if (ctx.mounted) {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to install ${skill.name}')),
                        );
                      }
                      return;
                    }

                    // Check compatibility with mobile
                    final compat = await service.checkSkillCompatibility(content);

                    if (!ctx.mounted) return;

                    if (compat.verdict == SkillCompatibility.incompatible) {
                      showDialog(
                        context: ctx,
                        builder: (dCtx) => AlertDialog(
                          icon: const Icon(Icons.block, color: Colors.red, size: 32),
                          title: const Text('Incompatible Skill'),
                          content: Text(
                            'This skill cannot run on mobile (iOS/Android).\n\n${compat.reason}',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dCtx),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                      return;
                    }

                    if (compat.verdict == SkillCompatibility.adaptable) {
                      final userChoice = await showDialog<String>(
                        context: ctx,
                        builder: (dCtx) => AlertDialog(
                          icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 32),
                          title: const Text('Compatibility Warning'),
                          content: Text(
                            'This skill was designed for desktop and may not work as-is on mobile.\n\n${compat.reason}\n\nWould you like to install an adapted version optimized for mobile?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dCtx, 'cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(dCtx, 'original'),
                              child: const Text('Install Original'),
                            ),
                            FilledButton(
                              onPressed: compat.adaptedContent != null
                                  ? () => Navigator.pop(dCtx, 'adapt')
                                  : null,
                              child: const Text('Install Adapted'),
                            ),
                          ],
                        ),
                      );

                      if (userChoice == null || userChoice == 'cancel') return;

                      bool ok;
                      if (userChoice == 'adapt' && compat.adaptedContent != null) {
                        ok = await service.installSkillFromContent(
                            skill.name, compat.adaptedContent!);
                      } else {
                        ok = await service.installSkillFromContent(
                            skill.name, content);
                      }

                      if (ctx.mounted) {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(ok
                                ? 'Installed ${skill.name}'
                                : 'Failed to install ${skill.name}'),
                          ),
                        );
                        if (ok) setState(() {});
                      }
                      return;
                    }

                    // Compatible — install directly
                    final ok = await service.installSkillFromContent(
                        skill.name, content);
                    if (ctx.mounted) {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(ok
                              ? 'Installed ${skill.name}'
                              : 'Failed to install ${skill.name}'),
                        ),
                      );
                      if (ok) setState(() {});
                    }
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Install Skill'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const _SectionTitle({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _FileCard extends StatelessWidget {
  final String fileName;
  final String preview;
  final VoidCallback onTap;

  const _FileCard({
    required this.fileName,
    required this.preview,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: const Icon(Icons.description_outlined),
        title: Text(fileName),
        subtitle: Text(
          preview,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
