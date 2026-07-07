import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/CustomDrawer.dart';
import '../../Controller/main_controller.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      backgroundColor: Colors.transparent,
        extendBody: true,
      body: Obx(() {
        return IndexedStack(
          index: controller.currentIndex.value,
          children:
          controller.pages.map((page) => page()).toList(),
        );
      }),

      bottomNavigationBar: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 20,
                sigmaY: 20,
              ),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
                  children: List.generate(controller.pages.length, (index) {
                    final icons = [
                      Icons.home,
                      Icons.storefront,
                      Icons.shopping_cart,
                      Icons.list_alt,
                      Icons.person,
                    ];

                    final labels = [
                      "Home",
                      "Products",
                      "Cart",
                      "My Orders",
                      "Profile",
                    ];

                    bool isSelected = controller.currentIndex.value == index;

                    return GestureDetector(
                      onTap: () =>
                          controller.changeIndex(index),
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [

                          Icon(
                            icons[index],
                            color: isSelected
                                ? const Color(0xFFFF7CA3)
                                : Colors.white60,
                          ),

                          const SizedBox(height: 4),

                          Text(
                            labels[index],
                            style: TextStyle(
                              color: isSelected
                                  ? const Color(0xFF8F7CFF)
                                  : Colors.white38,
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}