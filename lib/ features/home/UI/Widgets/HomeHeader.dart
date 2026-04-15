import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/routing/routes.dart';
import '../../Model/Category_Model.dart';
import '../../controller/Home_Controller.dart';
import 'CategoryItem.dart';

class HomeHeader extends StatelessWidget {
  HomeHeader({super.key, required this.scaffoldKey});

  final controller = Get.find<HomeController>();
  final GlobalKey<ScaffoldState> scaffoldKey;
  CategoryModel? category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05), // 🔥 Glass effect
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        border: Border.all(color: Colors.white.withOpacity(0.1)), // 🔥 subtle border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔝 Top Icons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      scaffoldKey.currentState?.openDrawer();
                    },
                    icon: const Icon(Icons.menu, color: Colors.white),
                  );
                },
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.notification);
                    },
                    icon: const Icon(Icons.notifications_none,
                        color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.favourites);
                    },
                    icon: const Icon(Icons.favorite_border,
                        color: Colors.white),
                  ),
                ],
              )
            ],
          ),

          const Text(
            "Welcome 👋",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          /// 🔥 Gradient Title (محافظ عليه)
          Text(
            "Find Your Style.",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [
                    Color(0xFFFF7CA3),
                    Color(0xFF8F7CFF),
                  ],
                ).createShader(
                  const Rect.fromLTWH(0, 0, 300, 50),
                ),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Premium Accessories & Hoodies",
            style: TextStyle(color: Colors.white60),
          ),

          const SizedBox(height: 20),

          /// 🔍 Search Bar (Glass أقوى)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: const [
                Icon(Icons.search, color: Colors.white60),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search products...",
                      hintStyle: TextStyle(color: Colors.white60),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Icon(Icons.tune, color: Colors.white60),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// 🧿 Categories
          SizedBox(
            height: 110,
            child: Obx(() {
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.categories.length,
                separatorBuilder: (context, index) =>
                const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final category = controller.categories[index];

                  return InkWell(
                    onTap: () {
                      if (category.name == "Hoodies") {
                        Get.toNamed(AppRoutes.hoodies);
                      } else if (category.name ==
                          "Women Accessories") {
                        Get.toNamed(AppRoutes.womenAccessories);
                      } else if (category.name ==
                          "Men Accessories") {
                        Get.toNamed(AppRoutes.menAccessories);
                      } else if (category.name == "Bags") {
                        Get.toNamed(AppRoutes.bags);
                      }
                    },
                    child: CategoryItem_Widget(
                      title: category.name,
                      image: category.image,
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}