import 'package:dody_store/core/utils/routing/routes.dart';
import 'package:get/get.dart';

import '../../../core/services/hive_service.dart';
import '../../../core/services/Firebase_Service.dart';

class SplashController extends GetxController {
  final local = Get.find<HiveService>();
  final auth = Get.find<FirebaseService>();

  @override
  void onInit() {
    super.onInit();
    check();
  }

  Future<void> check() async {
    print("🔥 check started");

    try {
      await Future.delayed(const Duration(seconds: 3));

      print("⏳ after delay");

      final isFirstTime = await local.isFirstTime();
      print("✅ isFirstTime: $isFirstTime");

      final isLoggedIn = await auth.isLoggedIn;
      print("✅ isLoggedIn: $isLoggedIn");

      if (isFirstTime) {
        print("➡️ Go to onboarding");
        Get.offAllNamed(AppRoutes.onboarding);
      } else if (isLoggedIn) {
        print("➡️ Go to home");
        Get.offAllNamed(AppRoutes.mainPage);
      } else {
        print("➡️ Go to login");
        Get.offAllNamed(AppRoutes.logIn);
      }
    } catch (e) {
      print("❌ ERROR: $e");
    }
  }
}
