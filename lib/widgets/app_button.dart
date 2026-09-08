import 'package:flutter/material.dart';

import 'loading_view.dart';

/// Bouton plein largeur avec état loading.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final handler = loading ? null : onPressed;

    if (outlined) {
      return OutlinedButton(
        onPressed: handler,
        child: loading
            ? ButtonSpinner(color: Theme.of(context).colorScheme.primary)
            : Text(label),
      );
    }
    return ElevatedButton(
      onPressed: handler,
      child: loading ? const ButtonSpinner() : Text(label),
    );
  }
}
