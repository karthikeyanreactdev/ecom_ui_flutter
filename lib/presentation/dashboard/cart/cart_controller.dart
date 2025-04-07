import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../services/storage_service.dart';
import '../dashboard_controller.dart';

class CartController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  // Observable variables
  final cartItems = <CartItemModel>[].obs;
  final isLoading = true.obs;
  final subtotal = 0.0.obs;
  final shippingCost = 0.0.obs;
  final tax = 0.0.obs;
  final total = 0.0.obs;
  
  // Default shipping option
  final shippingOption = 'standard'.obs;
  
  // Controller for promo code text field
  final promoCodeController = TextEditingController();
  final isPromoCodeValid = false.obs;
  final promoDiscount = 0.0.obs;
  final isApplyingPromo = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadCartItems();
  }
  
  @override
  void onClose() {
    promoCodeController.dispose();
    super.onClose();
  }
  
  void loadCartItems() {
    isLoading.value = true;
    
    try {
      final items = _storageService.getCartItems();
      cartItems.value = List.from(items);
      
      // Calculate totals
      _calculateTotals();
      
      isLoading.value = false;
    } catch (e) {
      print('Error loading cart items: $e');
      isLoading.value = false;
    }
  }
  
  void _calculateTotals() {
    // Calculate subtotal
    subtotal.value = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
    
    // Calculate shipping cost based on selected option
    _calculateShippingCost();
    
    // Calculate tax (assuming 8% tax rate)
    tax.value = subtotal.value * 0.08;
    
    // Calculate total
    total.value = subtotal.value + shippingCost.value + tax.value - promoDiscount.value;
  }
  
  void _calculateShippingCost() {
    if (subtotal.value >= 50) {
      // Free shipping for orders over $50
      shippingCost.value = 0.0;
    } else {
      switch (shippingOption.value) {
        case 'standard':
          shippingCost.value = 5.99;
          break;
        case 'express':
          shippingCost.value = 12.99;
          break;
        case 'overnight':
          shippingCost.value = 19.99;
          break;
        default:
          shippingCost.value = 5.99;
      }
    }
  }
  
  void setShippingOption(String option) {
    shippingOption.value = option;
    _calculateShippingCost();
    _calculateTotals();
  }
  
  void increaseQuantity(CartItemModel item) {
    if (item.quantity < item.product.quantity) {
      // Find the item in the list
      final index = cartItems.indexWhere((i) => i.productId == item.productId);
      if (index != -1) {
        // Create a new item with increased quantity
        final updatedItem = CartItemModel(
          productId: item.productId,
          product: item.product,
          quantity: item.quantity + 1,
          color: item.color,
          size: item.size,
        );
        
        // Update the item in the list
        cartItems[index] = updatedItem;
        
        // Save changes to storage
        _storageService.updateCartItem(updatedItem);
        
        // Recalculate totals
        _calculateTotals();
        
        // Update the dashboard controller's cart count
        Get.find<DashboardController>().updateCartItemCount();
      }
    }
  }
  
  void decreaseQuantity(CartItemModel item) {
    if (item.quantity > 1) {
      // Find the item in the list
      final index = cartItems.indexWhere((i) => i.productId == item.productId);
      if (index != -1) {
        // Create a new item with decreased quantity
        final updatedItem = CartItemModel(
          productId: item.productId,
          product: item.product,
          quantity: item.quantity - 1,
          color: item.color,
          size: item.size,
        );
        
        // Update the item in the list
        cartItems[index] = updatedItem;
        
        // Save changes to storage
        _storageService.updateCartItem(updatedItem);
        
        // Recalculate totals
        _calculateTotals();
        
        // Update the dashboard controller's cart count
        Get.find<DashboardController>().updateCartItemCount();
      }
    }
  }
  
  void removeItem(CartItemModel item) {
    // Remove from the list
    cartItems.removeWhere((i) => i.productId == item.productId);
    
    // Remove from storage
    _storageService.removeFromCart(item.productId);
    
    // Recalculate totals
    _calculateTotals();
    
    // Update the dashboard controller's cart count
    Get.find<DashboardController>().updateCartItemCount();
  }
  
  Future<void> applyPromoCode() async {
    final code = promoCodeController.text.trim();
    if (code.isEmpty) return;
    
    isApplyingPromo.value = true;
    
    try {
      // In a real app, this would be an API call to validate the promo code
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Mock promo code validation
      if (code.toUpperCase() == 'SAVE10') {
        isPromoCodeValid.value = true;
        promoDiscount.value = subtotal.value * 0.1; // 10% discount
        _calculateTotals();
        
        Get.snackbar(
          'Success',
          'Promo code applied: 10% discount',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else if (code.toUpperCase() == 'SAVE20') {
        isPromoCodeValid.value = true;
        promoDiscount.value = subtotal.value * 0.2; // 20% discount
        _calculateTotals();
        
        Get.snackbar(
          'Success',
          'Promo code applied: 20% discount',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        isPromoCodeValid.value = false;
        promoDiscount.value = 0.0;
        _calculateTotals();
        
        Get.snackbar(
          'Invalid Code',
          'The promo code you entered is invalid or expired',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('Error applying promo code: $e');
      isPromoCodeValid.value = false;
    } finally {
      isApplyingPromo.value = false;
    }
  }
  
  void removePromoCode() {
    promoCodeController.clear();
    isPromoCodeValid.value = false;
    promoDiscount.value = 0.0;
    _calculateTotals();
  }
  
  void proceedToCheckout() {
    if (cartItems.isEmpty) {
      Get.snackbar(
        'Empty Cart',
        'Your cart is empty. Add items to continue.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    
    // Navigate to checkout screen
    Get.toNamed('/checkout');
  }
}