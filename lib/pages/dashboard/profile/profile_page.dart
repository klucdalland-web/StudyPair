import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/controller/profile_controller.dart';

import 'package:study_pair/pages/dashboard/profile/widgets/profile_expertise.dart';
import 'package:study_pair/pages/dashboard/profile/widgets/profile_settings_list.dart';
import 'package:study_pair/pages/dashboard/profile/widgets/profile_stats.dart';

import 'package:study_pair/widgets/app_button.dart';
import 'package:study_pair/widgets/app_header.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/gap.dart';
import 'package:study_pair/widgets/app_popup.dart';
import 'package:study_pair/widgets/loading_view.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          backgroundColor: Color(0xFFF8F9FA),
          body: LoadingView(message: 'Chargement du profil…'),
        );
      }
      final user = controller.user.value;
      final name = user?.displayName ?? 'Anonyme';
      final title =
          user?.level ?? 'Data Engineer chez Doctolib • Mentor Sorbonne';
      final expertise =
          user?.subjects ??
          [
            'Intelligence Artificielle',
            'Python & PyTorch',
            'Relecture Master & CV',
          ];

      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppHeader(
                  label: 'Profil',
                  showAvatar: false,
                  onNotificationsTap: () {},
                ),

                VGap.xl(),

                Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(
                            user?.photoUrl ??
                                'https://i.pravatar.cc/150?img=47',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                      ),
                    ),
                  ],
                ),

                VGap.md(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      name,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                    HGap.sm(),
                    const Icon(
                      Icons.settings,
                      size: 20,
                      color: Color(0xFF6B7280),
                    ),
                  ],
                ),

                VGap.sm(),

                AppText(
                  title,
                  fontSize: 14,
                  color: const Color(0xFF6B7280),
                  textAlign: TextAlign.center,
                ),

                VGap.md(),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E7FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      HGap.sm(),
                      const AppText(
                        'Disponible pour mentorat',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4F46E5),
                      ),
                    ],
                  ),
                ),

                VGap.xl(),

                const ProfileStats(rating: '4.9', hours: '28h', mentees: '3/5'),

                VGap.xl(),

                ProfileExpertise(skills: expertise, onEdit: () {}),

                VGap.xl(),

                ProfileSettingsList(
                  onAvailabilityTap: () {},
                  onDiplomaTap: () {},
                  onNotificationsTap: () {},
                  onPrivacyTap: () {},
                ),

                VGap.xl(),

                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: 'Se déconnecter',
                    variant: AppButtonVariant.danger,
                    backgroundColor: Colors.white,
                    textColor: const Color(0xFFEF4444),
                    icon: Icons.logout_rounded,
                    onPressed: () => _handleLogout(context),
                  ),
                ),

                VGap.md(),

                const AppText(
                  'StudyPair v2.4.1',
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                ),

                VGap.xxl(),
              ],
            ),
          ),
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
