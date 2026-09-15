
import 'package:flutter/material.dart';

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
    final remaining = maxMessages - messageCount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        remaining > 0
            ? '$remaining message${remaining > 1 ? 's' : ''} restant${remaining > 1 ? 's' : ''}'
            : 'Limite de 6 messages atteinte',
        textAlign: TextAlign.center,
      ),
    );
  }
}
