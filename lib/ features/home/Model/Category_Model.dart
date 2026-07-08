class CategoryModel {
  final String id;
  final String name;
  final String imageUrl;

  final int sortOrder;
  final bool isFeatured;
  final bool isActive;

  final DateTime createdAt;
  final DateTime? updatedAt;

  final int productsCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.sortOrder,
    required this.isFeatured,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
    required this.productsCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',

      name: json['name'] ?? '',

      imageUrl: json['image_url'] ??
          'https://via.placeholder.com/150',

      sortOrder: json['sort_order'] ?? 0,

      isFeatured: json['is_featured'] ?? false,

      isActive: json['is_active'] ?? true,

      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),

      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,

      productsCount: json['products_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'sort_order': sortOrder,
      'is_featured': isFeatured,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'products_count': productsCount,
    };
  }
}