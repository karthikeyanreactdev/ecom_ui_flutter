import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/payment_method_model.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';

class PaymentMethodController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();
  
  final RxList<PaymentMethodModel> paymentMethods = <PaymentMethodModel>[].obs;
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadPaymentMethods();
  }
  
  Future<void> loadPaymentMethods() async {
    isLoading.value = true;
    
    try {
      // In a real app, this would fetch from API
      // Simulate a delay for demonstration
      await Future.delayed(const Duration(seconds: 1));
      
      // Generate mock data for demo
      _generateMockPaymentMethods();
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load payment methods: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  void selectPaymentMethod(PaymentMethodModel method) {
    if (Get.parameters.containsKey('fromCheckout') && Get.parameters['fromCheckout'] == 'true') {
      Get.back(result: method);
    }
  }
  
  Future<void> setDefaultPaymentMethod(PaymentMethodModel method) async {
    try {
      // Update locally first
      final updatedMethods = paymentMethods.map((m) {
        if (m.id == method.id) {
          return PaymentMethodModel(
            id: m.id,
            cardType: m.cardType, 
            cardNumber: m.cardNumber, 
            cardholderName: m.cardholderName, 
            expiryDate: m.expiryDate,
            isDefault: true,
          );
        } else {
          return PaymentMethodModel(
            id: m.id,
            cardType: m.cardType, 
            cardNumber: m.cardNumber, 
            cardholderName: m.cardholderName, 
            expiryDate: m.expiryDate,
            isDefault: false,
          );
        }
      }).toList();
      
      paymentMethods.value = updatedMethods;
      
      // In a real app, this would update the API
      await Future.delayed(const Duration(milliseconds: 500));
      
      Get.snackbar(
        'Success',
        'Default payment method updated',
        snackPosition: SnackPosition.BOTTOM,
      );
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update default payment method',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  Future<void> deletePaymentMethod(PaymentMethodModel method) async {
    final bool confirmed = await Get.dialog(
      AlertDialog(
        title: const Text('Delete Payment Method'),
        content: const Text(
          'Are you sure you want to delete this payment method? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ?? false;
    
    if (!confirmed) return;
    
    try {
      // Remove locally first
      paymentMethods.removeWhere((m) => m.id == method.id);
      
      // In a real app, this would delete from the API
      await Future.delayed(const Duration(milliseconds: 500));
      
      Get.snackbar(
        'Success',
        'Payment method deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete payment method',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  void _generateMockPaymentMethods() {
    paymentMethods.addAll([
      PaymentMethodModel(
        id: '1',
        cardType: 'Visa',
        cardNumber: '**** **** **** 1234',
        cardholderName: 'John Doe',
        expiryDate: '12/25',
        isDefault: true,
      ),
      PaymentMethodModel(
        id: '2',
        cardType: 'Mastercard',
        cardNumber: '**** **** **** 5678',
        cardholderName: 'John Doe',
        expiryDate: '08/24',
        isDefault: false,
      ),
    ]);
  }
}