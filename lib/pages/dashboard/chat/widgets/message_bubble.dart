import 'package:flutter/material.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/theme/app_radii.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/gap.dart';

import '../utils/date_formater.dart';

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

  @override
  Widget build(BuildContext context) {
    final bg = mine ? AppColors.primary : AppColors.chatIncoming;
    final fg = mine ? AppColors.textOnPrimary : AppColors.textPrimary;
    final timeFg = mine
        ? AppColors.textOnPrimary.withValues(alpha: 0.75)
        : AppColors.textTertiary;

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(AppRadii.lg),
              topRight: const Radius.circular(AppRadii.lg),
              bottomLeft: Radius.circular(mine ? AppRadii.lg : AppRadii.xs),
              bottomRight: Radius.circular(mine ? AppRadii.xs : AppRadii.lg),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              AppText(
                content,
                color: fg,
                fontSize: 14,
                height: 1.35,
              ),
              const VGap.xs(),
              AppText(
                formatMessageDate(sendAt),
                fontSize: 11,
                color: timeFg,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
