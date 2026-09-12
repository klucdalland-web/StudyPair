import 'package:flutter/material.dart';
import 'package:study_pair/models/user_model.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_avatar.dart';
import 'package:study_pair/widgets/app_button.dart';
import 'package:study_pair/widgets/app_popup.dart';
import 'package:study_pair/widgets/app_text.dart';
import 'package:study_pair/widgets/app_text_field.dart';
import 'package:study_pair/widgets/gap.dart';

Future<UserModel?> pickConversationContact({
  required BuildContext context,
  required List<UserModel> contacts,
}) {
  return showAppBottomSheet<UserModel>(
    context: context,
    title: 'Nouvelle conversation',
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.45,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: contacts.length,
        separatorBuilder: (_, _) => const Divider(
          height: 1,
          color: AppColors.divider,
        ),
        itemBuilder: (_, i) {
          final user = contacts[i];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: AppAvatar(
              imageUrl: user.photoUrl,
              name: user.displayName,
              size: 44,
              online: user.isOnline,
            ),
            title: AppText(
              user.displayName,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            subtitle: AppText(
              user.level ?? user.email,
              fontSize: 12,
              color: AppColors.textSecondary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => Navigator.of(context).pop(user),
          );
        },
      ),
    ),
  );
}

class GroupCreateResult {
  const GroupCreateResult({
    required this.members,
    required this.title,
  });

  final List<UserModel> members;
  final String title;
}

Future<GroupCreateResult?> pickGroupMembers({
  required BuildContext context,
  required List<UserModel> contacts,
}) {
  return showAppBottomSheet<GroupCreateResult>(
    context: context,
    title: 'Nouveau groupe',
    child: _GroupPickerSheet(contacts: contacts),
  );
}

class _GroupPickerSheet extends StatefulWidget {
  const _GroupPickerSheet({required this.contacts});

  final List<UserModel> contacts;

  @override
  State<_GroupPickerSheet> createState() => _GroupPickerSheetState();
}

class _GroupPickerSheetState extends State<_GroupPickerSheet> {
  final _title = TextEditingController();
  final _selected = <String>{};

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
  }

  void _submit() {
    if (_selected.length < 2) return;
    final members = widget.contacts
        .where((u) => _selected.contains(u.id))
        .toList();
    Navigator.of(context).pop(
      GroupCreateResult(
        members: members,
        title: _title.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final canCreate = _selected.length >= 2;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _title,
            label: 'Nom du groupe',
            hint: 'ex. Révisions Maths',
            textInputAction: TextInputAction.next,
          ),
          const VGap.md(),
          AppText(
            'Sélectionne au moins 2 membres (${_selected.length})',
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
          const VGap.sm(),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.35,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: widget.contacts.length,
              separatorBuilder: (_, _) => const Divider(
                height: 1,
                color: AppColors.divider,
              ),
              itemBuilder: (_, i) {
                final user = widget.contacts[i];
                final selected = _selected.contains(user.id);
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () => _toggle(user.id),
                  leading: AppAvatar(
                    imageUrl: user.photoUrl,
                    name: user.displayName,
                    size: 44,
                    online: user.isOnline,
                  ),
                  title: AppText(
                    user.displayName,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  subtitle: AppText(
                    user.level ?? user.email,
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    color: selected
                        ? AppColors.primary
                        : AppColors.textTertiary,
                  ),
                );
              },
            ),
          ),
          const VGap.lg(),
          AppButton(
            label: 'Créer le groupe',
            icon: Icons.group_add_rounded,
            onPressed: canCreate ? _submit : null,
          ),
          const VGap.md(),
        ],
      ),
    );
  }
}
