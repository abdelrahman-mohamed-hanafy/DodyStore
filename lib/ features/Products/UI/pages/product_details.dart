import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../auth/UI/state/Auth_state.dart';
import '../../controller/ProductDetailsController.dart';
import '../widgets/circleIcon.dart';

class ProductDetails extends StatelessWidget {
  ProductDetails({super.key});

  final controller = Get.find<ProductDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C29),

      body: Obx(() {

        if (controller.state.value is Loading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (controller.state.value is Error) {
          return Center(
            child: Text(
              (controller.state.value as Error).message,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        if (controller.product == null) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        final product = controller.product!;

        return Stack(
          children: [

            /// 🖼️ IMAGES
            SizedBox(
              height: 500,
              child: PageView.builder(
                controller: controller.pageController,
                itemCount:
                product.images.isEmpty ? 1 : product.images.length,
                onPageChanged: (index) {
                  controller.selectedImage.value = index;
                },
                itemBuilder: (context, index) {
                  return product.images.isEmpty
                      ? Image.asset(
                    "assets/images/placeholder.png",
                    fit: BoxFit.cover,
                  )
                      : CachedNetworkImage(
                    imageUrl: product.images[index],
                    fit: BoxFit.cover,
                    fadeInDuration:
                    const Duration(milliseconds: 300),
                    placeholder: (context, url) => Container(
                      color: const Color(0xFF0F0C29),
                      child: const Center(
                        child: CircularProgressIndicator(
                            color: Colors.white),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error,
                        size: 40, color: Colors.white),
                  );
                },
              ),
            ),

            /// 🔙 BACK
            Positioned(
              top: 50,
              left: 15,
              child: CircleIcon(
                icon: Icons.arrow_back_ios_new,
                onTap: () => Get.back(),
              ),
            ),

            /// ❤️ FAVORITE
            Positioned(
              top: 50,
              right: 15,
              child: CircleIcon(
                icon: Icons.favorite_border,
                onTap: () {},
              ),
            ),

            /// 🔵 DOTS
            Positioned(
              bottom: 250,
              left: 0,
              right: 0,
              child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  product.images.length,
                      (index) => AnimatedContainer(
                    duration:
                    const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 4),
                    width:
                    controller.selectedImage.value == index
                        ? 12
                        : 6,
                    height:
                    controller.selectedImage.value == index
                        ? 12
                        : 6,
                    decoration: BoxDecoration(
                      color: controller.selectedImage.value ==
                          index
                          ? Colors.white
                          : Colors.white38,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              )),
            ),

            /// 🔥 DETAILS (نفس الخلفية)
            DraggableScrollableSheet(
              initialChildSize: 0.55,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              builder: (_, scrollController) {
                return Container(
                  padding: const EdgeInsets.all(20),
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
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        /// 🏷️ NAME
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 5),

                        /// 📂 CATEGORY
                        Text(
                          product.categoryName ?? '',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.6)),
                        ),

                        const SizedBox(height: 15),

                        /// 💰 PRICE
                        Row(
                          children: [
                            Text(
                              "\$${product.price}",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (product.oldPrice >
                                product.price)
                              Text(
                                "\$${product.oldPrice}",
                                style: TextStyle(
                                  decoration:
                                  TextDecoration.lineThrough,
                                  color:
                                  Colors.white.withOpacity(0.4),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        /// 🎨 COLORS
                        const Text(
                          "Colors",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),

                        const SizedBox(height: 10),

                        Obx(() => Row(
                          children: List.generate(
                            product.colors.length,
                                (index) {
                              final color =
                              product.colors[index];
                              final isSelected =
                                  controller.selectedColor
                                      .value ==
                                      color;

                              return GestureDetector(
                                onTap: () => controller
                                    .selectedColor.value = color,
                                child: Container(
                                  margin:
                                  const EdgeInsets.only(
                                      right: 12),
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: controller
                                        .hexToColor(color),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.white24,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )),

                        const SizedBox(height: 25),

                        /// 📏 SIZE
                        const Text(
                          "Sizes",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),

                        const SizedBox(height: 10),

                        Obx(() => Wrap(
                          spacing: 10,
                          children:
                          product.sizes.map((size) {
                            final isSelected =
                                controller.selectedSize
                                    .value ==
                                    size;

                            return GestureDetector(
                              onTap: () => controller
                                  .selectedSize.value = size,
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF8F7CFF)
                                      : Colors.transparent,
                                  borderRadius:
                                  BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white
                                        .withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  size,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        )),

                        const SizedBox(height: 30),

                        /// 🛒 BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              if (controller
                                  .selectedSize.isEmpty ||
                                  controller
                                      .selectedColor.isEmpty) {
                                Get.snackbar("Error",
                                    "Select size & color");
                                return;
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(0xFF8F7CFF),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "Add to Cart",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Center(
                          child: Text(
                            "Free shipping on orders over \$50",
                            style: TextStyle(
                                color: Colors.white
                                    .withOpacity(0.5)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}