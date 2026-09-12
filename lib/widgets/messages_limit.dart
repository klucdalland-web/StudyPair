import 'package:flutter/material.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_section.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/gap.dart';

class MessageLimit extends StatelessWidget {
  const MessageLimit({
    super.key,
    required this.messageCount,
    this.maxMessages = 6,
  });

  final int messageCount;
  final int maxMessages;

  @override
  Widget build(BuildContext context) {
    final remaining = (maxMessages - messageCount).clamp(0, maxMessages);
    final progress = (messageCount / maxMessages).clamp(0.0, 1.0);
    final reached = remaining == 0;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: reached ? AppColors.warningSoft : AppColors.primarySoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          AppText(
            reached
                ? 'Limite de $maxMessages messages atteinte'
                : '$remaining message${remaining > 1 ? 's' : ''} restant${remaining > 1 ? 's' : ''}',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: reached ? AppColors.warning : AppColors.primary,
            textAlign: TextAlign.center,
          ),
          const VGap.sm(),
          AppProgressBar(value: progress, height: 6),
        ],
      ),
    );
  }
}
