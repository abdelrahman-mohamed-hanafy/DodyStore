import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ features/main/Controller/main_controller.dart';
import '../utils/routing/routes.dart';
import '../../ features/home/controller/DrawerController.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  final controller = Get.find<DrawerControllerX>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [

          /// 🎨 Gradient Base
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F0C29),
                  Color(0xFF302B63),
                  Color(0xFF24243E),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          /// 💜 Glow Top
          Positioned(
            top: -80,
            left: -40,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withOpacity(0.4),
              ),
            ),
          ),

          /// 💗 Glow Bottom
          Positioned(
            bottom: -80,
            right: -40,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.pink.withOpacity(0.4),
              ),
            ),
          ),

          /// 🌫 Blur (المهم)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: Container(color: Colors.transparent),
          ),

          /// 📦 Content
          Column(
            children: [

              /// 🔝 Header
              Obx(() {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        backgroundImage:
                        controller.userImage.value.isNotEmpty
                            ? NetworkImage(controller.userImage.value)
                            : null,
                        child: controller.userImage.value.isEmpty
                            ? const Icon(Icons.person,
                            color: Colors.white70)
                            : null,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Welcome 👋",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        controller.userName.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const Divider(color: Colors.white24),

              /// 📌 Items
              drawerItem("Home", Icons.home, AppRoutes.home),
              drawerItem("Products", Icons.storefront, AppRoutes.productPage),
              drawerItem("Cart", Icons.shopping_cart, AppRoutes.cart),
              drawerItem("Favourites", Icons.favorite, AppRoutes.favourites),
              drawerItem("Notifications", Icons.notifications, AppRoutes.notification),

              /// 🌙 Dark Mode
              Obx(() {
                return SwitchListTile(
                  value: controller.isDark.value,
                  onChanged: (val) => controller.toggleTheme(),
                  title: const Text(
                    "Dark Mode",
                    style: TextStyle(color: Colors.white),
                  ),
                  secondary: const Icon(Icons.dark_mode,
                      color: Colors.white70),
                  activeColor: Color(0xFF8F7CFF),
                );
              }),

               SizedBox(height: 60,),
              drawerItem("Profile", Icons.settings, AppRoutes.profile),

              drawerItem(
                "Logout",
                Icons.logout,
                "",
                color: Color(0xFFFF7CA3),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔥 Drawer Item
  Widget drawerItem(String title, IconData icon, String route,
      {Color color = Colors.white}) {
    return Obx(() {
      final isSelected = controller.currentRoute.value == route;

      return ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(color: color),
        ),
        tileColor: isSelected
            ? Colors.white.withOpacity(0.08)
            : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
          onTap: () {
            Get.back();

            switch (title) {
              case "Home":
                Get.find<MainController>().changeIndex(0);
                break;
              case "Products":
                Get.find<MainController>().changeIndex(1);
                break;
              case "Cart":
                Get.find<MainController>().changeIndex(2);
                break;
              case "Profile":
                Get.find<MainController>().changeIndex(3);
                break;
            }
          }
      );
    });
  }
}