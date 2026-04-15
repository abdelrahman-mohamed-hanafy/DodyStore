import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../core/services/Supabase_Service.dart';
import '../../../core/services/hive_service.dart';
import '../Models/Product.dart';
import '../UI/states/Product_States.dart';

class ProductDetailsController extends GetxController {
  final pageController = PageController();

  late String productId;

  final selectedImage = 0.obs;
  final selectedSize = ''.obs;
  final selectedColor = ''.obs;

  final supaService = Get.find<SupabaseService>();
  final hive = Get.find<HiveService>();

  final state = Rx<ProductStates>(ProductIdle());

  Product? product;

  @override
  void onInit() {
    productId = Get.arguments;
    fetchProductById();
    super.onInit();
  }

  Future<void> fetchProductById() async {
    try {
      state.value = ProductLoading();

      final box = hive.productsBox;

      final cached = box.get(productId);

      if (cached != null) {
        final fixedMap = Map<String, dynamic>.from(cached);

        product = Product.fromJson(
          fixedMap['id'],
          fixedMap,
        );

        state.value = ProductSuccess('from cache');
        return;
      }

      final result = await supaService.getProductById(productId);
      print(result);

      if (result.error != null) {
        throw Exception(result.error);
      }

      final newProduct = result.data!;
      product = newProduct;

      await box.put(productId, {
        'id': newProduct.id,
        'name': newProduct.name,
        'new_price': newProduct.price,
        'old_price': newProduct.oldPrice,
        'images': newProduct.images,
        'sizes': newProduct.sizes,
        'colors': newProduct.colors,
        'category_id': newProduct.categoryId,
        'category_name': newProduct.categoryName, // ✅ مهم
        'updated_at': newProduct.updatedAt?.toIso8601String(),
      });

      state.value = ProductSuccess('from server');
    } catch (e) {
      state.value = ProductError(e.toString());
    }
  }

  void changeImage(int index) {
    selectedImage.value = index;
  }

  void selectSize(String size) {
    selectedSize.value = size;
  }

  void selectColor(String color) {
    selectedColor.value = color;
  }

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    return Color(int.parse("0xFF$hex"));
  }
}