import 'package:dody_store/core/services/Supabase_Service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/services/hive_service.dart';
import '../Models/CartItem.dart';

class CartController extends GetxController{
  RxList<CartItem> cartItems = <CartItem>[].obs;
   final hive = Get.find<HiveService>();
   final supabaseService = Get.find<SupabaseService>();
   RxInt discountValue = 0.obs;
  RxString appliedPromoCode = ''.obs;
  RxDouble shippingPrice = 0.0.obs;
  final promoController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    loadCartItems();
    loadShippingPrice();
  }

  Future<void> addToCart({
    required String productId,
    required String productName,
    required String productImage,
    required String color,
    required String size,
    required double price,
  }) async {
    final key = '${productId}_${color}_$size';

    final existingItem = hive.cartBox.get(key);

    if (existingItem != null) {
      existingItem['quantity']++;

      await hive.cartBox.put(
        key,
        existingItem,
      );
    } else {
      await hive.cartBox.put(
        key,
        {
          'productId': productId,
          'productName': productName,
          'productImage': productImage,
          'color': color,
          'size': size,
          'quantity': 1,
          'price': price,
        },
      );
    }

    await loadCartItems();
  }
  Future<void> loadCartItems() async {
    cartItems.assignAll(
      hive.cartBox.values.map((e) {
        return CartItem(
          productId: e['productId'],
          productName: e['productName'],
          productImage: e['productImage'],
          color: e['color'],
          size: e['size'],
          quantity: e['quantity'],
          price: (e['price'] as num).toDouble(),
        );
    }).toList());
  }
  // زيادة الكميه
  Future<void> increaseQuantity(int index) async {
    final item = cartItems[index];

    final key =
        '${item.productId}_${item.color}_${item.size}';

    final data = hive.cartBox.get(key);

    if (data != null) {
      data['quantity']++;

      await hive.cartBox.put(key, data);

      await loadCartItems();
    }
  }
  // تقليل الكميه
  Future<void> decreaseQuantity(int index) async {
    final item = cartItems[index];

    final key =
        '${item.productId}_${item.color}_${item.size}';

    final data = hive.cartBox.get(key);

    if (data == null) return;

    if (data['quantity'] > 1) {
      data['quantity']--;

      await hive.cartBox.put(key, data);
    } else {
      await hive.cartBox.delete(key);
    }

    await loadCartItems();
  }
  // حساب السعر الاجمالي
  double get totalPrice {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity),);
  }
  // حساب عدد العناصر
  int get totalItems {
    return cartItems.fold(0, (sum, item) => sum + item.quantity,);
  }
  // حذف عنصر من السلة
  Future<void> removeItem(int index) async {
    final item = cartItems[index];

    final key =
        '${item.productId}_${item.color}_${item.size}';

    await hive.cartBox.delete(key);

    await loadCartItems();
  }
  Future<void> applyPromoCode(String code) async {
    final result = await supabaseService.getPromoDiscount(code.trim());

    if (result.data != null) {
      discountValue.value = result.data!;
      appliedPromoCode.value = code;
      Get.snackbar(
        'Success',
        'Promo code applied',
      );
    }
    else {
      discountValue.value = 0;
      Get.snackbar(
        'Error',
        result.error ?? 'Invalid promo code',
      );
    }
  }
  Future<void> loadShippingPrice() async {
    shippingPrice.value = await supabaseService.getShippingPrice();
    print('Shipping Price = ${shippingPrice.value}');

  }
  double get finalPrice {
    final discountedPrice =
        totalPrice -
            (totalPrice * discountValue.value / 100);

    return discountedPrice +
        shippingPrice.value;
  }
  // إزالة كود الخصم
  void removePromoCode() {
    discountValue.value = 0;
    appliedPromoCode.value = '';
    promoController.clear();
  }
  // تحويل اللون من Hex إلى Color
  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    return Color(int.parse("0xFF$hex"));
  }

  @override
  void onClose() {
    promoController.clear();
    promoController.dispose();
    super.onClose();
  }

}