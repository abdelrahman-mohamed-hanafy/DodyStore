class CartItem {
  final String productId;
  final String productName;

  final String color;
  final String size;
  final String productImage;

  int quantity;

  final double price;

  CartItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.color,
    required this.size,
    required this.quantity,
    required this.price,
  });
}