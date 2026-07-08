import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../core/services/Supabase_Service.dart';
import '../../../core/services/hive_service.dart';
import '../../Cart/Controller/cart_controller.dart';
import '../../Favourites/controller/favourite_controller.dart';
import '../../main/Controller/main_controller.dart';
import '../Models/Product.dart';
import '../UI/states/Product_States.dart';

class ProductDetailsController extends GetxController {
  final pageController = PageController();
  final favouriteController = Get.find<FavouriteController>();

  late String productId;

  final selectedImage = 0.obs;
  final selectedSize = ''.obs;
  final selectedColor = ''.obs;
  final supaService = Get.find<SupabaseService>();
  final hive = Get.find<HiveService>();
  final state = Rx<ProductStates>(ProductIdle());
  final isFavourite = false.obs;

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

  void addToCart(){
   final cartController = Get.find<CartController>();
   final mainController = Get.find<MainController>();
   if(product != null && selectedSize.value.isNotEmpty && selectedColor.value.isNotEmpty){
        cartController.addToCart(
          productImage: product!.images.first,
          productId: product!.id,
          productName: product!.name,
          color: selectedColor.value,
          size: selectedSize.value,
          price: product!.price,
        );
        Get.snackbar(
          "Success",
          "Product added to cart",
        );
        Get.until((route) => route.isFirst);
        mainController.changeIndex(2);
      }else{
        Get.snackbar('Error', 'Please select size and color');
      }
  }

  Future<void> addToFavourites() async {
    await addFavouriteToHive();
    favouriteController.addFavourite(product!);
  }

  // add favourite to favourites box in hive
  Future<void> addFavouriteToHive() async {
    final box = hive.favouriteProductsBox;
    await box.put(productId, {
      'id': product!.id,
      'name': product!.name,
      'new_price': product!.price,
      'old_price': product!.oldPrice,
      'images': product!.images,
      'sizes': product!.sizes,
      'colors': product!.colors,
      'category_id': product!.categoryId,
      'category_name': product!.categoryName,
      'updated_at': product!.updatedAt?.toIso8601String(),
    });
  }
  // // add favourite to supabase
  // Future<void> addFavouriteToSupabase() async {
  //   final result = await supaService.addFavourite(
  //     productId: product!.id,
  //     productName: product!.name,
  //     productImage: product!.images.first,
  //     color: selectedColor.value,
  //     size: selectedSize.value,
  //     price: product!.price,
  //   );
  //   if (result.error != null) {
  //     throw Exception(result.error);
  //   }
  // }

  void toggleFavourite() {
    isFavourite.value = !isFavourite.value;
    if (isFavourite.value) {
      addToFavourites();
    } else {
      favouriteController.removeFavourite(product!);
    }
  }
  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    return Color(int.parse("0xFF$hex"));
  }
}