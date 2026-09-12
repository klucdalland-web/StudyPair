import 'package:flutter/material.dart';
import 'package:study_pair/widgets/app_button.dart';

class AppValidateChat extends StatelessWidget {
  const AppValidateChat({
    super.key,
    required this.onValidate,
  });

  final VoidCallback onValidate;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: 'Valider',
      onPressed: onValidate,
      expanded: false,
      height: 36,
      variant: AppButtonVariant.primary,
      icon: Icons.verified_outlined,
    );
  }
}
