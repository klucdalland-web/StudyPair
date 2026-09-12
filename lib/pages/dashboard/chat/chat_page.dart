import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/controller/chat_controller.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/gap.dart';

import '../../../models/message_model.dart';
import '../../../widgets/app_avatar.dart';
import '../../../widgets/app_validate_chat.dart';
import '../../../widgets/messages_limit.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/message_bubble.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final chat = controller.chat.value;

      if (chat == null) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(child: AppText(controller.error.value ?? 'Chargement…')),
        );
      }

      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: controller.goBack,
          ),
          title: _ChatAppBarTitle(),
          actions: [
            Obx(() {
              if (controller.isValidated.value) return const SizedBox.shrink();
              return AppValidateChat(onValidate: controller.validate);
            }),
          ],
        ),
        body: StreamBuilder<List<MessageModel>>(
          stream: controller.messagesStream,
          builder: (context, snapshot) {
            final messages = snapshot.data ?? [];

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (_, i) {
                      final m = messages[i];
                      return MessageBubble(
                        content: m.content,
                        mine: controller.isMine(m),
                        sendAt: m.sendAt,
                      );
                    },
                  ),
                ),

                Obx(() {
                  if (controller.isValidated.value) {
                    return const SizedBox.shrink();
                  }
                  return MessageLimit(messageCount: messages.length);
                }),

                Obx(() {
                  final enabled =
                      controller.isValidated.value || messages.length < 6;

                  return ChatInputBar(
                    controller: controller.inputController,
                    onSend: controller.send,
                    isEnabled: enabled,
                  );
                }),
              ],
            );
          },
        ),
      );
    });
  }
}

class _ChatAppBarTitle extends GetView<ChatController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.otherUser.value;
      if (user == null) return const SizedBox.shrink();

      return Row(
        children: [
          AppAvatar(
            imageUrl: user.photoUrl,
            name: user.displayName,
            online: user.isOnline,
            onTap: () {},
          ),
          const VGap.sm(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(user.displayName, overflow: TextOverflow.ellipsis),
                AppText(
                  user.level ?? 'Niveau inconnu',
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
