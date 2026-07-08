import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OfferSliderItem extends StatelessWidget {
  const OfferSliderItem({
    super.key,
    required this.title,
    required this.subTitle,
    required this.image,
    required this.discount,
    required this.buttonText,
    this.onTap,
  });

  final String title;
  final String subTitle;
  final String image;
  final int discount;
  final String buttonText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [
              Color(0xffFF6FA9),
              Color(0xff7B6BFF),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          child: Row(
            children: [

              /// LEFT
              Expanded(
                flex: 6,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      discount>0 ?
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "$discount% OFF",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ):SizedBox.shrink(),

                      const SizedBox(height: 12),

                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        subTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          buttonText,
                          style: const TextStyle(
                            color: Color(0xff7B6BFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 10),

              /// IMAGE
              Expanded(
                flex: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.cover,
                    height: 130,

                    placeholder: (context, url) =>
                    const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),

                    errorWidget: (context, url, error) =>
                    const Icon(
                      Icons.image_not_supported,
                      color: Colors.white54,
                    )
                  ),
                  )
                ),
            ],
          ),
        ),
      ),
    );
  }
}