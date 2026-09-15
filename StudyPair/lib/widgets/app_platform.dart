import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_scaffold.dart';

/// Helpers plateforme partagés.
///
/// Exemple :
/// ```dart
/// ListView(
///   physics: AppPlatform.scrollPhysics,
///   children: [...],
/// )
///
/// Icon(AppPlatform.backIcon)
/// if (AppPlatform.isCupertino) { ... }
/// ```
abstract class AppPlatform {
  static bool get isCupertino =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  static bool get isMaterial => !isCupertino;

  static ScrollPhysics get scrollPhysics => isCupertino
      ? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics())
      : const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

  static IconData get backIcon =>
      isCupertino ? Icons.arrow_back_ios_new_rounded : Icons.arrow_back_rounded;
}

/// Page dashboard (onglet) : pas d’AppBar système, fond StudyPair.
///
/// Exemple :
/// ```dart
/// class HomePage extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return AppTabScaffold(
///       body: AppPageScroll(
///         children: [Text('Bonjour'), AppCard(...)],
///       ),
///     );
///   }
/// }
/// ```
class AppTabScaffold extends StatelessWidget {
  const AppTabScaffold({
    super.key,
    required this.body,
    this.floatingActionButton,
    this.backgroundColor,
  });

  final Widget body;
  final Widget? floatingActionButton;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      safeTop: true,
      safeBottom: false,
      floatingActionButton: floatingActionButton,
      body: body,
    );
  }
}
