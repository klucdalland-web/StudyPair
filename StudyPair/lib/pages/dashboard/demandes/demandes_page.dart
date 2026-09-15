import 'package:flutter/material.dart';

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
    return Scaffold(
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
}