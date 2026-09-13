import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/controller/demande_controller.dart';
import 'package:study_pair/models/demande_model.dart';
import 'package:study_pair/pages/dashboard/demandes/demandes_page.dart';

import '../../../../theme/app_colors.dart';

class RecentRequestsSection extends StatelessWidget {
  const RecentRequestsSection({super.key});

  DemandesController get _controller => Get.isRegistered<DemandesController>()
      ? Get.find<DemandesController>()
      : Get.put(DemandesController());

  void _openDemandes() {
    Get.to<void>(
      () => const DemandesPage(),
      binding: DemandesBinding(),
      preventDuplicates: true,
    );
  }

  static const _avatarColors = [
    Color(0xFFF59E0B),
    Color(0xFF3B82F6),
    Color(0xFF10B981),
    Color(0xFFEF4444),
    Color(0xFF8B5CF6),
  ];

  Color _colorFor(String seed) {
    if (seed.isEmpty) return _avatarColors.first;
    final index = seed.codeUnits.fold<int>(0, (a, b) => a + b) % _avatarColors.length;
    return _avatarColors[index];
  }

  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  String _helpTypeLabel(DemandeModel demande) {
    return demande.helpType == DemandeHelpType.mentorat ? 'Mentorat' : 'Binôme';
  }

  Color _helpTypeColor(DemandeModel demande) {
    return demande.helpType == DemandeHelpType.mentorat
        ? AppColors.info
        : AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final demandes = _controller.recentesEnAttente;
      final isLoading = _controller.isLoading.value;

      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Demandes récentes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: _openDemandes,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Voir en attente'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (demandes.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'Aucune demande en attente.',
                    style: TextStyle(fontSize: 13, color: AppColors.textTertiary),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: demandes.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final demande = demandes[index];
                  final user = _controller.userFor(demande);
                  final name = user?.displayName ?? 'Utilisateur';
                  final subtitle = [user?.university, user?.level]
                      .where((e) => e != null && e.isNotEmpty)
                      .join(' · ');

                  return Material(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: _openDemandes,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: _colorFor(user?.id ?? demande.senderId),
                              backgroundImage: user?.photoUrl != null
                                  ? NetworkImage(user!.photoUrl!)
                                  : null,
                              child: user?.photoUrl == null
                                  ? Text(
                                      _initials(name),
                                      style: const TextStyle(
                                        color: AppColors.textOnPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    subtitle.isEmpty ? demande.subject : subtitle,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textTertiary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        _helpTypeLabel(demande),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: _helpTypeColor(demande),
                                        ),
                                      ),
                                      Text(
                                        ' • ${demande.tempsEcouleLabel}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Material(
                              color: AppColors.surfaceAlt,
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                onTap: _openDemandes,
                                borderRadius: BorderRadius.circular(12),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    'Voir',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      );
    });
  }
}