import 'package:flutter/material.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_text.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.content,
    required this.mine,
    required this.sendAt,
  });

  final String content;
  final bool mine;
  final DateTime sendAt;

  String get _timeLabel {
    final h = sendAt.hour.toString().padLeft(2, '0');
    final m = sendAt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final bubbleColor = mine ? AppColors.primary : AppColors.surface;
    final textColor = mine ? Colors.white : AppColors.textPrimary;
    final timeColor = mine ? Colors.white70 : AppColors.textSecondary;

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(mine ? 16 : 4),
            bottomRight: Radius.circular(mine ? 4 : 16),
          ),
          border: mine ? null : Border.all(color: AppColors.divider),
          boxShadow: mine
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(content, color: textColor, fontSize: 14),
            const SizedBox(height: 4),
            AppText(_timeLabel, fontSize: 10, color: timeColor),
          ],
        ),
      ),
    );
  }
}
