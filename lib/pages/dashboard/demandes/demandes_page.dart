import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:study_pair/controller/demande_controller.dart';
import 'package:study_pair/pages/dashboard/demandes/widgets/demande_card.dart';
import 'package:study_pair/pages/dashboard/demandes/widgets/demande_footer_note.dart';
import 'package:study_pair/pages/dashboard/demandes/widgets/demande_tab_selector.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_header.dart';
import 'package:study_pair/widgets/app_platform.dart';
import 'package:study_pair/widgets/app_scaffold.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/gap.dart';
import 'package:study_pair/widgets/loading_view.dart';

class DemandesPage extends GetView<DemandesController> {
  const DemandesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          backgroundColor: Color(0xFFF8F9FA),
          body: LoadingView(message: 'Chargement du profil…'),
        );
      }

      return AppScaffold(
        backgroundColor: AppColors.background,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppHeader(
              label: 'Créneaux & disponibilités',
              avatarUrl: controller.user.value?['photoUrl'] as String?,
              hasUnreadNotifications: controller.hasUnreadNotifications,
              onNotificationsTap: controller.onNotificationsTap,
              onAvatarTap: controller.onAvatarTap,
            ),
            Expanded(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  physics: AppPlatform.scrollPhysics,
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                  child: Obx(() => _buildContenu(controller)),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildContenu(DemandesController controller) {
    final estOngletRecues = controller.selectedTabIndex.value == 0;

    final demandes = estOngletRecues
        ? controller.demandesRecues
        : controller.demandesEnvoyees;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitreSection(nombreActives: controller.nombreDemandesActives),
        const VGap.lg(),
        DemandesTabSelector(
          selectedIndex: controller.selectedTabIndex.value,
          recuesCount: controller.demandesRecues.length,
          envoyeesCount: controller.demandesEnvoyees.length,
          onChanged: controller.selectTab,
        ),
        const VGap.lg(),
        if (demandes.isEmpty)
          const _AucuneDemande()
        else
          ...demandes.map(
            (demande) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DemandeCard(
                demande: demande,
                onAccepter: () => controller.accepterDemande(demande.id),
                onDecliner: () => controller.declinerDemande(demande.id),
              ),
            ),
          ),
        const VGap.sm(),
        const DemandesFooterNote(),
      ],
    );
  }
}

class _TitreSection extends StatelessWidget {
  const _TitreSection({required this.nombreActives});

  final int nombreActives;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              const AppText(
                'Demandes',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              _ActiveBadge(count: nombreActives),
            ],
          ),
        ),
        const AppText(
          'Tutorat & Binômes',
          fontSize: 13,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppText(
        '$count actives',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),
    );
  }
}

class _AucuneDemande extends StatelessWidget {
  const _AucuneDemande();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: AppText(
          'Aucune demande pour le moment.',
          color: AppColors.textSecondary,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
