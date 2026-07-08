import 'package:flutter/material.dart';

import '../../../Products/Models/Product.dart';
import 'TrendingProductCard.dart';

class ProductSection extends StatelessWidget {
  final String title;
  final List<Product> products;

  const ProductSection({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (_, index) {
              return TrendingProductCard(
                product: products[index],
              );
            },
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}