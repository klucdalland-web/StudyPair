import 'package:flutter/material.dart';
import 'package:study_pair/models/user_model.dart';
import 'package:study_pair/pages/dashboard/match/widgets/match_profile_sheet.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_avatar.dart';
import 'package:study_pair/widgets/app_text.dart';

class MeilleuresCorrespondancesSection extends StatelessWidget {
  const MeilleuresCorrespondancesSection({
    super.key,
    required this.users,
    required this.onProposer,
  });

  final List<UserModel> users;
  final void Function(UserModel user, {String message}) onProposer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                users.isEmpty
                    ? 'Aucun profil'
                    : '${users.length} profil${users.length > 1 ? 's' : ''}',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              const AppText(
                'Tous les users',
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
        if (users.isEmpty)
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 40),
            child: Center(
              child: AppText(
                'Aucun autre utilisateur pour le moment.',
                color: AppColors.textSecondary,
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ProfilMatchCard(
                user: user,
                onProposer: (message) => onProposer(user, message: message),
              );
            },
          ),
      ],
    );
  }
}

class ProfilMatchCard extends StatefulWidget {
  const ProfilMatchCard({
    super.key,
    required this.user,
    required this.onProposer,
  });

  final UserModel user;
  final ValueChanged<String> onProposer;

  @override
  State<ProfilMatchCard> createState() => _ProfilMatchCardState();
}

class _ProfilMatchCardState extends State<ProfilMatchCard> {
  bool estFavoris = false;

  String get _statut {
    final parts = [
      if (widget.user.level?.isNotEmpty == true) widget.user.level!,
      if (widget.user.university?.isNotEmpty == true) widget.user.university!,
    ];
    if (parts.isNotEmpty) return parts.join(' • ');
    return widget.user.isStudent ? 'Étudiant' : 'Mentor';
  }

  String get _description {
    final bio = widget.user.bio?.trim();
    if (bio != null && bio.isNotEmpty) return bio;
    if (widget.user.subjects.isNotEmpty) {
      return 'Intéressé par ${widget.user.subjects.take(3).join(', ')}';
    }
    return 'Membre StudyPair';
  }

  void _openProfileSheet() {
    showMatchProfileSheet(
      context: context,
      nom: widget.user.displayName.isEmpty
          ? 'Anonyme'
          : widget.user.displayName,
      affinite: widget.user.isOnline ? 'En ligne' : 'Hors ligne',
      statut: _statut,
      description: _description,
      competences: widget.user.subjects,
      photoUrl: widget.user.photoUrl,
      onProposer: widget.onProposer,
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.user.displayName.isEmpty
        ? 'Anonyme'
        : widget.user.displayName;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: _openProfileSheet,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.015),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                AppAvatar(
                  imageUrl: widget.user.photoUrl,
                  name: name,
                  size: 44,
                  online: widget.user.isOnline,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        name,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      AppText(
                        _statut,
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() => estFavoris = !estFavoris);
                  },
                  icon: Icon(
                    estFavoris ? Icons.favorite : Icons.favorite_border,
                    color: estFavoris ? Colors.red : Colors.grey.shade400,
                    size: 22,
                  ),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
