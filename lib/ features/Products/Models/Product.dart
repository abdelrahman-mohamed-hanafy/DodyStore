class Product {
  final String id;

  final String name;
  final String description;

  final double price;
  final double oldPrice;

  final String thumbnail;
  final List<String> images;

  final List<String> colors;
  final List<String> sizes;

  final int stock;

  final double rating;
  final int ratingCount;
  final int soldCount;

  final bool isFeatured;
  final int featuredPriority;
  final bool isNew;
  final bool isActive;

  final String categoryId;
  final String? categoryName;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.thumbnail,
    required this.images,
    required this.colors,
    required this.sizes,
    required this.stock,
    required this.rating,
    required this.ratingCount,
    required this.soldCount,
    required this.isFeatured,
    required this.featuredPriority,
    required this.isNew,
    required this.isActive,
    required this.categoryId,
    this.categoryName,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(
      String id,
      Map<String, dynamic> json,
      ) {
    return Product(
      id: id,

      name: json['name'] ?? '',
      description: json['description'] ?? '',

      price: (json['price'] ?? 0).toDouble(),
      oldPrice: (json['old_price'] ?? 0).toDouble(),

      thumbnail: json['thumbnail'] ?? '',

      images: List<String>.from(json['images'] ?? const []),
      colors: List<String>.from(json['colors'] ?? const []),
      sizes: List<String>.from(json['sizes'] ?? const []),

      stock: json['stock'] ?? 0,

      rating: (json['rating'] ?? 0).toDouble(),
      ratingCount: json['rating_count'] ?? 0,
      soldCount: json['sold_count'] ?? 0,

      isFeatured: json['is_featured'] ?? false,
      featuredPriority: json['featured_priority'] ?? 0,

      isNew: json['is_new'] ?? false,
      isActive: json['is_active'] ?? true,

      categoryId: json['category_id'] ?? '',
      categoryName:
      json['categories']?['name'] ??
          json['category_name'],

      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,

      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'name': name,
      'description': description,

      'price': price,
      'old_price': oldPrice,

      'thumbnail': thumbnail,

      'images': images,
      'colors': colors,
      'sizes': sizes,

      'stock': stock,

      'rating': rating,
      'rating_count': ratingCount,
      'sold_count': soldCount,

      'is_featured': isFeatured,
      'featured_priority': featuredPriority,

      'is_new': isNew,
      'is_active': isActive,

      'category_id': categoryId,
      'category_name': categoryName,

      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}