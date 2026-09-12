import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_avatar.dart';
import 'package:study_pair/widgets/app_button.dart';
import 'package:study_pair/widgets/app_chip.dart';
import 'package:study_pair/widgets/app_popup.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/app_text_field.dart';
import 'package:study_pair/widgets/gap.dart';

Future<void> showMatchProfileSheet({
  required BuildContext context,
  required String nom,
  required String affinite,
  required String statut,
  required String description,
  required List<String> competences,
  String? photoUrl,
  ValueChanged<String>? onProposer,
}) {
  return showAppBottomSheet<void>(
    context: context,
    title: 'Profil',
    child: _MatchProfileSheetBody(
      nom: nom,
      affinite: affinite,
      statut: statut,
      description: description,
      competences: competences,
      photoUrl: photoUrl,
      onProposer: onProposer,
    ),
  );
}

class _MatchProfileSheetBody extends StatefulWidget {
  const _MatchProfileSheetBody({
    required this.nom,
    required this.affinite,
    required this.statut,
    required this.description,
    required this.competences,
    this.photoUrl,
    this.onProposer,
  });

  final String nom;
  final String affinite;
  final String statut;
  final String description;
  final List<String> competences;
  final String? photoUrl;
  final ValueChanged<String>? onProposer;

  @override
  State<_MatchProfileSheetBody> createState() => _MatchProfileSheetBodyState();
}

class _MatchProfileSheetBodyState extends State<_MatchProfileSheetBody> {
  late final TextEditingController _message;

  @override
  void initState() {
    super.initState();
    _message = TextEditingController();
  }

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  void _submit() {
    final message = _message.text.trim();
    Navigator.of(context).pop();
    if (widget.onProposer != null) {
      widget.onProposer!(message);
    } else {
      Get.snackbar(
        'Match',
        message.isEmpty
            ? 'Proposition envoyée à ${widget.nom}'
            : 'Proposition envoyée à ${widget.nom} avec ton message',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppAvatar(
                imageUrl: widget.photoUrl,
                name: widget.nom,
                size: 64,
              ),
              const HGap.md(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      widget.nom,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    const VGap.xs(),
                    AppText(
                      widget.affinite,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                    const VGap.xs(),
                    AppText(
                      widget.statut,
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const VGap.lg(),
          const AppText(
            'À propos',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          const VGap.sm(),
          AppText(
            widget.description,
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
          if (widget.competences.isNotEmpty) ...[
            const VGap.lg(),
            const AppText(
              'Expertise',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            const VGap.sm(),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final skill in widget.competences)
                  AppChip(
                    label: skill,
                    variant: AppChipVariant.outline,
                  ),
              ],
            ),
          ],
          const VGap.lg(),
          const AppText(
            'Ton message',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          const VGap.sm(),
          AppTextField(
            controller: _message,
            label: 'Message',
            hint: 'Dis-lui pourquoi tu veux travailler ensemble…',
            maxLines: 3,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => _submit(),
          ),
          const VGap.xl(),
          AppButton(
            label: 'Proposer un binôme',
            icon: Icons.send_rounded,
            onPressed: _submit,
          ),
          const VGap.md(),
        ],
      ),
    );
  }
}
