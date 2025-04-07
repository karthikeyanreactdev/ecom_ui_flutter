import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/address_model.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/order_model.dart';
import '../../routes/app_routes.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';

class CheckoutController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();
  
  final RxBool isLoading = false.obs;
  final RxBool isProcessingOrder = false.obs;
  
  final Rx<AddressModel?> selectedAddress = Rx<AddressModel?>(null);
  final RxString selectedPaymentMethod = 'Credit Card'.obs;
  final RxString selectedShippingMethod = 'Standard'.obs;
  
  final RxDouble subtotal = 0.0.obs;
  final RxDouble shipping = 0.0.obs;
  final RxDouble tax = 0.0.obs;
  final RxDouble discount = 0.0.obs;
  final RxDouble total = 0.0.obs;
  
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final TextEditingController promoController = TextEditingController();
  final RxString promoError = ''.obs;
  final RxBool isValidatingPromo = false.obs;
  final RxBool promoApplied = false.obs;
  final RxString appliedPromoCode = ''.obs;
  
  // Shipping rates
  final Map<String, double> shippingRates = {
    'Standard': 5.99,
    'Express': 12.99,
    'Next Day': 19.99,
  };
  
  // Payment methods
  final List<String> paymentMethods = [
    'Credit Card',
    'PayPal',
    'Apple Pay',
    'Google Pay',
  ];
  
  @override
  void onInit() {
    super.onInit();
    loadCheckoutData();
  }
  
  @override
  void onClose() {
    promoController.dispose();
    super.onClose();
  }
  
  Future<void> loadCheckoutData() async {
    isLoading.value = true;
    
    try {
      // Load cart items
      cartItems.value = _storageService.getCartItems();
      
      // Load default address
      selectedAddress.value = _storageService.getDefaultAddress();
      
      // Set default shipping method
      selectedShippingMethod.value = 'Standard';
      shipping.value = shippingRates[selectedShippingMethod.value] ?? 0.0;
      
      // Calculate order totals
      _calculateOrderTotals();
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load checkout data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  void _calculateOrderTotals() {
    // Calculate subtotal
    subtotal.value = cartItems.fold(0.0, (sum, item) {
      final itemPrice = item.discountedPrice ?? item.product.price;
      return sum + (itemPrice * item.quantity);
    });
    
    // Update shipping cost
    shipping.value = shippingRates[selectedShippingMethod.value] ?? 0.0;
    
    // Calculate tax (assuming 8% tax rate)
    tax.value = (subtotal.value * 0.08).roundToDouble();
    
    // Calculate total
    total.value = subtotal.value + shipping.value + tax.value - discount.value;
  }
  
  void selectShippingMethod(String method) {
    if (shippingRates.containsKey(method)) {
      selectedShippingMethod.value = method;
      shipping.value = shippingRates[method] ?? 0.0;
      _calculateOrderTotals();
    }
  }
  
  void selectPaymentMethod(String method) {
    if (paymentMethods.contains(method)) {
      selectedPaymentMethod.value = method;
    }
  }
  
  Future<void> selectAddress() async {
    final result = await Get.toNamed(
      AppRoutes.shippingAddresses,
      parameters: {'fromCheckout': 'true'},
    );
    
    if (result is AddressModel) {
      selectedAddress.value = result;
    }
  }
  
  Future<void> addNewAddress() async {
    final result = await Get.toNamed(AppRoutes.addAddress);
    
    if (result is AddressModel) {
      selectedAddress.value = result;
    }
  }
  
  Future<void> applyPromoCode() async {
    final code = promoController.text.trim();
    if (code.isEmpty) {
      promoError.value = 'Please enter a promo code';
      return;
    }
    
    isValidatingPromo.value = true;
    promoError.value = '';
    
    try {
      // In a real app, you would validate the promo code with the API
      // For now, we'll simulate a successful validation with a mock discount
      
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // For demo purposes, accept any code
      final validCodes = {
        'WELCOME10': 10.0,
        'SAVE20': 20.0,
        'FREESHIP': shipping.value,
      };
      
      if (validCodes.containsKey(code.toUpperCase())) {
        discount.value = validCodes[code.toUpperCase()] ?? 0.0;
        promoApplied.value = true;
        appliedPromoCode.value = code.toUpperCase();
        promoController.clear();
        
        Get.snackbar(
          'Success',
          'Promo code applied successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        
        // Recalculate totals
        _calculateOrderTotals();
      } else {
        promoError.value = 'Invalid promo code';
      }
    } catch (e) {
      promoError.value = 'Failed to validate promo code';
    } finally {
      isValidatingPromo.value = false;
    }
  }
  
  void removePromoCode() {
    discount.value = 0.0;
    promoApplied.value = false;
    appliedPromoCode.value = '';
    _calculateOrderTotals();
  }
  
  Future<void> placeOrder() async {
    if (selectedAddress.value == null) {
      Get.snackbar(
        'Error',
        'Please select a shipping address',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    if (cartItems.isEmpty) {
      Get.snackbar(
        'Error',
        'Your cart is empty',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    isProcessingOrder.value = true;
    
    try {
      final userId = await _storageService.getUserId() ?? 'guest';
      
      // Create the order
      final order = OrderModel(
        id: const Uuid().v4(),
        userId: userId,
        items: cartItems,
        shippingAddress: selectedAddress.value!,
        paymentMethod: selectedPaymentMethod.value,
        status: 'pending',
        subtotal: subtotal.value,
        shipping: shipping.value,
        tax: tax.value,
        discount: discount.value,
        total: total.value,
        couponCode: promoApplied.value ? appliedPromoCode.value : null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      // Save order to local storage
      await _storageService.saveOrder(order);
      
      // In a real app, you would send the order to the API
      await Future.delayed(const Duration(seconds: 2));
      
      // Clear cart after successful order
      await _storageService.clearCart();
      
      // Navigate to order confirmation
      Get.offAllNamed(
        AppRoutes.orderConfirmation,
        arguments: order,
      );
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to place order: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isProcessingOrder.value = false;
    }
  }
}