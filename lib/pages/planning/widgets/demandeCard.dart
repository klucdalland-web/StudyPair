import 'package:flutter/material.dart';
import '../../../models/demande_model.dart';
import '../planning_fake_data/fetch_fake_planning_data.dart';
import '../../../theme/app_colors.dart';
import 'badge.dart' as badge;
class DemandeCard extends StatelessWidget {
  const DemandeCard({
    super.key,
    required this.demande,
    required this.onAccepter,
    required this.onDecliner,
    this.sender,
  });

  final DemandeModel demande;
  final SenderDisplay? sender;
  final VoidCallback onAccepter;
  final VoidCallback onDecliner;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.badgeBlueBg,
                child: Text(
                  sender?.initials ?? '?',
                  style: const TextStyle(
                    color: AppColors.badgeBlueText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sender?.name ?? demande.senderId,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    if (sender != null)
                      Text(
                        sender!.program,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                demande.tempsEcouleLabel,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              badge.Badge(
                icon: Icons.hub_outlined,
                label: demande.subject,
                bg: const Color(0xFFEEEDFE),
                fg: const Color(0xFF3C3489),
              ),
              badge.Badge(
                icon: demande.helpType == DemandeHelpType.mentorat
                    ? Icons.school_outlined
                    : Icons.groups_outlined,
                label: demande.helpType == DemandeHelpType.mentorat ? 'Mentorat' : 'Binôme',
                bg: demande.helpType == DemandeHelpType.mentorat
                    ? AppColors.badgeBlueBg
                    : AppColors.badgeGreenBg,
                fg: demande.helpType == DemandeHelpType.mentorat
                    ? AppColors.badgeBlueText
                    : AppColors.badgeGreenText,
              ),
              if (demande.estDeclinee)
                const badge.Badge(
                  icon: Icons.close,
                  label: 'Déclinée',
                  bg: Color(0xFFFCEBEB),
                  fg: Color(0xFF791F1F),
                ),
              if (demande.estAcceptee)
                const badge.Badge(
                  icon: Icons.check,
                  label: 'Acceptée',
                  bg: AppColors.badgeGreenBg,
                  fg: AppColors.badgeGreenText,
                ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bgQuote,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              demande.message,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 13.5,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                demande.mode == DemandeMode.visio ? Icons.videocam_outlined : Icons.school_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${demande.slotLabel} • ${demande.location}',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          if (demande.estEnAttente) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDecliner,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      side: BorderSide(color: Colors.black.withOpacity(0.08)),
                    ),
                    child: const Text('Décliner', style: TextStyle(color: AppColors.textPrimary)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccepter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Accepter'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
