import 'package:flutter/material.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/gap.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.label,
    this.showAvatar = true,
    this.avatarUrl,
    this.hasUnreadNotifications = false,
    this.onNotificationsTap,
    this.onAvatarTap,
    this.icon = Icons.school_outlined,
  });

  static const double height = 80;

  final String label;
  final bool showAvatar;

  final String? avatarUrl;
  final bool hasUnreadNotifications;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onAvatarTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const HGap.sm(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  'StudyPair',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
                AppText(label, fontSize: 12, color: AppColors.textSecondary),
              ],
            ),
          ),
          _NotificationButton(
            hasUnread: hasUnreadNotifications,
            onTap: onNotificationsTap,
          ),
          if (showAvatar) ...[
            const HGap.sm(),
            GestureDetector(
              onTap: onAvatarTap,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.border,
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl!)
                    : null,
                child: avatarUrl == null
                    ? const Icon(
                        Icons.person,
                        size: 20,
                        color: AppColors.textSecondary,
                      )
                    : null,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AppHeaderDelegate extends SliverPersistentHeaderDelegate {
  const AppHeaderDelegate({
    this.heroTag = 'demandes-header',
    this.imageAsset = 'assets/images/screen-removebg-preview.png',
    this.title = 'StudyPair',
    this.subtitle = 'Créneaux & disponibilités',
    this.showBackButton = true,
  });

  final String heroTag;
  final String imageAsset;
  final String title;
  final String subtitle;
  final bool showBackButton;

  static const double _maxExtent = 300;
  static const double _minExtent = 150;
  static const double _sheetHandleHeight = 25;

  @override
  double get maxExtent => _maxExtent;

  @override
  double get minExtent => _minExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    return ColoredBox(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Hero(
              tag: heroTag,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
                child: Opacity(
                  opacity: 1 - (progress * 0.35),
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: _sheetHandleHeight + 16,
            child: Opacity(
              opacity: (1 - progress).clamp(0.0, 1.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textOnPrimary,
                  ),
                  const VGap.xs(),
                  AppText(
                    subtitle,
                    fontSize: 13,
                    color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                  ),
                ],
              ),
            ),
          ),
          if (showBackButton)
            Positioned(
              top: topPadding + 10,
              left: 10,
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: _sheetHandleHeight,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Center(
                child: Container(
                  height: 5,
                  width: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant AppHeaderDelegate oldDelegate) {
    return heroTag != oldDelegate.heroTag ||
        imageAsset != oldDelegate.imageAsset ||
        title != oldDelegate.title ||
        subtitle != oldDelegate.subtitle ||
        showBackButton != oldDelegate.showBackButton;
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({required this.hasUnread, this.onTap});

  final bool hasUnread;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
          if (hasUnread)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8455A),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
