import 'package:flutter/material.dart';
import 'package:flutterclaw/ui/theme/tokens.dart';

/// A styled section header used in settings and other list screens.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppTokens.spacingLG,
        bottom: AppTokens.spacingSM,
        left: AppTokens.spacingSM,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
      ),
    );
  }
}
