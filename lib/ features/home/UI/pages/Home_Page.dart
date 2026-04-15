import 'package:dody_store/core/theme/AppBackground.dart';
import 'package:dody_store/core/utils/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../controller/DrawerController.dart';
import '../../controller/Home_Controller.dart';
import '../../../../core/widgets/CustomDrawer.dart';
import '../Widgets/HomeHeader.dart';
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
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔝 HEADER
                HomeHeader(scaffoldKey: scaffoldKey),

                const SizedBox(height: 10),

                /// 🔥 TITLE
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '🔥 Trending Now',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// 🔥 PRODUCTS
                SizedBox(
                  height: 230,
                  child: Obx(() {
                    final state = controller.state.value;

                    /// 🔄 LOADING
                    if (state is Loading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }

                    /// ❌ ERROR
                    if (state is HomeError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    final products = controller.products;

                    /// 🟡 EMPTY
                    if (products.isEmpty) {
                      return const Center(
                        child: Text("No Products Found"),
                      );
                    }

                    /// ✅ SUCCESS
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return TrendingProductCard(product: product);
                      },
                    );
                  }),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}