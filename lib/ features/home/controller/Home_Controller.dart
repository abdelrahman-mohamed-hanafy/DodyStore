import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/Supabase_Service.dart';
import '../../Products/Models/Product.dart';
import '../Model/Category_Model.dart';
import '../UI/states/home_states.dart';

class HomeController extends GetxController {
  final pageController = PageController();

  final supaService = Get.find<SupabaseService>();

  final favorites = <String>{}.obs;

  final state = Rx<HomeStates>(Idle());

  final products = <Product>[].obs;
  final categories = <CategoryModel>[].obs;
  CategoryModel? category;
  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  // ================== MAIN ==================
  Future<void> loadHomeData() async {
    state.value = Loading();

    try {
      final results = await Future.wait([
        fetchCategories(),
        fetchRandomProductsFromAllCategories(),
      ]);

      state.value = Success({
        "categories": categories,
        "products": products,
      });

    } catch (e) {
      state.value = HomeError(e.toString());
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
  }

  Future<void> fetchRandomProductsFromAllCategories() async {
    final result = await supaService.getProducts(limit: 10);

    if (!result.isSuccess) {
      throw Exception(result.error);
    }

    products.value = result.data!;
  }

  // ================== FAVORITES ==================
  void toggleFavorite(String productId) {
    favorites.contains(productId)
        ? favorites.remove(productId)
        : favorites.add(productId);
  }

  bool isFavorite(String productId) => favorites.contains(productId);

  // ================== CLEANUP ==================
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}