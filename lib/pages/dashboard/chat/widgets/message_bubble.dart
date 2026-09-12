import 'package:flutter/material.dart';
import 'package:study_pair/widgets/app_text.dart';

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
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: mine
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppText(content),
            const SizedBox(height: 4),
            AppText(formatMessageDate(sendAt)),
          ],
        ),
      ),
    );
  }
}
