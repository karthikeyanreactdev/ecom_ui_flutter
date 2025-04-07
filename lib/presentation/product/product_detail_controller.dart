import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/models/cart_item_model.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';

class ProductDetailController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  // Product data
  final product = Rxn<ProductModel>();
  final selectedColor = Rxn<String>();
  final selectedSize = Rxn<String>();
  final quantity = 1.obs;

  // UI states
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final isInWishlist = false.obs;
  final currentImageIndex = 0.obs;
  final pageController = PageController();

  // Related products
  final relatedProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Get product from arguments
    if (Get.arguments is ProductModel) {
      product.value = Get.arguments as ProductModel;
      loadProductDetails();
    } else if (Get.arguments is String) {
      // If only product ID is provided
      fetchProductById(Get.arguments as String);
    } else {
      hasError.value = true;
      errorMessage.value = 'Product not found';
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  Future<void> loadProductDetails() async {
    if (product.value == null) return;

    isLoading.value = true;
    hasError.value = false;

    try {
      // Check if product is in wishlist
      checkIfInWishlist();

      // Fetch related products
      await fetchRelatedProducts();

      if (product.value?.colors?.isNotEmpty == true) {
        selectedColor.value = product.value!.colors![0];
      }

      if (product.value?.sizes?.isNotEmpty == true) {
        selectedSize.value = product.value!.sizes![0];
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Failed to load product details';
      print('Error loading product details: $e');
    }
  }

  Future<void> fetchProductById(String productId) async {
    isLoading.value = true;
    hasError.value = false;

    try {
      // In a real app, this would fetch from API
      // Simulating API call for now
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock a product retrieval
      product.value = ProductModel(
        id: productId,
        name: 'Sample Product',
        description: 'This is a sample product fetched by ID',
        price: 99.99,
        images: [
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1399&q=80',
        ],
        quantity: 10,
        categoryId: '1',
        sellerId: 'seller1',
        rating: 4.5,
        reviewCount: 42,
        isFeatured: true,
        isNewArrival: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await loadProductDetails();
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Failed to fetch product';
      print('Error fetching product: $e');
    }
  }

  Future<void> fetchRelatedProducts() async {
    if (product.value == null) return;

    try {
      // In a real app, we would fetch related products by category from API
      // Simulating API call for now
      await Future.delayed(const Duration(milliseconds: 500));

      relatedProducts.value = [
        ProductModel(
          id: 'related1',
          name: 'Similar Item 1',
          description: 'A product similar to the one you are viewing',
          price: 89.99,
          images: [
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
          ],
          quantity: 15,
          categoryId: product.value!.categoryId,
          sellerId: 'seller3',
          rating: 4.2,
          reviewCount: 18,
          isFeatured: false,
          isNewArrival: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          id: 'related2',
          name: 'Similar Item 2',
          description: 'Another product that might interest you',
          price: 79.99,
          compareAtPrice: 99.99,
          images: [
            'https://images.unsplash.com/photo-1572635196237-14b3f281503f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1480&q=80',
          ],
          quantity: 8,
          categoryId: product.value!.categoryId,
          sellerId: 'seller2',
          rating: 4.7,
          reviewCount: 36,
          isFeatured: true,
          isNewArrival: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    } catch (e) {
      print('Error fetching related products: $e');
    }
  }

  void checkIfInWishlist() {
    final wishlistItems = _storageService.getWishlistItems();
    isInWishlist.value = wishlistItems.any(
      (item) => item.id == product.value?.id,
    );
  }

  void incrementQuantity() {
    if (product.value == null) return;

    if (quantity.value < product.value!.quantity) {
      quantity.value++;
    }
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void setColor(String color) {
    selectedColor.value = color;
  }

  void setSize(String size) {
    selectedSize.value = size;
  }

  void toggleWishlist() {
    if (product.value == null) return;

    if (isInWishlist.value) {
      _storageService.removeFromWishlist(product.value!.id);
    } else {
      _storageService.addToWishlist(product.value!);
    }

    isInWishlist.toggle();
  }

  void addToCart() {
    if (product.value == null) return;

    final cartItem = CartItemModel(
      productId: product.value!.id,
      product: product.value!,
      quantity: quantity.value,
      color: selectedColor.value,
      size: selectedSize.value,
    );

    _storageService.addToCart(cartItem);
    Get.snackbar(
      'Added to Cart',
      '${product.value!.name} has been added to your cart',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void buyNow() {
    addToCart();
    Get.toNamed('/cart');
  }

  void changeImage(int index) {
    if (product.value == null ||
        index < 0 ||
        index >= product.value!.images.length)
      return;

    currentImageIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
