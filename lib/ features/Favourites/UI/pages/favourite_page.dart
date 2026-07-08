import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/AppBackground.dart';
import '../../../home/UI/Widgets/TrendingProductCard.dart';
import '../../controller/favourite_controller.dart';

class FavouritePage extends StatelessWidget {
  final controller = Get.find<FavouriteController>();
   FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {

        if (controller.favourites.isEmpty) {
          return const Center(
            child: Text(
              "No favourite products",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: RefreshIndicator(
            onRefresh: () async {
              controller.refreshFavourite();
            },
            child: GridView.builder(

                itemCount: controller.favourites.length,

                itemBuilder:(context,index){

                  final product = controller.favourites[index];

                  return TrendingProductCard(
                    product: product,
                  );

                }, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.7,
                )

            ),
          ),
        );

      }),
    ));
  }
}