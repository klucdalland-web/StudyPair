import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/app_scaffold.dart';
import '../../../widgets/loading_view.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      if (!Get.isRegistered<AuthService>()) {
        Get.offAllNamed(Routes.login);
        return;
      }
      final auth = Get.find<AuthService>();
      Get.offAllNamed(auth.isLoggedIn ? Routes.dashboard : Routes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school_rounded, size: 64, color: AppColors.primary),
            SizedBox(height: 16),
            Text(
              'StudyPair',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 24),
            AppLoader(size: 28),
          ],
        ),
      ),
    );
  }
}
