import 'package:flutter/material.dart';

import '../utils/app_spacing.dart';

/// Raccourcis de Spacer verticaux / horizontaux.
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

class HGap extends StatelessWidget {
  const HGap(this.width, {super.key});

  const HGap.sm({super.key}) : width = AppSpacing.sm;
  const HGap.md({super.key}) : width = AppSpacing.md;
  const HGap.lg({super.key}) : width = AppSpacing.lg;

  final double width;

  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}
