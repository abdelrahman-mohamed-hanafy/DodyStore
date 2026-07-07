class CategoryModel {
  final String id;
  final String name;
  final String image;
  final DateTime createdAt;
  final int productsCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.productsCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',

      name: json['name'] ?? 'Unknown',

      image: json['image'] ??
          'https://via.placeholder.com/150',

      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),

      productsCount: json['products_count'] ?? json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'created_at': createdAt.toIso8601String(),
      'products_count': productsCount,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? image,
    DateTime? createdAt,
    int? productsCount,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      productsCount: productsCount ?? this.productsCount,
    );
  }
}