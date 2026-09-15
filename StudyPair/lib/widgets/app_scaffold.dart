import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

/// Scaffold StudyPair unifié iOS / Android.
///
/// - Même look Figma sur les deux plateformes
/// - SafeArea, status bar et clavier gérés
/// - AppBar Material ou CupertinoNavigationBar selon la plateforme
///
/// Exemple :
/// ```dart
/// AppScaffold(
///   title: 'Créer un compte',
///   body: AppPageScroll(
///     children: [
///       AppTextField(controller: _email, label: 'Email'),
///       const VGap.md(),
///       AppButton(label: 'Continuer', onPressed: _submit),
///     ],
///   ),
/// )
///
/// // Shell dashboard (sans AppBar, avec bottom nav) :
/// AppScaffold(
///   safeTop: false,
///   safeBottom: false,
///   body: IndexedStack(index: i, children: tabs),
///   bottomNavigationBar: DashboardBottomNav(...),
/// )
/// ```
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.appBar,
    this.leading,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.safeTop = true,
    this.safeBottom = true,
    this.centerTitle,
    this.onBack,
    this.showBackButton,
  });

  final Widget body;
  final String? title;

  /// Si fourni, remplace l’app bar générée depuis [title].
  final PreferredSizeWidget? appBar;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool safeTop;
  final bool safeBottom;
  final bool? centerTitle;
  final VoidCallback? onBack;

  /// `null` = auto (si Navigator.canPop).
  final bool? showBackButton;

  bool get _isCupertino =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.background;
    final canPop = Navigator.of(context).canPop();
    final wantBack = showBackButton ?? canPop;

    final preferredAppBar =
        appBar ??
        (title != null
            ? AppTopBar(
                title: title!,
                leading: leading,
                actions: actions,
                centerTitle: centerTitle,
                onBack: onBack,
                showBackButton: wantBack,
              )
            : null);

    final content = SafeArea(
      top: safeTop && preferredAppBar == null,
      bottom: safeBottom && bottomNavigationBar == null,
      child: body,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _isCupertino
            ? Brightness.dark
            : Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.surface,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: bg,
        appBar: preferredAppBar,
        body: content,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
        bottomSheet: bottomSheet,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        extendBody: extendBody,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
      ),
    );
  }
}

/// App bar adaptative : Material (Android) / Cupertino (iOS).
///
/// Exemple :
/// ```dart
/// AppScaffold(
///   appBar: AppTopBar(
///     title: 'Sarah L.',
///     showBackButton: true,
///     actions: [
///       AppButton(label: 'Valider', expanded: false, height: 36, onPressed: _ok),
///     ],
///   ),
///   body: ...,
/// )
/// ```
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.centerTitle,
    this.onBack,
    this.showBackButton = false,
    this.backgroundColor,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool? centerTitle;
  final VoidCallback? onBack;
  final bool showBackButton;
  final Color? backgroundColor;

  bool get _isCupertino =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.surface;

    if (_isCupertino) {
      return PreferredSize(
        preferredSize: preferredSize,
        child: CupertinoNavigationBar(
          backgroundColor: bg.withValues(alpha: 0.94),
          border: const Border(
            bottom: BorderSide(color: AppColors.border, width: 0.5),
          ),
          middle: Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading:
              leading ??
              (showBackButton
                  ? CupertinoNavigationBarBackButton(
                      color: AppColors.primary,
                      onPressed:
                          onBack ?? () => Navigator.of(context).maybePop(),
                    )
                  : null),
          trailing: actions == null || actions!.isEmpty
              ? null
              : Row(mainAxisSize: MainAxisSize.min, children: actions!),
        ),
      );
    }

    return AppBar(
      title: Text(title),
      backgroundColor: bg,
      centerTitle: centerTitle ?? false,
      leading:
          leading ??
          (showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                )
              : null),
      automaticallyImplyLeading: showBackButton && leading == null,
      actions: actions,
    );
  }
}

/// Contenu scrollable standard (padding + physique native).
///
/// Exemple :
/// ```dart
/// AppPageScroll(
///   children: [
///     Text('Bonjour Thomas'),
///     const VGap.lg(),
///     AppCard(child: Text('Mentor principal')),
///   ],
/// )
/// ```
class AppPageScroll extends StatelessWidget {
  const AppPageScroll({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(24),
    this.physics,
    this.controller,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  bool get _isCupertino =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      padding: padding,
      physics:
          physics ??
          (_isCupertino
              ? const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                )
              : const ClampingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                )),
      children: children,
    );
  }
}
