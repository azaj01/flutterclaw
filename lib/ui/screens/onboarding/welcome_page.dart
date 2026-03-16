import 'package:flutter/material.dart';
import 'package:flutterclaw/l10n/l10n_extension.dart';

class WelcomePage extends StatelessWidget {
  final VoidCallback onGetStarted;

  const WelcomePage({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.primary, colors.tertiary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Icon(Icons.auto_awesome, size: 56, color: Colors.white),
          ),
          const SizedBox(height: 32),
          Text(
            context.l10n.appTitle,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.yourPersonalAssistant,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 48),
          _FeatureRow(
            icon: Icons.chat_bubble_outline,
            title: context.l10n.multiChannelChat,
            subtitle: context.l10n.multiChannelChatDesc,
          ),
          const SizedBox(height: 16),
          _FeatureRow(
            icon: Icons.smart_toy_outlined,
            title: context.l10n.powerfulAIModels,
            subtitle: context.l10n.powerfulAIModelsDesc,
          ),
          const SizedBox(height: 16),
          _FeatureRow(
            icon: Icons.hub_outlined,
            title: context.l10n.localGateway,
            subtitle: context.l10n.localGatewayDesc,
          ),
          const Spacer(flex: 3),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: onGetStarted,
              child: Text(context.l10n.getStarted, style: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleSmall),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
