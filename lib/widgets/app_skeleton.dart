import 'package:flutter/material.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/theme/app_radii.dart';

/// Bloc skeleton animé (shimmer).
class AppSkeleton extends StatefulWidget {
  const AppSkeleton({
    super.key,
    this.width,
    this.height = 14,
    this.borderRadius = AppRadii.mdAll,
  });

  final double? width;
  final double height;
  final BorderRadius borderRadius;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 - _controller.value * 2, 0),
              end: Alignment(1.0 - _controller.value * 2, 0),
              colors: const [
                AppColors.surfaceAlt,
                Color(0xFFF8F8FC),
                AppColors.surfaceAlt,
              ],
              stops: const [0.25, 0.5, 0.75],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: widget.borderRadius,
        ),
      ),
    );
  }
}

/// Avatar circulaire skeleton.
class AppSkeletonAvatar extends StatelessWidget {
  const AppSkeletonAvatar({super.key, this.size = 44});

  final double size;

  @override
  Widget build(BuildContext context) {
    return AppSkeleton(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
    );
  }
}
