import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:study_pair/widgets/app_text.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../utils/app_spacing.dart';
import 'app_button.dart';
import 'gap.dart';

bool get _isCupertino =>
    defaultTargetPlatform == TargetPlatform.iOS ||
    defaultTargetPlatform == TargetPlatform.macOS;

// ─── Dialog custom (look Figma) ───────────────────────────────────────────────

/// Contenu de popup StudyPair (carte centrée, coins 16).
///
/// Préférer [showAppPopup] plutôt que d’instancier directement.
///
/// Exemple :
/// ```dart
/// showDialog(
///   context: context,
///   builder: (_) => AppPopupCard(
///     title: 'Valider ce binôme ?',
///     message: 'Tu passeras en mode illimité avec Sarah.',
///     icon: Icons.handshake_outlined,
///     actions: [
///       AppButton.secondary(label: 'Plus tard', onPressed: () => Navigator.pop(context, false)),
///       AppButton(label: 'Valider', onPressed: () => Navigator.pop(context, true)),
///     ],
///   ),
/// );
/// ```
class AppPopupCard extends StatelessWidget {
  const AppPopupCard({
    super.key,
    this.title,
    this.message,
    this.child,
    this.actions,
    this.icon,
    this.iconColor,
  });

  final String? title;
  final String? message;
  final Widget? child;
  final List<Widget>? actions;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      elevation: 8,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.xlAll),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (icon != null) ...[
              Center(
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppColors.primary).withValues(
                      alpha: 0.12,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? AppColors.primary,
                    size: 26,
                  ),
                ),
              ),
              const VGap.lg(),
            ],
            if (title != null)
              Text(
                title!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            if (message != null) ...[
              const VGap.sm(),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            if (child != null) ...[const VGap.lg(), child!],
            if (actions != null && actions!.isNotEmpty) ...[
              const VGap.xl(),
              ..._buildActions(actions!),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions(List<Widget> actions) {
    if (actions.length == 2) {
      return [
        Row(
          children: [
            Expanded(child: actions[0]),
            const HGap.md(),
            Expanded(child: actions[1]),
          ],
        ),
      ];
    }
    return [
      for (var i = 0; i < actions.length; i++) ...[
        if (i > 0) const VGap.sm(),
        actions[i],
      ],
    ];
  }
}

/// Affiche un popup custom StudyPair.
///
/// Exemple :
/// ```dart
/// await showAppPopup(
///   context: context,
///   title: 'Session rejointe',
///   message: 'Rendez-vous demain à 16h00.',
///   icon: Icons.check_circle_outline,
///   actions: [
///     AppButton(label: 'OK', onPressed: () => closeAppPopup(context)),
///   ],
/// );
/// ```
Future<T?> showAppPopup<T>({
  required BuildContext context,
  String? title,
  String? message,
  Widget? child,
  List<Widget>? actions,
  IconData? icon,
  Color? iconColor,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: AppColors.textPrimary.withValues(alpha: 0.45),
    builder: (_) => AppPopupCard(
      title: title,
      message: message,
      actions: actions,
      icon: icon,
      iconColor: iconColor,
      child: child,
    ),
  );
}

/// Confirmation oui/non (design Figma, adaptatif native en fallback optionnel).
///
/// Exemple :
/// ```dart
/// final ok = await showAppConfirmDialog(
///   context: context,
///   title: 'Décliner cette demande ?',
///   message: 'Alexandre ne pourra plus te recontacter via cette demande.',
///   confirmLabel: 'Décliner',
///   cancelLabel: 'Annuler',
///   isDestructive: true,
/// );
/// if (ok == true) { /* ... */ }
/// ```
Future<bool?> showAppConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'Confirmer',
  String cancelLabel = 'Annuler',
  bool isDestructive = false,
  IconData? icon,
  bool useNative = false,
}) {
  if (useNative && _isCupertino) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: AppText(title),
        content: AppText(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: AppText(cancelLabel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: isDestructive,
            onPressed: () => Navigator.of(ctx).pop(true),
            child: AppText(confirmLabel),
          ),
        ],
      ),
    );
  }

  return showAppPopup<bool>(
    context: context,
    title: title,
    message: message,
    icon:
        icon ??
        (isDestructive
            ? Icons.warning_amber_rounded
            : Icons.help_outline_rounded),
    iconColor: isDestructive ? AppColors.danger : AppColors.primary,
    actions: [
      AppButton.secondary(
        label: cancelLabel,
        onPressed: () => Navigator.of(context).pop(false),
      ),
      AppButton(
        label: confirmLabel,
        variant: isDestructive
            ? AppButtonVariant.danger
            : AppButtonVariant.primary,
        onPressed: () => Navigator.of(context).pop(true),
      ),
    ],
  );
}

