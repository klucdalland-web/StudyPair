import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/widgets/app_scaffold.dart';

import '../../../theme/app_colors.dart';
import '../../../widgets/app_platform.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/gap.dart';
import '../../../services/notification_service.dart';
import '../../../controller/notification_controller.dart';
import 'widgets/notification_tile.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsService>(() => NotificationsService());
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(Get.find<NotificationsService>()),
    );
  }
}

class NotificationsPage extends GetView<NotificationsController> {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Header(),
            const VGap.md(),
            Expanded(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.notifications.isEmpty) {
                    return const _EmptyState();
                  }
                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: controller.refresh,
                    child: ListView.separated(
                      physics: AppPlatform.scrollPhysics,
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                      itemCount: controller.notifications.length,
                      separatorBuilder: (_, _) => const VGap.sm(),
                      itemBuilder: (context, index) {
                        final notification = controller.notifications[index];
                        return NotificationTile(
                          notification: notification,
                          onTap: () => controller.markAsRead(notification),
                        );
                      },
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends GetView<NotificationsController> {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 20, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: Get.back,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textOnPrimary,
            ),
          ),
          Expanded(
            child: AppText(
              'Notifications',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textOnPrimary,
            ),
          ),
          Obx(() {
            if (controller.unreadCount == 0) return const SizedBox.shrink();
            return TextButton(
              onPressed: controller.markAllAsRead,
              child: AppText(
                'Tout marquer comme lu',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textOnPrimary,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 34,
                color: AppColors.primary,
              ),
            ),
            const VGap.md(),
            AppText(
              'Aucune notification pour le moment',
              textAlign: TextAlign.center,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}
