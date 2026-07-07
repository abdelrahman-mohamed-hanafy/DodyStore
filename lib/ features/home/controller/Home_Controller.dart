import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/Supabase_Service.dart';
import '../../../core/services/hive_service.dart';
import '../../../core/utils/routing/routes.dart';
import '../../Products/Models/Product.dart';
import '../../Products/controller/ProductController.dart';
import '../../main/Controller/main_controller.dart';
import '../Model/Category_Model.dart';
import '../Model/OfferActionType.dart';
import '../Model/OfferModel.dart';
import '../UI/states/home_states.dart';

class HomeController extends GetxController {
  final pageController = PageController();
  final hive = Get.find<HiveService>();
  final supaService = Get.find<SupabaseService>();
  final mainController = Get.find<MainController>();
  final productController = Get.find<ProductController>();
  final RxString userName = ''.obs;
  final favorites = <String>{}.obs;
  final notificationCount = 2.obs;
  final favoriteCount = 5.obs;
  final offers = <OfferModel>[].obs;

  final state = Rx<HomeStates>(Idle());

  final products = <Product>[].obs;
  final categories = <CategoryModel>[].obs;
  CategoryModel? category;
  @override
  Future<void> onInit() async {
    super.onInit();
    _init();

  }

  Future<void> _init() async {
    await loadCategoriesFromCache();
    await loadProductsFromCache();
    await getCurrentUserName();
    await getOffers();

    if (products.isNotEmpty) {
      state.value = Success({
        "categories": categories,
        "products": products,
      });
    }

    await loadHomeData();
  }
  // == Load Categories From CACHE ==
  Future<void> loadCategoriesFromCache() async {
    final box = hive.homeCategoriesBox;

    categories.value = box.values
        .map((e) => CategoryModel.fromJson(
      Map<String, dynamic>.from(e),
    ))
        .toList();
  }
  // == LoadProductsFromCache ==
  Future<void> loadProductsFromCache() async {
    final box = hive.homeProductsBox;
    products.value = box.values
        .map((e) => Product.fromJson(
      e['id'],
      Map<String, dynamic>.from(e),
    ))
        .toList();
  }
  // ================== MAIN ==================
  Future<void> loadHomeData() async {
    try {
      await Future.wait([
        fetchCategories(),
        fetchRandomProductsFromAllCategories(),
      ]);

      state.value = Success({
        "categories": categories,
        "products": products,
      });

    }catch (e) {
      if (products.isEmpty) {
        state.value = HomeError(e.toString());
      } else {
        state.value = Success({
          "categories": categories,
          "products": products,
        });
      }
    }
  }

  // ================== CATEGORIES ==================
  Future<void> fetchCategories() async {
    final result = await supaService.getCategoriesWithCount();
    if (!result.isSuccess) {
      throw Exception(result.error);
    }

    categories.value = (result.data as List)
        .map((e) => CategoryModel.fromJson(e))
        .toList();
    await hive.homeCategoriesBox.clear();

    for (var category in result.data!) {
      await hive.homeCategoriesBox.put(
        category['id'],
        category,
      );
    }
  }

  Future<void> fetchRandomProductsFromAllCategories() async {
    final result = await supaService.getProducts(limit: 10);

    if (!result.isSuccess) {
      throw Exception(result.error);
    }

    products.value = result.data!;

    await hive.homeProductsBox.clear();

    for (var product in result.data!) {
      await hive.homeProductsBox.put(product.id, {
        'id': product.id,
        'name': product.name,
        'new_price': product.price,
        'old_price': product.oldPrice,
        'images': product.images,
        'sizes': product.sizes,
        'colors': product.colors,
        'category_id': product.categoryId,
        'category_name': product.categoryName,
      });
    }
  }

  // ================== FAVORITES ==================
  void toggleFavorite(String productId) {
    favorites.contains(productId)
        ? favorites.remove(productId)
        : favorites.add(productId);
  }

  bool isFavorite(String productId) => favorites.contains(productId);

   // from time Good Morning, Good Afternoon, Good Evening
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
  // getCurrentUserName
  Future<void> getCurrentUserName() async {
    final user = await supaService.getCurrentUser();

    if (user != null) {
      userName.value = user.name;
    }
  }
  // ================== OFFERS ==================
  Future<void> getOffers() async {
    final response = await supaService.getOffers();

    if (response.error != null) {
      print("Error fetching offers: ${response.error}");
      Get.snackbar(
        "Error",
        response.error!,
      );
      return;
    }

    offers.assignAll(response.data ?? []);
  }
  void openOffer(OfferModel offer) {
    print("Action Type: ${offer.actionType}");
    print("Action Id: ${offer.actionId}");
    switch (offer.actionType) {

      case OfferActionType.product:
        Get.toNamed(
          AppRoutes.productDetails,
          arguments: offer.actionId,
        );
        break;

      case OfferActionType.category:
        if (offer.actionId != null) {
          productController.selectCategory(offer.actionId!);
          mainController.changeIndex(1);
        }
        break;

      case OfferActionType.offers:
        Get.toNamed(AppRoutes.offersPage);
        break;

      case OfferActionType.none:
        break;
    }
  }
  // ================== CLEANUP ==================
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}