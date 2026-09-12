import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/controller/profile_controller.dart';
import 'package:study_pair/models/user_model.dart';
import 'package:study_pair/widgets/app_button.dart';
import 'package:study_pair/widgets/app_popup.dart';
import 'package:study_pair/widgets/app_text_field.dart';
import 'package:study_pair/widgets/gap.dart';

Future<void> showProfileEditSheet({
  required BuildContext context,
  required UserModel user,
}) {
  return showAppBottomSheet<void>(
    context: context,
    title: 'Modifier le profil',
    child: _ProfileEditForm(user: user),
  );
}

class _ProfileEditForm extends StatefulWidget {
  const _ProfileEditForm({required this.user});

  final UserModel user;

  @override
  State<_ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<_ProfileEditForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _displayName;
  late final TextEditingController _bio;
  late final TextEditingController _university;
  late final TextEditingController _level;
  late final TextEditingController _subjects;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    _displayName = TextEditingController(text: user.displayName);
    _bio = TextEditingController(text: user.bio ?? '');
    _university = TextEditingController(text: user.university ?? '');
    _level = TextEditingController(text: user.level ?? '');
    _subjects = TextEditingController(text: user.subjects.join(', '));
  }

  @override
  void dispose() {
    _displayName.dispose();
    _bio.dispose();
    _university.dispose();
    _level.dispose();
    _subjects.dispose();
    super.dispose();
  }

  List<String> _parseSubjects(String raw) {
    return raw
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final controller = Get.find<ProfileController>();
    final ok = await controller.updateProfile(
      displayName: _displayName.text.trim(),
      bio: _bio.text.trim(),
      university: _university.text.trim(),
      level: _level.text.trim(),
      subjects: _parseSubjects(_subjects.text),
    );

    if (ok && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _displayName,
              label: 'Nom affiché',
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le nom est requis';
                }
                return null;
              },
            ),
            const VGap.md(),
            AppTextField(
              controller: _bio,
              label: 'Bio',
              hint: 'Quelques mots sur toi…',
              maxLines: 3,
              textInputAction: TextInputAction.next,
            ),
            const VGap.md(),
            AppTextField(
              controller: _university,
              label: 'Université',
              textInputAction: TextInputAction.next,
            ),
            const VGap.md(),
            AppTextField(
              controller: _level,
              label: 'Niveau / filière',
              hint: 'ex. Master IA',
              textInputAction: TextInputAction.next,
            ),
            const VGap.md(),
            AppTextField(
              controller: _subjects,
              label: 'Expertise',
              hint: 'Séparées par des virgules',
              maxLines: 2,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
            ),
            const VGap.xl(),
            Obx(
              () => AppButton(
                label: 'Enregistrer',
                loading: controller.isSaving.value,
                onPressed: _submit,
              ),
            ),
            const VGap.md(),
          ],
        ),
      ),
    );
  }
}
