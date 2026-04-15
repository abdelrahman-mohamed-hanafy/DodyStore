class Product {
  final String id;
  final String name;

  final double price;
  final double oldPrice;

  final List<String> images;
  final List<String> sizes;
  final List<String> colors;

  final String categoryId;
  final String? categoryName; // ✅ ADD THIS

  final DateTime? updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.images,
    required this.sizes,
    required this.colors,
    required this.categoryId,
    required this.categoryName, // ✅ ADD THIS
    required this.updatedAt,
  });

  factory Product.fromJson(String id, Map<String, dynamic> json) {
    return Product(
      id: id,
      name: json['name'] ?? '',

      price: (json['new_price'] ?? 0).toDouble(),
      oldPrice: (json['old_price'] ?? 0).toDouble(),

      images: List<String>.from(json['images'] ?? []),
      sizes: List<String>.from(json['sizes'] ?? []),
      colors: List<String>.from(json['colors'] ?? []),

      categoryId: json['category_id'] ?? '',

      categoryName: json['categories']?['name'] ?? json['category_name'],
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'new_price': price,
      'old_price': oldPrice,
      'images': images,
      'sizes': sizes,
      'colors': colors,
      'category_id': categoryId,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}