import 'package:flutter/material.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_text.dart';

import '../../../../widgets/gap.dart';
import '../../../../controller/chat_controller.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.content,
    required this.mine,
    required this.sendAt,
    this.status,
    this.showSenderName = false,
    this.senderName,
    this.readCount,
    this.totalOthers,
  });

  final String content;
  final bool mine;
  final DateTime sendAt;
  final MessageStatus? status;
  final bool showSenderName;
  final String? senderName;
  final int? readCount;
  final int? totalOthers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: mine
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        if (!mine && showSenderName && senderName != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 4),
            child: AppText(
              senderName!,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        Row(
          mainAxisAlignment: mine
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(child: _bubble()),
            if (mine) ...[const HGap.xs(), _statusWidget()],
          ],
        ),
      ],
    );
  }

  Widget _bubble() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: mine ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppText(content, color: mine ? Colors.white : AppColors.textPrimary),
          const VGap.xs(),
          AppText(
            _formatTime(sendAt),
            fontSize: 10,
            color: mine ? Colors.white70 : AppColors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _statusWidget() {
    if (status == null) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(status!.icon, size: 14, color: status!.color),
        if (readCount != null && totalOthers != null && totalOthers! > 1) ...[
          const HGap.xs(),
          AppText(
            '$readCount/$totalOthers',
            fontSize: 10,
            color: AppColors.textTertiary,
          ),
        ],
      ],
    );
  }

  String _formatTime(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}
