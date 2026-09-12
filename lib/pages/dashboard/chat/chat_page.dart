import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/controller/chat_controller.dart';
import 'package:study_pair/models/message_model.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_avatar.dart';
import 'package:study_pair/widgets/app_platform.dart';
import 'package:study_pair/widgets/app_scaffold.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/app_validate_chat.dart';
import 'package:study_pair/widgets/gap.dart';
import 'package:study_pair/widgets/loading_view.dart';
import 'package:study_pair/widgets/messages_limit.dart';

import 'widgets/chat_input_bar.dart';
import 'widgets/message_bubble.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final chat = controller.chat.value;

      if (chat == null) {
        return AppScaffold(
          title: 'Conversation',
          backgroundColor: AppColors.background,
          body: Center(
            child: AppText(
              controller.error.value ?? 'Chargement…',
              color: AppColors.textSecondary,
            ),
          ),
        );
      }

      return AppScaffold(
        backgroundColor: AppColors.background,
        safeTop: false,
        safeBottom: false,
        body: Column(
          children: [
            const _ChatTopBar(),
            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                stream: controller.messagesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    return const LoadingView(message: 'Chargement…');
                  }

                  final messages = snapshot.data ?? [];

                  return Column(
                    children: [
                      Expanded(
                        child: messages.isEmpty
                            ? const Center(
                                child: AppText(
                                  'Aucun message pour le moment.\nDites bonjour !',
                                  textAlign: TextAlign.center,
                                  color: AppColors.textSecondary,
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  12,
                                  16,
                                  12,
                                ),
                                physics: AppPlatform.scrollPhysics,
                                itemCount: messages.length,
                                itemBuilder: (_, i) {
                                  final m = messages[i];
                                  return MessageBubble(
                                    content: m.content,
                                    mine: controller.isMine(m),
                                    sendAt: m.createdAt ?? DateTime.now(),
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
                        final enabled = controller.isValidated.value ||
                            messages.length < 6;
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
            ),
          ],
        ),
      );
    });
  }
}

class _ChatTopBar extends GetView<ChatController> {
  const _ChatTopBar();

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

    return Container(
      padding: EdgeInsets.fromLTRB(4, top + 4, 8, 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Obx(() {
        final user = controller.otherUser.value;

        return Row(
          children: [
            IconButton(
              onPressed: controller.goBack,
              icon: Icon(AppPlatform.backIcon, color: AppColors.textPrimary),
            ),
            if (user != null) ...[
              AppAvatar(
                imageUrl: user.photoUrl,
                name: user.displayName,
                size: 40,
                online: user.isOnline,
              ),
              const HGap.md(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      user.displayName,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppText(
                      user.level ?? 'Niveau inconnu',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ] else
              const Expanded(
                child: AppText(
                  'Conversation',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            if (!controller.isValidated.value)
              AppValidateChat(onValidate: controller.validate),
          ],
        );
      }),
    );
  }
}
