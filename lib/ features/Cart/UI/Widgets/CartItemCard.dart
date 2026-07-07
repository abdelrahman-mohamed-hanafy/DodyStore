import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../Models/CartItem.dart';
import '../../Controller/cart_controller.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final int index;
  final CartController controller;

  const CartItemCard({
    super.key,
    required this.item,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(.08),
        ),
      ),
      child: Row(
        children: [

          /// Product Image
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child:ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: item.productImage,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (_, __, ___) =>
                const Icon(Icons.image_not_supported),
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// Product Info
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  item.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    Text(
                      "Color: ",
                      style: TextStyle(
                        color: Colors.white.withOpacity(.7),
                      ),
                    ),

                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: controller.hexToColor(item.color),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white24,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  "Size: ${item.size}",
                  style: const TextStyle(
                    color: Color(0xFF8F7CFF),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                /// Quantity Buttons
                Container(
                  height: 36,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.06),
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            controller.decreaseQuantity(index),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),

                      Text(
                        item.quantity.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),

                      GestureDetector(
                        onTap: () =>
                            controller.increaseQuantity(index),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          /// Price + Delete
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.end,
            children: [

              GestureDetector(
                onTap: () =>
                    controller.removeItem(index),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(.06),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.white70,
                    size: 18,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              Text(
                "\$${(item.price * item.quantity).toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}