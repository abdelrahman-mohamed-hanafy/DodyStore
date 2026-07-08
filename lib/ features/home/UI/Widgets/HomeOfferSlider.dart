import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/Home_Controller.dart';
import 'Slider.dart';


class HomeOfferSlider extends StatefulWidget {
  const HomeOfferSlider({super.key});

  @override
  State<HomeOfferSlider> createState() => _HomeOfferSliderState();
}

class _HomeOfferSliderState extends State<HomeOfferSlider> {
  final controller = Get.find<HomeController>();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.offers.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          CarouselSlider.builder(
            itemCount: controller.offers.length,
            itemBuilder: (context, index, realIndex) {
              final offer = controller.offers[index];
              return OfferSliderItem(
                title: offer.title,
                subTitle: offer.subtitle,
                image: offer.imageUrl,
                discount: offer.discount,
                buttonText: offer.buttonText,
                onTap: () {
                  controller.openOffer(offer);
                },
              );
            },
            options: CarouselOptions(
              height: 210,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: .95,
              autoPlayInterval: const Duration(seconds: 4),
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.offers.length,
                  (index) {
                final selected = currentIndex == index;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: selected ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xff7B6BFF)
                        : Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}