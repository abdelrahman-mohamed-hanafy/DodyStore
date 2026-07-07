import 'package:dody_store/%20features/Cart/UI/Widgets/CartItemCard.dart';
import 'package:dody_store/core/theme/AppBackground.dart';
import 'package:dody_store/core/widgets/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controller/cart_controller.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: CustomDrawer(),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white,size: 30),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: ListView(
            children: [
              Obx(() {
                if (controller.cartItems.isEmpty) {
                  return Column(
                    children: [
                      const SizedBox(height: 300),
                      const Center(
                        child: Text('Your cart is empty', style: TextStyle(
                            color: Colors.white, fontSize: 22),),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      ...controller.cartItems.map((item) {
                        final index = controller.cartItems.indexOf(item);
                        return CartItemCard(
                            item: item, index: index, controller: controller
                        );
                      }),

                    ],
                  );
                }
              }),
              const SizedBox(height: 20),
              Obx(() {
                return
                  controller.cartItems.isEmpty ? SizedBox.shrink() :
                  Row(
                    children: [
                      SizedBox(width: 8.0,),
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.09),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: TextField(
                            controller: controller.promoController,
                            decoration: InputDecoration(
                              hintText: 'Enter promo code',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(.5),
                                fontSize: 14,
                              ),
                              prefixIcon: const Icon(
                                Icons.confirmation_number_outlined,
                                color: Colors.white54,
                                size: 18,
                              ),
                              suffixIcon:IconButton(onPressed: (){
                                controller.removePromoCode();
                              }, icon: Icon(Icons.delete)),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C4CF1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () async {
                              await controller.applyPromoCode(
                                controller.promoController.text,
                              );
                              FocusScope.of(context).unfocus();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Center(
                                child: Text(
                                  'Apply',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
              }),
              const SizedBox(height: 20),
              Obx(() {
                return
                  controller.cartItems.isEmpty ? SizedBox.shrink() :
                 Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withOpacity(0.09),
                    border: Border.all(
                      color: Colors.white.withOpacity(.5),
                    ),
                  ),
                  child: Obx(() =>
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subtotal (${controller.totalItems} items)',
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                '\$${controller.totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          /// Discount
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Discount',
                                style: TextStyle(
                                  color: Color(0xFF8B5CF6),
                                ),
                              ),
                              Text(
                                '-${controller.discountValue.value}%',
                                style: const TextStyle(
                                  color: Color(0xFF8B5CF6),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          /// Shipping
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Shipping',
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                '\$ ${controller.shippingPrice.value}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Divider(
                            color: Colors.white.withOpacity(.08),
                          ),

                          const SizedBox(height: 16),

                          /// Total
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                '\$${controller.finalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Color(0xFF8B5CF6),
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// Checkout Button
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7C4DFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Proceed to Checkout',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                );
              })
            ],),
        ),
      ),
    );
  }
}
