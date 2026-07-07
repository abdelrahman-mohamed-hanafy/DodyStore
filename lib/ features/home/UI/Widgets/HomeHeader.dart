import 'package:dody_store/core/widgets/badge_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/routing/routes.dart';
import '../../../Products/controller/ProductController.dart';
import '../../../main/Controller/main_controller.dart';
import '../../Model/Category_Model.dart';
import '../../controller/Home_Controller.dart';
import 'CategoryItem.dart';
import 'HomeOfferSlider.dart';

class HomeHeader extends StatelessWidget {
  HomeHeader({super.key, required this.scaffoldKey});

  final controller = Get.find<HomeController>();
  final mainController = Get.find<MainController>();
  final productController = Get.find<ProductController>();

  final GlobalKey<ScaffoldState> scaffoldKey;
  CategoryModel? category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔝 Top Icons Row
        Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              FocusScope.of(context).unfocus();
              scaffoldKey.currentState?.openDrawer();
            },
            child: const SizedBox(
              width: 42,
              height: 42,
              child: Icon(
                Icons.menu_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Obx(
                  () => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${controller.getGreeting()} 👋",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    controller.userName.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Obx(
                () => BadgeIcon(
              icon: Icons.notifications_none_rounded,
              count: controller.notificationCount.value,
              onTap: () => Get.toNamed(AppRoutes.notification),
            ),
          ),

          const SizedBox(width: 8),

          Obx(
                () => BadgeIcon(
              icon: Icons.favorite_border_rounded,
              count: controller.favoriteCount.value,
              onTap: () => Get.toNamed(AppRoutes.favourites),
            ),
          ),
        ],
      ),
          const SizedBox(height: 8),
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
              children: [
                const Icon(Icons.search, color: Colors.white60),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onTap: () => Get.toNamed(AppRoutes.search),
                    readOnly: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Search products...",
                      hintStyle: TextStyle(color: Colors.white60),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const Icon(Icons.tune, color: Colors.white60),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const HomeOfferSlider(),

          const SizedBox(height: 20),
          Text('Categories', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
          const SizedBox(height: 8.0),

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
                      productController.selectCategory(category.id);
                      mainController.changeIndex(1);
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