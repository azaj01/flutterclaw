// ignore_for_file: unused_import
import "package:flutter/material.dart";
import "package:flutterclaw/ui/theme/tokens.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutterclaw/channels/slack.dart";
import "package:flutterclaw/core/app_providers.dart";
import "package:flutterclaw/l10n/l10n_extension.dart";
import "package:flutterclaw/services/pairing_service.dart";
import "package:flutterclaw/services/channel_validation.dart";
import "package:flutterclaw/data/models/config.dart";
import "package:flutterclaw/ui/widgets/allowlist_editor.dart";
class SlackConfigScreen extends ConsumerStatefulWidget {
  const SlackConfigScreen({super.key});
  @override
  ConsumerState<SlackConfigScreen> createState() => _SlackConfigScreenState();
}

class _SlackConfigScreenState extends ConsumerState<SlackConfigScreen> {
  late TextEditingController _botTokenCtrl;
  late TextEditingController _appTokenCtrl;
  late List<String> _allowFrom;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final slack = ref.read(configManagerProvider).config.channels.slack;
    _botTokenCtrl = TextEditingController(text: slack.botToken ?? '');
    _appTokenCtrl = TextEditingController(text: slack.appToken ?? '');
    _allowFrom = List.of(slack.allowFrom);
  }

  @override
  void dispose() {
    _botTokenCtrl.dispose();
    _appTokenCtrl.dispose();
    super.dispose();
  }

  /// Validates [validationError] with the user; returns true to proceed.
  Future<bool> _confirmSaveDespiteError(String validationError) async {
    if (!mounted) return false;
    final proceed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.tokenValidationFailed(validationError)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(ctx.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(ctx.l10n.saveAnyway),
          ),
        ],
      ),
    );
    return proceed == true;
  }

  Future<void> _save() async {
    final botToken = _botTokenCtrl.text.trim();
    final appToken = _appTokenCtrl.text.trim();
    if (botToken.isEmpty || appToken.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.bothTokensRequired)),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final validationError =
          await ChannelValidation.slackTokens(botToken, appToken);
      if (validationError != null &&
          !await _confirmSaveDespiteError(validationError)) {
        return;
      }

      final configManager = ref.read(configManagerProvider);
      final config = configManager.config;
      configManager.update(config.copyWith(
        channels: config.channels.copyWith(
          slack: SlackConfig(
            enabled: true,
            botToken: botToken,
            appToken: appToken,
            allowFrom: _allowFrom,
          ),
        ),
      ));
      await configManager.save();

      String? connectError;
      try {
        await ref.read(channelControlProvider).reload('slack');
      } catch (e) {
        connectError = e.toString();
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            connectError == null
                ? context.l10n.slackConfigSaved
                : context.l10n.channelConnectFailed(connectError),
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric(e.toString()))));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _disconnect() async {
    setState(() => _saving = true);
    try {
      final configManager = ref.read(configManagerProvider);
      final current = configManager.config.channels.slack;
      configManager.update(configManager.config.copyWith(
        channels: configManager.config.channels.copyWith(
          slack: SlackConfig(
            enabled: false,
            botToken: current.botToken,
            appToken: current.appToken,
            allowFrom: current.allowFrom,
          ),
        ),
      ));
      await configManager.save();
      await ref.read(channelControlProvider).disconnect('slack');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.channelDisconnected)),
        );
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final channelEnabled =
        ref.read(configManagerProvider).config.channels.slack.enabled;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.slackConfiguration),
        actions: [
          if (channelEnabled)
            TextButton.icon(
              onPressed: _saving ? null : _disconnect,
              icon: const Icon(Icons.logout),
              label: Text(context.l10n.disconnect),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.setupTitle, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.slackSetupInstructions,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _botTokenCtrl,
            obscureText: true,
            decoration: InputDecoration(
              labelText: context.l10n.botTokenXoxb,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.key),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _appTokenCtrl,
            obscureText: true,
            decoration: InputDecoration(
              labelText: context.l10n.appLevelToken,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.vpn_key_outlined),
            ),
          ),
          const SizedBox(height: 24),
          AllowlistEditor(
            entries: _allowFrom,
            onChanged: (entries) => setState(() => _allowFrom = entries),
            hintText: 'U0123456789',
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: Text(context.l10n.saveAndConnect),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Signal Configuration Screen
// ---------------------------------------------------------------------------