// ─── Bottom sheet ─────────────────────────────────────────────────────────────

/// Bottom sheet StudyPair (handle + titre + contenu).
///
/// Préférer [showAppBottomSheet].
///
/// Exemple :
/// ```dart
/// showAppBottomSheet(
///   context: context,
///   title: 'Filtres',
///   child: Column(
///     mainAxisSize: MainAxisSize.min,
///     children: [
///       AppChip(label: 'Informatique', selected: true, onTap: () {}),
///       const VGap.md(),
///       AppButton(label: 'Appliquer', onPressed: () => closeAppPopup(context)),
///     ],
///   ),
/// );
/// ```
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.showHandle = true,
    this.padding,
  });

  final Widget child;
  final String? title;
  final bool showHandle;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding:
              padding ??
              const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.md,
                AppSpacing.xl,
                AppSpacing.xl,
              ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showHandle) ...[
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: AppRadii.pillAll,
                    ),
                  ),
                ),
                const VGap.lg(),
              ],
              if (title != null) ...[
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const VGap.lg(),
              ],
              Flexible(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

/// Affiche un bottom sheet StudyPair (Cupertino sur iOS).
///
/// Exemple :
/// ```dart
/// await showAppBottomSheet(
///   context: context,
///   title: 'Planifier une session',
///   child: Text('Choisis un créneau…'),
/// );
/// ```
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  String? title,
  bool isDismissible = true,
  bool enableDrag = true,
  bool isScrollControlled = true,
}) {
  if (_isCupertino) {
    return showCupertinoModalPopup<T>(
      context: context,
      barrierDismissible: isDismissible,
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: AppBottomSheet(title: title, child: child),
      ),
    );
  }

  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.textPrimary.withValues(alpha: 0.45),
    builder: (_) => AppBottomSheet(title: title, child: child),
  );
}

// ─── Action sheet (liste d’actions) ───────────────────────────────────────────

/// Action d’un [showAppActionSheet].
///
/// Exemple :
/// ```dart
/// AppSheetAction(
///   label: 'Supprimer la conversation',
///   icon: Icons.delete_outline,
///   isDestructive: true,
///   onTap: _deleteChat,
/// )
/// ```
class AppSheetAction {
  const AppSheetAction({
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    this.icon,
  });

  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  final IconData? icon;
}

/// Liste d’actions (partager, supprimer…) — native iOS / sheet Android.
///
/// Exemple :
/// ```dart
/// await showAppActionSheet(
///   context: context,
///   title: 'Options du chat',
///   actions: [
///     AppSheetAction(label: 'Mute', icon: Icons.notifications_off_outlined, onTap: _mute),
///     AppSheetAction(
///       label: 'Quitter',
///       icon: Icons.logout,
///       isDestructive: true,
///       onTap: _leave,
///     ),
///   ],
/// );
/// ```
Future<void> showAppActionSheet({
  required BuildContext context,
  required List<AppSheetAction> actions,
  String? title,
  String cancelLabel = 'Annuler',
}) {
  if (_isCupertino) {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: title != null ? Text(title) : null,
        actions: [
          for (final action in actions)
            CupertinoActionSheetAction(
              isDestructiveAction: action.isDestructive,
              onPressed: () {
                Navigator.of(ctx).pop();
                action.onTap();
              },
              child: Text(action.label),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(cancelLabel),
        ),
      ),
    );
  }

  return showAppBottomSheet<void>(
    context: context,
    title: title,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final action in actions)
          ListTile(
            leading: action.icon != null
                ? Icon(
                    action.icon,
                    color: action.isDestructive
                        ? AppColors.danger
                        : AppColors.primary,
                  )
                : null,
            title: Text(
              action.label,
              style: TextStyle(
                color: action.isDestructive
                    ? AppColors.danger
                    : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              action.onTap();
            },
            shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdAll),
          ),
        const VGap.sm(),
        AppButton.secondary(
          label: cancelLabel,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}

// ─── Helpers navigation ───────────────────────────────────────────────────────

/// Ferme le popup / sheet courant.
///
/// Exemple :
/// ```dart
/// closeAppPopup(context);
/// closeAppPopup(context, true); // avec résultat
/// ```
void closeAppPopup(BuildContext context, [Object? result]) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop(result);
  }
}
