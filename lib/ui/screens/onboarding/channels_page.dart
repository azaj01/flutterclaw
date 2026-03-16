import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutterclaw/l10n/l10n_extension.dart';

class ChannelsPageResult {
  final bool telegramEnabled;
  final String? telegramToken;
  final bool discordEnabled;
  final String? discordToken;

  const ChannelsPageResult({
    this.telegramEnabled = false,
    this.telegramToken,
    this.discordEnabled = false,
    this.discordToken,
  });
}

class ChannelsPage extends StatefulWidget {
  final ValueChanged<ChannelsPageResult> onChanged;

  const ChannelsPage({super.key, required this.onChanged});

  @override
  State<ChannelsPage> createState() => _ChannelsPageState();
}

class _ChannelsPageState extends State<ChannelsPage> {
  bool _telegramEnabled = false;
  bool _discordEnabled = false;
  final _telegramTokenCtl = TextEditingController();
  final _discordTokenCtl = TextEditingController();

  @override
  void dispose() {
    _telegramTokenCtl.dispose();
    _discordTokenCtl.dispose();
    super.dispose();
  }

  void _emitChange() {
    widget.onChanged(ChannelsPageResult(
      telegramEnabled: _telegramEnabled,
      telegramToken: _telegramTokenCtl.text.trim().isNotEmpty
          ? _telegramTokenCtl.text.trim()
          : null,
      discordEnabled: _discordEnabled,
      discordToken: _discordTokenCtl.text.trim().isNotEmpty
          ? _discordTokenCtl.text.trim()
          : null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      children: [
        Text(
          context.l10n.channelsPageTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          context.l10n.channelsPageDesc,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),

        // Telegram
        _ChannelCard(
          icon: Icons.send,
          name: context.l10n.telegram,
          description: context.l10n.connectTelegramBot,
          enabled: _telegramEnabled,
          onToggle: (val) {
            setState(() => _telegramEnabled = val);
            _emitChange();
          },
          signupUrl: 'https://t.me/BotFather',
          signupLabel: context.l10n.openBotFather,
          tokenController: _telegramTokenCtl,
          onTokenChanged: (_) => _emitChange(),
        ),

        const SizedBox(height: 12),

        // Discord
        _ChannelCard(
          icon: Icons.forum,
          name: context.l10n.discord,
          description: context.l10n.connectDiscordBot,
          enabled: _discordEnabled,
          onToggle: (val) {
            setState(() => _discordEnabled = val);
            _emitChange();
          },
          signupUrl: 'https://discord.com/developers/applications',
          signupLabel: context.l10n.developerPortal,
          tokenController: _discordTokenCtl,
          onTokenChanged: (_) => _emitChange(),
        ),
      ],
    );
  }
}

class _ChannelCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String description;
  final bool enabled;
  final ValueChanged<bool> onToggle;
  final String signupUrl;
  final String signupLabel;
  final TextEditingController tokenController;
  final ValueChanged<String> onTokenChanged;

  const _ChannelCard({
    required this.icon,
    required this.name,
    required this.description,
    required this.enabled,
    required this.onToggle,
    required this.signupUrl,
    required this.signupLabel,
    required this.tokenController,
    required this.onTokenChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        child: Column(
          children: [
            SwitchListTile(
              secondary: Icon(icon),
              title: Text(name),
              subtitle: Text(description),
              value: enabled,
              onChanged: onToggle,
            ),
            if (enabled)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        final uri = Uri.parse(signupUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.open_in_new,
                              size: 14, color: colors.primary),
                          const SizedBox(width: 6),
                          Text(
                            signupLabel,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: tokenController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: context.l10n.telegramBotToken(name),
                        border: const OutlineInputBorder(),
                        isDense: true,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.paste),
                          tooltip: 'Paste',
                          onPressed: () async {
                            final data = await Clipboard.getData(Clipboard.kTextPlain);
                            if (data?.text != null) {
                              tokenController.text = data!.text!;
                              onTokenChanged(data.text!);
                            }
                          },
                        ),
                      ),
                      onChanged: onTokenChanged,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
