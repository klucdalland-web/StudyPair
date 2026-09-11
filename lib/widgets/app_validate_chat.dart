
import 'package:flutter/material.dart';

class AppValidateChat extends StatelessWidget {
  const AppValidateChat({
    super.key,
    required this.onValidate,
  });

  final VoidCallback onValidate;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onValidate,
      child: const Text('Valider'),
    );
  }
}

