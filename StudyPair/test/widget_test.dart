import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:study_pair/pages/pre_auth/splash/splash_page.dart';

void main() {
  testWidgets('Splash shows StudyPair', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: SplashPage()));
    expect(find.text('StudyPair'), findsOneWidget);
  });
}
