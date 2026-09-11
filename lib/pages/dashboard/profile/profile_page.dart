import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:study_pair/pages/dashboard/profile/widgets/profile_expertise.dart';
import 'package:study_pair/pages/dashboard/profile/widgets/profile_header.dart';
import 'package:study_pair/pages/dashboard/profile/widgets/profile_settings_list.dart';
import 'package:study_pair/pages/dashboard/profile/widgets/profile_stats.dart';
import 'package:study_pair/widgets/app_button.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/gap.dart';

import '../../../models/user_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/user_service.dart';
import '../../../widgets/app_popup.dart';
import '../../../widgets/loading_view.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _users = Get.find<UserService>();
  final _auth = Get.find<AuthService>();

  UserModel? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);

    try {
      final user = await _users.getMe();
      _user = user;
    } catch (e) {
      final fallback = _auth.user.value;

      if (fallback != null) {
        _user = fallback;
      } else {
        Get.snackbar('Erreur', e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _logout() async {
    final ok = await showAppConfirmDialog(
      context: context,
      title: 'Déconnexion',
      message: 'Voulez-vous vraiment vous déconnecter ?',
      confirmLabel: 'Se déconnecter',
      isDestructive: true,
    );

    if (ok != true) return;

    await _auth.signOut();
    Get.offAllNamed(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        body: LoadingView(message: 'Chargement du profil…'),
      );
    }

    final user = _user;

    // Valeurs par défaut si l'utilisateur est nul
    final name = user?.displayName ?? 'Sarah Legrand';

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
              // En-tête
              ProfileHeader(
                userName: name,
                userImageUrl: user?.photoUrl,
                onNotificationTap: () {},
              ),

              VGap.xl(),

              // Avatar principal et badge de disponibilité
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
                          user?.photoUrl ?? 'https://i.pravatar.cc/150?img=47',
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

              // Nom et titre
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

              // Badge "Disponible pour mentorat"
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

              // Statistiques
              const ProfileStats(rating: '4.9', hours: '28h', mentees: '3/5'),

              VGap.xl(),

              // Expertise
              ProfileExpertise(
                skills: expertise,
                onEdit: () {
                  // Action pour modifier les compétences
                },
              ),

              VGap.xl(),

              // Disponibilités et compte & préférences
              ProfileSettingsList(
                onAvailabilityTap: () {},
                onDiplomaTap: () {},
                onNotificationsTap: () {},
                onPrivacyTap: () {},
              ),

              VGap.xl(),

              // Déconnexion
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Se déconnecter',
                  variant: AppButtonVariant.danger,
                  backgroundColor: Colors.white,
                  textColor: const Color(0xFFEF4444),
                  icon: Icons.logout_rounded,
                  onPressed: _logout,
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
  }
}
