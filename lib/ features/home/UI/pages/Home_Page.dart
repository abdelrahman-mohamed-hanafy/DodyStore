import 'package:dody_store/core/theme/AppBackground.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/DrawerController.dart';
import '../../controller/Home_Controller.dart';
import '../../../../core/widgets/CustomDrawer.dart';
import '../Widgets/HomeHeader.dart';
import '../Widgets/ProductSection.dart';
import '../Widgets/TrendingProductCard.dart';
import '../states/home_states.dart';

class HomePage extends StatelessWidget {
  final controller = Get.find<HomeController>();
  final drawerController = Get.find<DrawerControllerX>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          key: scaffoldKey,
          drawer: CustomDrawer(),
          body: RefreshIndicator(
            onRefresh: controller.refreshHomePage,
            child: SingleChildScrollView(
              controller: controller.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔝 HEADER
                  HomeHeader(scaffoldKey: scaffoldKey),

                  const SizedBox(height: 10),

                  /// 🔥 TITLE
                   Obx(() {
                    final state = controller.state.value;

                    if (state is Loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is HomeError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return Column(
                      children: [

                        ProductSection(
                          title: "⭐ Featured Products",
                          products: controller.featuredProducts,
                        ),

                        ProductSection(
                          title: "🆕 New Arrivals",
                          products: controller.newProducts,
                        ),

                        ProductSection(
                          title: "🔥 Best Sellers",
                          products: controller.bestSellerProducts,
                        ),

                        ProductSection(
                          title: "💸 Hot Deals",
                          products: controller.dealsProducts,
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}