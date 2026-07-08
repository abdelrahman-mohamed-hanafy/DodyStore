import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../core/services/Supabase_Service.dart';
import '../../../core/services/hive_service.dart';
import '../../../core/utils/routing/routes.dart';
import '../../Favourites/controller/favourite_controller.dart';
import '../../Products/Models/Product.dart';
import '../../Products/controller/ProductController.dart';
import '../../main/Controller/main_controller.dart';
import '../Model/Category_Model.dart';
import '../Model/OfferActionType.dart';
import '../Model/OfferModel.dart';
import '../UI/states/home_states.dart';

class HomeController extends GetxController {
  final pageController = PageController();
  final ScrollController scrollController = ScrollController();
  final hive = Get.find<HiveService>();
  final supaService = Get.find<SupabaseService>();
  final mainController = Get.find<MainController>();
  final productController = Get.find<ProductController>();
  final favouriteController = Get.find<FavouriteController>();
  final RxString userName = ''.obs;
  final notificationCount = 2.obs;
  final offers = <OfferModel>[].obs;

  final state = Rx<HomeStates>(Idle());

  final categories = <CategoryModel>[].obs;

  final featuredProducts = <Product>[].obs;

  final newProducts = <Product>[].obs;

  final bestSellerProducts = <Product>[].obs;

