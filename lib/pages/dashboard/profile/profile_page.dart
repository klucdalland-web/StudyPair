import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/controller/profile_controller.dart';
import 'package:study_pair/models/user_model.dart';
import 'package:study_pair/pages/dashboard/profile/widgets/profile_expertise.dart';
import 'package:study_pair/pages/dashboard/profile/widgets/profile_settings_list.dart';
import 'package:study_pair/pages/dashboard/profile/widgets/profile_stats.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_avatar.dart';
import 'package:study_pair/widgets/app_button.dart';
import 'package:study_pair/widgets/app_chip.dart';
import 'package:study_pair/widgets/app_header.dart';
import 'package:study_pair/widgets/app_platform.dart';
import 'package:study_pair/widgets/app_popup.dart';
import 'package:study_pair/widgets/app_scaffold.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/gap.dart';
import 'package:study_pair/widgets/loading_view.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          backgroundColor: AppColors.background,
          body: LoadingView(message: 'Chargement du profil…'),
        );
      }

      final user = controller.user.value;

      return AppScaffold(
        backgroundColor: Colors.white,
        safeTop: false,
        body: CustomScrollView(
          physics: AppPlatform.scrollPhysics,
          slivers: [
            const SliverPersistentHeader(
              pinned: true,
              delegate: AppHeaderDelegate(
                heroTag: 'profile-header',
                title: 'StudyPair',
                subtitle: 'Profil',
              ),
            ),
            SliverProfileBody(
              user: user,
              onLogout: () => _handleLogout(context),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _handleLogout(BuildContext context) async {
    final ok = await showAppConfirmDialog(
      context: context,
      title: 'Déconnexion',
      message: 'Voulez-vous vraiment vous déconnecter ?',
      confirmLabel: 'Se déconnecter',
      isDestructive: true,
    );

    if (ok != true) return;
    await controller.logout();
  }
}

class SliverProfileBody extends StatelessWidget {
  const SliverProfileBody({
    super.key,
    required this.user,
    required this.onLogout,
  });

  final UserModel? user;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final name = user?.displayName.trim().isNotEmpty == true
        ? user!.displayName
        : 'Anonyme';
    final subtitle = [
      if (user?.level?.isNotEmpty == true) user!.level!,
      if (user?.university?.isNotEmpty == true) user!.university!,
    ].join(' • ');
    final expertise = user?.subjects.isNotEmpty == true
        ? user!.subjects
        : const <String>[
            'Intelligence Artificielle',
            'Python & PyTorch',
            'Relecture Master & CV',
          ];

    return SliverToBoxAdapter(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 480;
          final horizontal = wide ? 32.0 : 20.0;

          return Padding(
            padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileIdentity(
                  name: name,
                  subtitle: subtitle.isEmpty
                      ? 'Membre StudyPair'
                      : subtitle,
                  photoUrl: user?.photoUrl,
                  isOnline: user?.isOnline ?? false,
                  isStudent: user?.isStudent ?? true,
                ),
                const VGap.xl(),
                const ProfileStats(
                  rating: '4.9',
                  hours: '28h',
                  mentees: '3/5',
                ),
                const VGap.xl(),
                ProfileExpertise(skills: expertise, onEdit: () {}),
                const VGap.xl(),
                ProfileSettingsList(
                  onAvailabilityTap: () {},
                  onDiplomaTap: () {},
                  onNotificationsTap: () {},
                  onPrivacyTap: () {},
                ),
                const VGap.xl(),
                AppButton(
                  label: 'Se déconnecter',
                  variant: AppButtonVariant.danger,
                  backgroundColor: AppColors.surface,
                  textColor: AppColors.danger,
                  icon: Icons.logout_rounded,
                  onPressed: onLogout,
                ),
                const VGap.md(),
                const Center(
                  child: AppText(
                    'StudyPair v2.4.1',
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
                const VGap.lg(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileIdentity extends StatelessWidget {
  const _ProfileIdentity({
    required this.name,
    required this.subtitle,
    required this.photoUrl,
    required this.isOnline,
    required this.isStudent,
  });

  final String name;
  final String subtitle;
  final String? photoUrl;
  final bool isOnline;
  final bool isStudent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppAvatar(
          imageUrl: photoUrl,
          name: name,
          size: 96,
          online: isOnline,
        ),
        const VGap.md(),
        AppText(
          name,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          textAlign: TextAlign.center,
        ),
        const VGap.sm(),
        AppText(
          subtitle,
          fontSize: 14,
          color: AppColors.textSecondary,
          textAlign: TextAlign.center,
        ),
        const VGap.md(),
        AppChip(
          label: isStudent
              ? 'Disponible pour binôme'
              : 'Disponible pour mentorat',
          selected: true,
          leading: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.online,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
