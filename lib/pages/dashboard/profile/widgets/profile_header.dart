import 'package:flutter/material.dart';

import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/gap.dart';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String? userImageUrl;
  final VoidCallback onNotificationTap;

  const ProfileHeader({
    super.key,
    required this.userName,
    this.userImageUrl,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 16),
            ),

            HGap.sm(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  'STUDYPAIR',
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF4F46E5),
                ),
                AppText(
                  'Profil',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ],
            ),
          ],
        ),

        Row(
          children: [
            IconButton(
              onPressed: onNotificationTap,
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF1F2937),
              ),
            ),

            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    userImageUrl ?? 'https://i.pravatar.cc/150?img=47',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
