import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/app_scaffold.dart';
import 'chats/chats_page.dart';
import 'dashboard_controller.dart';
import 'home/home_page.dart';
import 'match/match_page.dart';
import 'planning/planning_page.dart';
import 'widgets/dashboard_bottom_nav.dart';

/// Shell après auth : onglets + bottom navigation.
class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  static const _tabs = <Widget>[
    HomePage(),
    MatchPage(),
    PlanningPage(),
    ChatsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppScaffold(
        backgroundColor:  Color(0xFF5F67EA),
        safeTop: false,
        safeBottom: false,
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
