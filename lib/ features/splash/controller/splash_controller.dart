import 'package:dody_store/core/services/Supabase_Service.dart';
import 'package:dody_store/core/utils/routing/routes.dart';
import 'package:get/get.dart';

import '../../../core/services/hive_service.dart';

class SplashController extends GetxController {
  final local = Get.find<HiveService>();
  final auth = Get.find<SupabaseService>();

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

      final isLoggedIn = await auth.isLoggedIn;

      if (isFirstTime) {
        Get.offAllNamed(AppRoutes.onboarding);
      } else if (isLoggedIn) {
        Get.offAllNamed(AppRoutes.mainPage);
      } else {
        Get.offAllNamed(AppRoutes.logIn);
      }
    } catch (e) {
      print("❌ ERROR: $e");
    }
  }
}
