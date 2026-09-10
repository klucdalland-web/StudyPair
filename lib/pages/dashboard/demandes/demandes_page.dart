import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_pair/pages/dashboard/dashboard_controller.dart';
import 'package:study_pair/theme/app_colors.dart';
import 'package:study_pair/widgets/app_platform.dart';
import 'package:study_pair/widgets/app_scaffold.dart';

/// 
/// 
/// nglets + bottom navigation.
class DemandesPage extends StatefulWidget {
  const new({super.key});

  @override
  State<DemandesPage> createState() => _DemandesPageState();
}

class _DemandesPageState extends State<DemandesPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // const Header(),
          // const VGap.md(),
          // // const Search(),
          // const VGap.xl(),
          // Expanded(
          //   child: DecoratedBox(
          //     decoration: const BoxDecoration(
          //       color: AppColors.surface,
          //       borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          //     ),
          //     child: SingleChildScrollView(
          //       physics: AppPlatform.scrollPhysics,
          //       child: const Column(
          //         crossAxisAlignment: CrossAxisAlignment.stretch,
          //         children: [
          //           Categoriesection(),
          //           RecentRequestsSection(),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  
}
