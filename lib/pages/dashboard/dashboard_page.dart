import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chats/chats_page.dart';
import 'dashboard_controller.dart';
import 'home/home_page.dart';
import 'match/match_page.dart';
import 'profile/profile_page.dart';
import 'widgets/dashboard_bottom_nav.dart';

/// Shell après auth : onglets + bottom navigation.
class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  static const _tabs = <Widget>[
    HomePage(),
    MatchPage(),
    ChatsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: _tabs,
        ),
        bottomNavigationBar: DashboardBottomNav(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
        ),
      ),
    );
  }
}
