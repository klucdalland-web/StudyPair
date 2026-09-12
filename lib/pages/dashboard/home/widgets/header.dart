import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/widgets/app_text.dart';

import '../../../../routes/app_routes.dart';
import '../../../../services/auth_service.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/app_avatar.dart';

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
                  AppText(
                    'Bonjour $firstName',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                     color: AppColors.textOnPrimary,
                    // style: const TextStyle(
                    //   color: AppColors.textOnPrimary,
                    //   fontSize: 22,
                    //   fontWeight: FontWeight.bold,
                    // ),
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    'Que souhaitez-vous faire ?',
                      color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                      fontSize: 16,
                    
                  ),
                ],
              );
            }),
          ),
          const SizedBox(width: 12),
          Obx(() {
            final user = auth.user.value;
            return AppAvatar(
              imageUrl: user?.photoUrl,
              name: user?.displayName,
              size: 44,
              onTap: () => Get.toNamed(Routes.profile),
            );
          }),
        ],
      ),
    );
  }
}
