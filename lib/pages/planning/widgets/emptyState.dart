import 'package:flutter/material.dart ';
import '../../../theme/app_colors.dart';
class EmptyState extends StatelessWidget {
  const EmptyState();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 40, color: AppColors.textSecondary.withOpacity(0.5)),
          const SizedBox(height: 12),
          const Text(
            'Aucune demande pour le moment',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}