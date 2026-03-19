import 'package:flutter/material.dart';
import 'package:flutterclaw/ui/theme/semantic_colors.dart';

enum StatusDotState { success, warning, error, inactive }

/// A small colored dot used to indicate status (connected, warning, offline, etc).
class StatusDot extends StatelessWidget {
  const StatusDot({super.key, required this.state, this.size = 10});

  final StatusDotState state;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = switch (state) {
      StatusDotState.success => context.semantic.statusSuccess,
      StatusDotState.warning => context.semantic.statusWarning,
      StatusDotState.error => context.semantic.statusError,
      StatusDotState.inactive => context.semantic.statusInactive,
    };
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
