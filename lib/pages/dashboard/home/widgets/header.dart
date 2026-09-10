import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/auth_service.dart';
import '../../../../theme/app_colors.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthService>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Obx(() {
              final name = auth.user.value?.displayName.trim();
              final firstName = (name == null || name.isEmpty)
                  ? 'toi'
                  : name.split(' ').first;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bonjour $firstName',
                    style: const TextStyle(
                      color: AppColors.textOnPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Que souhaitez-vous faire ?',
                    style: TextStyle(
                      color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.surface.withValues(alpha: 0.2),
            backgroundImage: const AssetImage(
              'assets/images/screen-removebg-preview.png',
            ),
          ),
        ],
      ),
    );
  }
}
