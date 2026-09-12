import 'package:flutter/material.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/theme/app_radii.dart';
import 'package:study_pair/widgets/app_skeleton.dart';
import 'package:study_pair/widgets/gap.dart';

/// Skeleton de la liste Match (cartes utilisateurs).
class MatchUsersSkeleton extends StatelessWidget {
  const MatchUsersSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: itemCount + 1,
      separatorBuilder: (_, _) => const VGap.md(),
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppSkeleton(width: 120, height: 18),
              AppSkeleton(width: 80, height: 14),
            ],
          );
        }
        return const _MatchCardSkeleton();
      },
    );
  }
}

class _MatchCardSkeleton extends StatelessWidget {
  const _MatchCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const MatchCardSkeleton();
  }
}

/// Carte skeleton réutilisable (liste initiale ou chargement en bas).
class MatchCardSkeleton extends StatelessWidget {
  const MatchCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.lgAll,
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          AppSkeletonAvatar(size: 44),
          HGap.md(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton(width: 140, height: 14),
                VGap.sm(),
                AppSkeleton(width: 180, height: 12),
              ],
            ),
          ),
          HGap.sm(),
          AppSkeleton(width: 22, height: 22, borderRadius: AppRadii.smAll),
          HGap.sm(),
          AppSkeleton(width: 18, height: 18, borderRadius: AppRadii.smAll),
        ],
      ),
    );
  }
}

/// Skeleton compact affiché en bas pendant le chargement au scroll.
class MatchLoadMoreSkeleton extends StatelessWidget {
  const MatchLoadMoreSkeleton({super.key, this.count = 2});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        children: [
          for (var i = 0; i < count; i++) ...[
            if (i > 0) const VGap.md(),
            const MatchCardSkeleton(),
          ],
        ],
      ),
    );
  }
}
