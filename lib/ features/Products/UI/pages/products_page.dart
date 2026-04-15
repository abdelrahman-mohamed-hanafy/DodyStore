import 'package:dody_store/core/theme/AppBackground.dart';
import 'package:dody_store/core/widgets/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../main/Controller/main_controller.dart';
import '../../controller/ProductController.dart';
import '../states/Product_States.dart';
import '../widgets/CategoryCard.dart';
import '../widgets/Product_Card.dart';
import '../widgets/product_page_Header.dart';

class ProductsPage extends StatelessWidget {
  ProductsPage({super.key});

  final controller = Get.find<ProductController>();
  final mainController = Get.find<MainController>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        mainController.changeIndex(0);
        return false;
      },
      child: AppBackground(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            drawer: CustomDrawer(),
            backgroundColor: Colors.transparent,
            body: Stack(
                children: [
            SingleChildScrollView(
            padding: const EdgeInsets.only(top: 160),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                const SizedBox(height: 60),

            Obx(() {
              final state = controller.state.value;

              /// 🔥 Loading
              if (state is ProductLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              /// 🔥 Error
              if (state is ProductError) {
                return Center(
                  child: Text(state.message),
                );
              }

              /// 🔥 Success
              if (state is ProductSuccess) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: controller.categories.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.8,
                  ),
                  itemBuilder: (context, index) {
                    final category =
                    controller.categories[index];
                    return CategoryCard(category: category);
                  },
                );
              }

              return const SizedBox();
            }),
            Padding(
              padding: const EdgeInsets.only(left: 16.0,top: 16.0),
              child: Text('Popular Products',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.white)),
            ),
                  SizedBox(height: 4.0,),
                  Obx(() {
                    return GridView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.products.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.9,
                      ),
                      itemBuilder: (context, index) {
                        final product = controller.products[index];

                        return ProductCard(
                          product: product,
                          isFavorite: controller.isFavorite(product.id),
                          onFavoriteToggle: () {
                            controller.toggleFavorite(product.id);
                          },
                        );
                      },
                    );
                  })
            ],
          ),
        ),

        const ProductPageHeader(),
        ],
        ),
        ),
        ),
      ),
    );
  }
}