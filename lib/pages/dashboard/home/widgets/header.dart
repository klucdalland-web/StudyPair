import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/controller/notification_controller.dart';
import 'package:study_pair/widgets/app_text.dart';

import '../../../../routes/app_routes.dart';
import '../../../../services/auth_service.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/app_avatar.dart';
import '../../notifications/notifications_page.dart';

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
          const _NotificationButton(),
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

class _NotificationButton extends StatelessWidget {
  const _NotificationButton();

  static void _open() {
    Get.to<void>(
      () => const NotificationsPage(),
      binding: NotificationsBinding(),
      preventDuplicates: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Le badge ne s'affiche que si le controller est déjà enregistré
    // (ex. binding global ou visite précédente de la page). Sinon on
    // affiche juste la cloche, sans planter.
    final hasController = Get.isRegistered<NotificationsController>();

    return InkWell(
      onTap: _open,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 44,
        width: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.textOnPrimary.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(
              Icons.notifications_outlined,
              color: AppColors.textOnPrimary,
              size: 22,
            ),
            if (hasController)
              Obx(() {
                final count = Get.find<NotificationsController>().unreadCount;
                if (count == 0) return const SizedBox.shrink();
                return Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4D4F),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
