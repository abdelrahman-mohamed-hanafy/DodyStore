import 'package:dody_store/%20features/onBoarding/controller/onBoarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/widgets/custom_buttton.dart';

class CustomPage extends StatelessWidget {
  CustomPage({super.key, required this.mainText, required this.subText, required this.onPressed, required this.imagePath});
  final String mainText;
  final String subText;
  final VoidCallback onPressed;
  final String imagePath ;
  final controller = Get.find<OnBoardingController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Skip', style: TextStyle(fontSize: 18,color: Colors.white)),
                const SizedBox(width: 2.0,),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.white,
                ),
              ],
            ),
          ),

        ),
        const SizedBox(height: 40,),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white.withOpacity(0.05),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 40,),
        Text(mainText, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),),
        const SizedBox(height: 8.0,),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(subText, style: const TextStyle(fontSize: 16,color: Colors.white)),
        ),
        const SizedBox(height: 20,),
        SmoothPageIndicator(
          controller: controller.pageController,
          count: 3,
          effect: const WormEffect(
            dotHeight: 12,
            dotWidth: 12,
            activeDotColor: Colors.white,
            dotColor: Colors.grey,
          ),
        ),
        const SizedBox(height: 20,),
        Obx(() => controller.currentIndex.value < 2
            ? CustomButton(text: 'Next', onPressed: controller.onNext)
            : CustomButton(text: 'Get Started', onPressed: controller.onSkip),
        ),
      ],
    );
  }
}
