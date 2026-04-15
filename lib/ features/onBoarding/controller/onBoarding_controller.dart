import 'package:dody_store/core/services/hive_service.dart';
import 'package:dody_store/core/utils/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  final pageController = PageController();
  final local = Get.find<HiveService>();
  final currentIndex = 0.obs;

  Future<void> onNext() async {
    if (currentIndex.value < 2) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Get.offAllNamed(AppRoutes.logIn);
      await local.setFirstTime();
    }
  }

  Future<void> onSkip() async {
    Get.offAllNamed(AppRoutes.logIn);
    await local.setFirstTime();
  }
}
