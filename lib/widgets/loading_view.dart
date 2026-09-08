import 'package:flutter/material.dart';

import '../utils/app_spacing.dart';

/// Indicateur de chargement centré.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(message!, textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}

/// Petit spinner pour boutons (20×20).
class ButtonSpinner extends StatelessWidget {
  const ButtonSpinner({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: color ?? Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
