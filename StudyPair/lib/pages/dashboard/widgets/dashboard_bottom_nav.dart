import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

/// Bottom navigation du dashboard (design StudyPair).
///
/// Exemple :
/// ```dart
/// AppScaffold(
///   safeTop: false,
///   safeBottom: false,
///   body: IndexedStack(index: index, children: tabs),
///   bottomNavigationBar: DashboardBottomNav(
///     currentIndex: index,
///     onTap: controller.changeTab,
///   ),
/// )
/// ```
class DashboardBottomNav extends StatelessWidget {
  const DashboardBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = <({IconData icon, String label})>[
    (icon: Icons.home_rounded, label: 'Accueil'),
    (icon: Icons.favorite_rounded, label: 'Matchs'),
    (icon: Icons.calendar_month_rounded, label: 'Planning'),
    (icon: Icons.chat_bubble_rounded, label: 'Messages'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.surface,
            elevation: 0,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey.withValues(alpha: 0.8),
            selectedFontSize: 11,
            unselectedFontSize: 11,
            items: _items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              final isHome = i == 0;

              return BottomNavigationBarItem(
                icon: isHome
                    ? Icon(item.icon, size: 40)
                    : Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withValues(alpha: 0.3),
                        ),
                        child: Icon(item.icon),
                      ),
                label: item.label,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
