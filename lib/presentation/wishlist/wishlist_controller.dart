import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/models/cart_item_model.dart';
import '../../services/storage_service.dart';

class WishlistController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  // Observable variables
  final wishlistItems = <ProductModel>[].obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadWishlistItems();
  }
  
  Future<void> loadWishlistItems() async {
    isLoading.value = true;
    hasError.value = false;
    
    try {
      final items = _storageService.getWishlistItems();
      wishlistItems.value = List.from(items);
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Failed to load wishlist. Please try again.';
      print('Error loading wishlist: $e');
    }
  }
  
  Future<void> refreshWishlist() async {
    return loadWishlistItems();
  }
  
  Future<void> removeFromWishlist(String productId) async {
    try {
      await _storageService.removeFromWishlist(productId);
      
      // Remove from local list
      wishlistItems.removeWhere((item) => item.id == productId);
      
      Get.snackbar(
        'Item Removed',
        'Item removed from wishlist',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey.shade800,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove item from wishlist',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      print('Error removing from wishlist: $e');
    }
  }
  
  Future<void> addToCart(ProductModel product) async {
    try {
      // Create cart item
      final cartItem = CartItemModel(
        productId: product.id,
        quantity: 1,
        product: product,
      );
      
      // Add to cart
      await _storageService.addToCart(cartItem);
      
      // Show success message
      Get.snackbar(
        'Added to Cart',
        '${product.name} has been added to your cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add item to cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      print('Error adding to cart: $e');
    }
  }
  
  Future<void> clearWishlist() async {
    try {
      // Show confirmation dialog
      final confirm = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Clear Wishlist'),
          content: const Text('Are you sure you want to remove all items from your wishlist?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Clear All'),
            ),
          ],
        ),
      );
      
      if (confirm == true) {
        // Clear all items
        for (var item in wishlistItems) {
          await _storageService.removeFromWishlist(item.id);
        }
        
        // Clear local list
        wishlistItems.clear();
        
        Get.snackbar(
          'Wishlist Cleared',
          'All items have been removed from your wishlist',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey.shade800,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to clear wishlist',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      print('Error clearing wishlist: $e');
    }
  }
  
  void navigateToProductDetail(ProductModel product) {
    Get.toNamed('/product-detail', arguments: product);
  }
}