  final dealsProducts = <Product>[].obs;
  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        mainController.hideBottomBar();
      }

      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        mainController.showBottomBar();
      }
    });
    _init();
  }

  Future<void> _init() async {
    await Future.wait([
      loadCategoriesFromCache(),
      loadFeaturedProductsFromCache(),
      loadNewProductsFromCache(),
      loadBestSellerProductsFromCache(),
      loadDealsProductsFromCache(),
      loadOffersFromCache(),
      getCurrentUserNameFromCache(),
    ]);

    if (
    categories.isNotEmpty ||
        featuredProducts.isNotEmpty ||
        newProducts.isNotEmpty ||
        bestSellerProducts.isNotEmpty ||
        dealsProducts.isNotEmpty ||
        offers.isNotEmpty
    ) {
      state.value = Success({
        "categories": categories,
        "featuredProducts": featuredProducts,
        "newProducts": newProducts,
        "bestSellerProducts": bestSellerProducts,
        "dealsProducts": dealsProducts,
        "offers": offers,
      });
    }

    try {
      await Future.wait([
        fetchCategories(),
        fetchFeaturedProducts(),
        fetchNewProducts(),
        fetchBestSellerProducts(),
        fetchDealsProducts(),
        getOffers(),
      ]);

      state.value = Success({
        "categories": categories,
        "featuredProducts": featuredProducts,
        "newProducts": newProducts,
        "bestSellerProducts": bestSellerProducts,
        "dealsProducts": dealsProducts,
        "offers": offers,
      });
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);

      if (categories.isEmpty && featuredProducts.isEmpty &&
          newProducts.isEmpty && bestSellerProducts.isEmpty &&
          dealsProducts.isEmpty && offers.isEmpty) {
        state.value = HomeError(e.toString());
      }
    }
  }

  // from time Greeting
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

  // ==getCurrentUserName===

  // Get the current user's name from cache if available, otherwise fetch from Supabase
  Future<void> getCurrentUserNameFromCache() async {
    final cachedName = hive.userNameBox.get('userName');
    if (cachedName != null) {
      userName.value = cachedName;
    } else {
     await getCurrentUserName();
    }
  }
  // Get the current user's name from Supabase
  Future<void> getCurrentUserName() async {
    final user = await supaService.getCurrentUser();

    if (user != null) {
      userName.value = user.name;
      await hive.userNameBox.put('userName', user.name);
    }
  }

  // scroll to refresh the home page
  Future<void> refreshHomePage() async {
    try {
      await Future.wait([
        fetchCategories(),
        fetchFeaturedProducts(),
        fetchNewProducts(),
        fetchBestSellerProducts(),
        fetchDealsProducts(),
        getOffers(),
      ]);

      state.value = Success({
        "categories": categories,
        "featuredProducts": featuredProducts,
        "newProducts": newProducts,
        "bestSellerProducts": bestSellerProducts,
        "dealsProducts": dealsProducts,
        "offers": offers,
      });
    } catch (e) {
      Get.snackbar(
        "Refresh Failed",
        e.toString(),
      );
    }
  }
  // ================== OFFERS ==================
  // Load offers from cache
  Future<void> loadOffersFromCache() async {
    offers.value = hive.offersBox.values
        .map(
          (e) => OfferModel.fromJson(
        Map<String, dynamic>.from(e),
      ),
    )
        .toList();
  }
  // Fetch offers from Supabase
  Future<void> getOffers() async {
    final response = await supaService.getOffers();

    if (!response.isSuccess) {
      Get.snackbar(
        "Error",
        response.error!,
      );
      return;
    }

    offers.assignAll(response.data ?? []);
    await hive.offersBox.clear();

    for (final offer in offers) {
      await hive.offersBox.put(
        offer.id,
        offer.toJson(),
      );
    }
  }
  // Open offer based on action type
  void openOffer(OfferModel offer) {
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
  // ================== Load CATEGORIES  ==================

  // == Load Categories From CACHE ==
  Future<void> loadCategoriesFromCache() async {
    final box = hive.homeCategoriesBox;

    categories.value = box.values
        .map((e) => CategoryModel.fromJson(
      Map<String, dynamic>.from(e),
    ))
        .toList();
  }
  // == Fetch Categories from Supabase ==
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
 // ================== Load Products  ==================
  // Featured Products
  // Load Featured Products from Cache
  Future<void> loadFeaturedProductsFromCache() async {
    final box = hive.featuredProducts;

    featuredProducts.value = box.values
        .map(
          (e) => Product.fromJson(
        e['id'],
        Map<String, dynamic>.from(e),
      ),
    )
        .toList();
  }
  // Load Featured Products from Supabase
  Future<void> fetchFeaturedProducts() async {
    final result = await supaService.getFeaturedProducts();

    if (!result.isSuccess) {
      throw Exception(result.error);
    }

    featuredProducts.assignAll(result.data!);

    await cacheProducts(
      hive.featuredProducts,
      featuredProducts,
    );
  }
  // New Products
  // Load New Products from Cache
  Future<void> loadNewProductsFromCache() async {
    final box = hive.newProducts;

    newProducts.value = box.values
        .map(
          (e) => Product.fromJson(
        e['id'],
        Map<String, dynamic>.from(e),
      ),
    )
        .toList();
  }
  // Fetch new products from Supabase
  Future<void> fetchNewProducts() async {
    final result = await supaService.getNewProducts();

    if (!result.isSuccess) {
      throw Exception(result.error);
    }

    newProducts.assignAll(result.data!);

    await cacheProducts(
      hive.newProducts,
      newProducts,
    );
  }
  // Best Seller Products
  // Load Best Seller Products from Cache
  Future<void> loadBestSellerProductsFromCache() async {
    final box = hive.bestSellerProducts;

    bestSellerProducts.value = box.values
        .map(
          (e) => Product.fromJson(
        e['id'],
        Map<String, dynamic>.from(e),
      ),
    )
        .toList();
  }
  // Fetch best seller products from Supabase
  Future<void> fetchBestSellerProducts() async {
    final result = await supaService.getBestSellerProducts();

    if (!result.isSuccess) {
      throw Exception(result.error);
    }

    bestSellerProducts.assignAll(result.data!);

    await cacheProducts(
      hive.bestSellerProducts,
      bestSellerProducts,
    );
  }
  // Deals Products
  // Load Deals Products from Cache
  Future<void> loadDealsProductsFromCache() async {
    final box = hive.dealsProducts;

    dealsProducts.value = box.values
        .map(
          (e) => Product.fromJson(
        e['id'],
        Map<String, dynamic>.from(e),
      ),
    )
        .toList();
  }
  // Fetch deals products from Supabase
  Future<void> fetchDealsProducts() async {
    final result = await supaService.getDealsProducts();

    if (!result.isSuccess) {
      throw Exception(result.error);
    }

    dealsProducts.assignAll(result.data!);

    await cacheProducts(
      hive.dealsProducts,
      dealsProducts,
    );
  }
  // cache products
  Future<void> cacheProducts(
      Box box,
      List<Product> products,
      ) async {
    await box.clear();

    for (final product in products) {
      await box.put(
        product.id,
        product.toJson(),
      );
    }
  }
  // ================== CLEANUP ============= =====
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}