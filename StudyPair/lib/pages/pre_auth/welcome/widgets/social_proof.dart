import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';

class SocialProof extends StatelessWidget {
  const SocialProof({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Groupe d'avatars superposés
        SizedBox(
          width: 80,
          height: 32,
          child: Stack(
            children: [
              _buildAvatar('https://i.pravatar.cc/100?img=1', 0),
              _buildAvatar('https://i.pravatar.cc/100?img=2', 20),
              _buildAvatar('https://i.pravatar.cc/100?img=3', 40),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Texte de preuve sociale
        Expanded(
          child: Text(
            '+3 200 binômes actifs dans 45+ universités',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(String url, double left) {
    return Positioned(
      left: left,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
