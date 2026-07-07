import 'package:dody_store/core/utils/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Cart/Controller/cart_controller.dart';
import '../../../main/Controller/main_controller.dart';

class ProductPageHeader extends StatelessWidget {
  const ProductPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        color: Colors.white.withOpacity(0.02),

        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) =>
                          IconButton(
                            onPressed: () => Scaffold.of(context).openDrawer(),
                            icon: Icon(
                              Icons.menu, color: Colors.white, size: 30,),
                          ),
                    ),
                    Obx(() {
                      final cartController = Get.find<CartController>();
                      return
                      cartController.cartItems.isEmpty?IconButton(
                      alignment: Alignment.topRight,
                      onPressed: () {
                        final mainController = Get.find<MainController>();
                        mainController.changeIndex(2);
                      }, icon: Icon(Icons.remove_shopping_cart_rounded, color: Colors.white
                          .withOpacity(0.9),
                        size: 30,),):
                       IconButton(
                        alignment: Alignment.topRight,
                        onPressed: () {
                          final mainController = Get.find<MainController>();
                          mainController.changeIndex(2);
                        }, icon: Icon(Icons.shopping_cart, color: Colors.white
                          .withOpacity(0.9),
                        size: 30,),);
                    })
                  ],
                ),
              ],
            ),
          ),

          /// 🔍 SEARCH BAR (GLASS)
          Positioned(
            bottom: -25,
            left: 20,
            right: 20,
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                readOnly: true,
                onTap: () => Get.toNamed(AppRoutes.search),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
