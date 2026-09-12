import 'package:flutter/material.dart';

import 'package:study_pair/models/demande_model.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_button.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/gap.dart';

class DemandeCard extends StatelessWidget {
  const DemandeCard({
    super.key,
    required this.demande,
    this.nomUtilisateur,
    this.sousTitreUtilisateur,
    this.avatarUrl,
    this.onAccepter,
    this.onDecliner,
  });

  final DemandeModel demande;

  /// Informations provenant du profil de l'utilisateur.
  final String? nomUtilisateur;
  final String? sousTitreUtilisateur;
  final String? avatarUrl;

  final VoidCallback? onAccepter;
  final VoidCallback? onDecliner;

  @override
  Widget build(BuildContext context) {
    final estEnvoyee = demande.estEnvoyeePar(demande.senderId);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EnTete(
            demande: demande,
            nomUtilisateur: nomUtilisateur,
            sousTitreUtilisateur: sousTitreUtilisateur,
            avatarUrl: avatarUrl,
          ),

          const VGap.sm(),

          _Tags(demande: demande),

          const VGap.md(),

          _MessageCitation(message: demande.message),

          const VGap.md(),

          _InfoLigne(demande: demande),

          const VGap.md(),

          if (estEnvoyee)
            _StatutEnvoi(statut: demande.status)
          else if (demande.estEnAttente)
            _Actions(onAccepter: onAccepter, onDecliner: onDecliner)
          else
            _StatutEnvoi(statut: demande.status),
        ],
      ),
    );
  }
}

class _EnTete extends StatelessWidget {
  const _EnTete({
    required this.demande,
    this.nomUtilisateur,
    this.sousTitreUtilisateur,
    this.avatarUrl,
  });

  final DemandeModel demande;
  final String? nomUtilisateur;
  final String? sousTitreUtilisateur;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.background,
          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
          child: avatarUrl == null
              ? const Icon(Icons.person_outline, color: AppColors.textSecondary)
              : null,
        ),

        const HGap.sm(),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                nomUtilisateur ?? 'Utilisateur',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),

              if (sousTitreUtilisateur != null) ...[
                const VGap.xs(),
                AppText(
                  sousTitreUtilisateur!,
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ],
            ],
          ),
        ),

        if (demande.createdAt != null)
          AppText(
            demande.tempsEcouleLabel,
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
      ],
    );
  }
}

class _Tags extends StatelessWidget {
  const _Tags({required this.demande});

  final DemandeModel demande;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _TagChip(
          label: demande.helpType == DemandeHelpType.mentorat
              ? 'Mentorat'
              : 'Binôme',
        ),
        _TagChip(
          label: demande.mode == DemandeMode.visio
              ? 'Visioconférence'
              : 'Présentiel',
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppText(
        label,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _MessageCitation extends StatelessWidget {
  const _MessageCitation({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: AppText(
        '« $message »',
        fontSize: 14,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _InfoLigne extends StatelessWidget {
  const _InfoLigne({required this.demande});

  final DemandeModel demande;

  @override
  Widget build(BuildContext context) {
    final icon = demande.mode == DemandeMode.visio
        ? Icons.videocam_outlined
        : Icons.location_on_outlined;

    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),

        const HGap.xs(),

        Expanded(
          child: AppText(
            '${demande.slotLabel} • ${demande.location}',
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({this.onAccepter, this.onDecliner});

  final VoidCallback? onAccepter;
  final VoidCallback? onDecliner;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: 'Décliner',
            icon: Icons.close,
            variant: AppButtonVariant.secondary,
            onPressed: onDecliner,
          ),
        ),

        const HGap.sm(),

        Expanded(
          child: AppButton(
            label: 'Accepter',
            icon: Icons.check,
            variant: AppButtonVariant.primary,
            onPressed: onAccepter,
          ),
        ),
      ],
    );
  }
}

class _StatutEnvoi extends StatelessWidget {
  const _StatutEnvoi({required this.statut});

  final String statut;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: AppText(
        _labelStatut(statut),
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }

  String _labelStatut(String statut) {
    switch (statut) {
      case DemandeStatus.accepted:
        return 'Demande acceptée';

      case DemandeStatus.declined:
        return 'Demande refusée';

      case DemandeStatus.expired:
        return 'Demande expirée';

      case DemandeStatus.pending:
      default:
        return 'En attente de réponse';
    }
  }
}
