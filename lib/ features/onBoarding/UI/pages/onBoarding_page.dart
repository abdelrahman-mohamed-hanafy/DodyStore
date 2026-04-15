import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/AppBackground.dart';
import '../../controller/onBoarding_controller.dart';
import '../Widget/custom_page.dart';

class OnBoardingPage extends GetView<OnBoardingController> {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: PageView(
          controller: controller.pageController,
          onPageChanged: (index) => controller.currentIndex.value = index,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 22.0),
              child: CustomPage(
                mainText: 'Welcome to Dody Store',
                subText: 'Discover a world of fashion at your fingertips.',
                onPressed: controller.onSkip,
                imagePath: 'assets/images/first.png',
              ),
            ),
            CustomPage(
              mainText: 'Discover Your Style',
              subText: 'Explore a wide range of trendy clothing and accessories.',
              onPressed: controller.onSkip,
              imagePath: 'assets/images/second.png',
            ),
            CustomPage(
              mainText: 'Shop with Confidence',
              subText: 'Enjoy secure shopping and fast delivery with Dody Store.',
              onPressed: controller.onSkip,
              imagePath: 'assets/images/third.png',
            ),
          ],
        ),
      ),
    );
  }
}
