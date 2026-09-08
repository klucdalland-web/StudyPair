import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/initial_binding.dart';
import 'firebase_options.dart';
import 'pages/pre_auth/splash/splash_page.dart';
import 'routes/app_pages.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('🔥 Firebase OK — project: ${DefaultFirebaseOptions.currentPlatform.projectId}');
    print('📱 App ID: ${DefaultFirebaseOptions.currentPlatform.appId}');
  } catch (e, st) {
    print('❌ Firebase FAIL — init impossible');
    print('❌ $e');
    print('📜 $st');
  }

  await InitialBinding.init();
  print('🧩 Services GetX prêts (Auth, User, Match, Chat)');

  runApp(const StudyPairApp());
}

class StudyPairApp extends StatelessWidget {
  const StudyPairApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'StudyPair',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => const SplashPage(),
      ),
      defaultTransition: Transition.cupertino,
    );
  }
}
