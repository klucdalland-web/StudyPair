import 'package:flutter/material.dart';

import '../utils/app_spacing.dart';

/// Raccourcis de Spacer verticaux / horizontaux.
///
/// Exemple :
/// ```dart
/// const Gap.md()   // 12×12
/// const Gap.xl()   // 24×24
/// ```
class Gap extends StatelessWidget {
  const Gap(this.size, {super.key});

  const Gap.xs({super.key}) : size = AppSpacing.xs;
  const Gap.sm({super.key}) : size = AppSpacing.sm;
  const Gap.md({super.key}) : size = AppSpacing.md;
  const Gap.lg({super.key}) : size = AppSpacing.lg;
  const Gap.xl({super.key}) : size = AppSpacing.xl;
  const Gap.xxl({super.key}) : size = AppSpacing.xxl;

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(height: size, width: size);
}

/// Espace vertical uniquement.
///
/// Exemple :
/// ```dart
/// Text('Titre'),
/// const VGap.sm(),
/// Text('Sous-titre'),
/// const VGap.xl(),
/// AppButton(label: 'OK', onPressed: () {}),
/// ```
class VGap extends StatelessWidget {
  const VGap(this.height, {super.key});

  const VGap.sm({super.key}) : height = AppSpacing.sm;
  const VGap.md({super.key}) : height = AppSpacing.md;
  const VGap.lg({super.key}) : height = AppSpacing.lg;
  const VGap.xl({super.key}) : height = AppSpacing.xl;
  const VGap.xxl({super.key}) : height = AppSpacing.xxl;

  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}

/// Espace horizontal uniquement.
///
/// Exemple :
/// ```dart
/// Row(
///   children: [
///     AppAvatar(name: 'Sarah'),
///     const HGap.md(),
///     Text('Sarah Legrand'),
///   ],
/// )
/// ```
class HGap extends StatelessWidget {
  const HGap(this.width, {super.key});

  const HGap.sm({super.key}) : width = AppSpacing.sm;
  const HGap.md({super.key}) : width = AppSpacing.md;
  const HGap.lg({super.key}) : width = AppSpacing.lg;

  final double width;

  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}

// =============================================================================
// DOCUMENTATION — Gap / VGap / HGap
// =============================================================================
//
// À QUOI ÇA SERT ?
// -----------------
// Remplacer les SizedBox(height: …) / SizedBox(width: …) par des espacements
// nommés et cohérents dans toute l’app (design system StudyPair).
//
//   Gap   → carré (hauteur + largeur) — rare, ex. entre icônes en grille
//   VGap  → espace VERTICAL uniquement (dans une Column / ListView)
//   HGap  → espace HORIZONTAL uniquement (dans une Row)
//
// TAILLES (basées sur AppSpacing)
// -------------------------------
//   .sm()  →  8 px
//   .md()  → 12 px
//   .lg()  → 16 px
//   .xl()  → 24 px
//   .xxl() → 32 px   (VGap et Gap seulement)
//   .xs()  →  4 px   (Gap seulement)
//
// Ou taille libre :
//   const VGap(20)
//   const HGap(10)
//   const Gap(16)
//
// COMMENT L’UTILISER ?
// --------------------
//
// 1) Vertical (Column) — le plus fréquent
//
//   Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text('Bonjour Thomas'),
//       const VGap.sm(),              // 8 px sous le titre
//       Text('Master IA • Sorbonne'),
//       const VGap.xl(),              // 24 px avant le bouton
//       AppButton(label: 'Continuer', onPressed: () {}),
//     ],
//   )
//
// 2) Horizontal (Row)
//
//   Row(
//     children: [
//       AppAvatar(name: 'Sarah', size: 40),
//       const HGap.md(),              // 12 px entre avatar et texte
//       Expanded(child: Text('Sarah Legrand')),
//       const HGap.sm(),
//       AppRating(value: 4.9),
//     ],
//   )
//
// 3) Import
//
//   import 'package:study_pair/widgets/gap.dart';
//
// BONNES PRATIQUES
// ----------------
// - Toujours préférer const VGap.xx() / const HGap.xx() (perf + immuable).
// - Ne pas mélanger avec des SizedBox magiques (height: 13, width: 7…).
// - Dans une Column → VGap | Dans une Row → HGap | Les deux axes → Gap.
//
// ÉQUIVALENCES
// ------------
//   const VGap.md()  ==  const SizedBox(height: 12)
//   const HGap.md()  ==  const SizedBox(width: 12)
//   const Gap.md()   ==  const SizedBox(height: 12, width: 12)
//
// =============================================================================

