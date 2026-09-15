import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/user_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/user_service.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/app_avatar.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_chip.dart';
import '../../../widgets/app_platform.dart';
import '../../../widgets/app_popup.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/gap.dart';
import '../../../widgets/loading_view.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _users = Get.find<UserService>();
  final _auth = Get.find<AuthService>();

  final _name = TextEditingController();
  final _bio = TextEditingController();
  final _university = TextEditingController();
  final _level = TextEditingController();
  final _subjects = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  UserModel? _user;
  bool _loading = true;
  bool _saving = false;
  bool _editing = false;

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
      _fillFields(user);
    } catch (e) {
      final fallback = _auth.user.value;
      if (fallback != null) {
        _user = fallback;
        _fillFields(fallback);
      } else {
        Get.snackbar('Erreur', e.toString());
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _fillFields(UserModel user) {
    _name.text = user.displayName;
    _bio.text = user.bio ?? '';
    _university.text = user.university ?? '';
    _level.text = user.level ?? '';
    _subjects.text = user.subjects.join(', ');
  }

  Future<void> _save() async {
    if (_user == null) return;
    if (!(_formKey.currentState?.validate() ?? true)) return;

    setState(() => _saving = true);
    try {
      final subjects = _subjects.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final updated = _user!.copyWith(
        displayName: _name.text.trim(),
        bio: _bio.text.trim(),
        university: _university.text.trim(),
        level: _level.text.trim(),
        subjects: subjects,
      );

      await _users.updateMe(updated);
      _user = updated;
      if (mounted) {
        setState(() => _editing = false);
        Get.snackbar('OK', 'Profil mis à jour');
      }
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _cancelEdit() {
    if (_user != null) _fillFields(_user!);
    setState(() => _editing = false);
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
  void dispose() {
    _name.dispose();
    _bio.dispose();
    _university.dispose();
    _level.dispose();
    _subjects.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;

    return AppScaffold(
      backgroundColor: AppColors.primary,
      safeTop: true,
      safeBottom: true,
      body: _loading
          ? const ColoredBox(
              color: AppColors.surface,
              child: LoadingView(message: 'Chargement du profil…'),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileHeader(
                  user: user,
                  editing: _editing,
                  onBack: () => Get.back(),
                  onEdit: () => setState(() => _editing = true),
                  onCancel: _cancelEdit,
                ),
                Expanded(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: AppPlatform.scrollPhysics,
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (_editing) ...[
                              _EditForm(
                                name: _name,
                                university: _university,
                                level: _level,
                                subjects: _subjects,
                                bio: _bio,
                              ),
                              const VGap.xl(),
                              AppButton(
                                label: 'Enregistrer',
                                loading: _saving,
                                onPressed: _save,
                              ),
                            ] else ...[
                              _ProfileSummary(user: user),
                              const VGap.lg(),
                              _InfoCard(user: user),
                              const VGap.lg(),
                              _SubjectsCard(subjects: user?.subjects ?? const []),
                              const VGap.lg(),
                              if ((user?.bio ?? '').trim().isNotEmpty)
                                _BioCard(bio: user!.bio!.trim()),
                              if ((user?.bio ?? '').trim().isNotEmpty)
                                const VGap.lg(),
                              AppCard(
                                onTap: _logout,
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.logout_rounded,
                                      color: AppColors.danger,
                                    ),
                                    HGap.md(),
                                    Expanded(
                                      child: Text(
                                        'Se déconnecter',
                                        style: TextStyle(
                                          color: AppColors.danger,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: AppColors.danger,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.user,
    required this.editing,
    required this.onBack,
    required this.onEdit,
    required this.onCancel,
  });

  final UserModel? user;
  final bool editing;
  final VoidCallback onBack;
  final VoidCallback onEdit;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final name = (user?.displayName.trim().isNotEmpty ?? false)
        ? user!.displayName.trim()
        : 'Mon profil';

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 20),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textOnPrimary,
                  size: 20,
                ),
              ),
              const Expanded(
                child: Text(
                  'Profil',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                onPressed: editing ? onCancel : onEdit,
                icon: Icon(
                  editing ? Icons.close_rounded : Icons.edit_rounded,
                  color: AppColors.textOnPrimary,
                ),
              ),
            ],
          ),
          const VGap.md(),
          AppAvatar(
            imageUrl: user?.photoUrl,
            name: name,
            size: 84,
          ),
          const VGap.md(),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textOnPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          if ((user?.email ?? '').isNotEmpty) ...[
            const VGap.sm(),
            Text(
              user!.email,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textOnPrimary.withValues(alpha: 0.85),
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  const _ProfileSummary({required this.user});

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    final university = (user?.university ?? '').trim();
    final level = (user?.level ?? '').trim();
    final subtitle = [
      if (level.isNotEmpty) level,
      if (university.isNotEmpty) university,
    ].join(' • ');

    if (subtitle.isEmpty) {
      return const AppSoftCard(
        child: Text(
          'Complète ton profil pour trouver de meilleurs binômes.',
          style: TextStyle(color: AppColors.primary),
        ),
      );
    }

    return AppSoftCard(
      child: Row(
        children: [
          const Icon(Icons.school_rounded, color: AppColors.primary),
          const HGap.md(),
          Expanded(
            child: Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.user});

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const VGap.md(),
          _InfoRow(
            icon: Icons.badge_outlined,
            label: 'Nom',
            value: (user?.displayName.trim().isNotEmpty ?? false)
                ? user!.displayName
                : 'Non renseigné',
          ),
          const Divider(height: 24),
          _InfoRow(
            icon: Icons.account_balance_outlined,
            label: 'Université',
            value: (user?.university ?? '').trim().isNotEmpty
                ? user!.university!
                : 'Non renseignée',
          ),
          const Divider(height: 24),
          _InfoRow(
            icon: Icons.menu_book_outlined,
            label: 'Niveau',
            value: (user?.level ?? '').trim().isNotEmpty
                ? user!.level!
                : 'Non renseigné',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const HGap.md(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SubjectsCard extends StatelessWidget {
  const _SubjectsCard({required this.subjects});

  final List<String> subjects;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Matières',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const VGap.md(),
          if (subjects.isEmpty)
            const Text(
              'Aucune matière renseignée',
              style: TextStyle(color: AppColors.textSecondary),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: subjects
                  .map((subject) => AppChip(label: subject))
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _BioCard extends StatelessWidget {
  const _BioCard({required this.bio});

  final String bio;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'À propos',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const VGap.md(),
          Text(
            bio,
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _EditForm extends StatelessWidget {
  const _EditForm({
    required this.name,
    required this.university,
    required this.level,
    required this.subjects,
    required this.bio,
  });

  final TextEditingController name;
  final TextEditingController university;
  final TextEditingController level;
  final TextEditingController subjects;
  final TextEditingController bio;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          controller: name,
          label: 'Nom',
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(Icons.badge_outlined),
          validator: (value) {
            if ((value ?? '').trim().isEmpty) return 'Nom requis';
            return null;
          },
        ),
        const VGap.md(),
        AppTextField(
          controller: university,
          label: 'Université',
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(Icons.account_balance_outlined),
        ),
        const VGap.md(),
        AppTextField(
          controller: level,
          label: 'Niveau',
          hint: 'L1, L2, M1…',
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(Icons.menu_book_outlined),
        ),
        const VGap.md(),
        AppTextField(
          controller: subjects,
          label: 'Matières',
          hint: 'Maths, Algo, Stats…',
          textInputAction: TextInputAction.next,
          prefixIcon: const Icon(Icons.topic_outlined),
        ),
        const VGap.md(),
        AppTextField(
          controller: bio,
          label: 'Bio',
          hint: 'Parle un peu de toi et de ce que tu cherches',
          maxLines: 4,
          textInputAction: TextInputAction.done,
          prefixIcon: const Icon(Icons.notes_outlined),
        ),
      ],
    );
  }
}
