import 'package:flutter/material.dart';
import 'package:study_pair/models/chat_model.dart';
import 'package:study_pair/models/user_model.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_avatar.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/gap.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.chat,
    required this.user,
    this.onTap,
  });

  final ChatModel chat;
  final UserModel user;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final preview = chat.lastMessage?.trim().isNotEmpty == true
        ? chat.lastMessage!
        : (user.level ?? 'Nouvelle conversation');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            children: [
              AppAvatar(
                imageUrl: user.photoUrl,
                name: user.displayName,
                size: 52,
                online: user.isOnline,
              ),
              const HGap.md(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppText(
                            user.displayName.isEmpty
                                ? 'Utilisateur'
                                : user.displayName,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (chat.lastMessageAt != null)
                          AppText(
                            _formatTime(chat.lastMessageAt!),
                            fontSize: 12,
                            color: AppColors.textTertiary,
                          ),
                      ],
                    ),
                    const VGap.xs(),
                    AppText(
                      preview,
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const HGap.sm(),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final sameDay =
        date.year == now.year && date.month == now.month && date.day == now.day;
    if (sameDay) {
      final h = date.hour.toString().padLeft(2, '0');
      final m = date.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }
}
