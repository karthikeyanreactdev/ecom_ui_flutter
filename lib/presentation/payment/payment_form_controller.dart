import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/payment_method_model.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';

class PaymentFormController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();
  
  final formKey = GlobalKey<FormState>();
  
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardholderNameController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isDefault = false.obs;
  
  final RxString selectedCardType = 'Visa'.obs;
  final RxList<String> cardTypes = <String>[
    'Visa',
    'Mastercard',
    'American Express',
    'Discover'
  ].obs;
  
  late PaymentMethodModel? editingPaymentMethod;
  bool get isEditing => editingPaymentMethod != null;
  
  @override
  void onInit() {
    super.onInit();
    
    // Check if we are editing an existing payment method
    if (Get.arguments != null && Get.arguments is PaymentMethodModel) {
      editingPaymentMethod = Get.arguments;
      loadPaymentMethodData();
    } else {
      editingPaymentMethod = null;
      
      // Check if we should set this as default (e.g., if it's the first payment method)
      checkIfShouldBeDefault();
    }
  }
  
  @override
  void onClose() {
    cardNumberController.dispose();
    cardholderNameController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.onClose();
  }
  
  void selectCardType(String type) {
    selectedCardType.value = type;
  }
  
  Future<void> loadPaymentMethodData() async {
    if (editingPaymentMethod == null) return;
    
    isLoading.value = true;
    
    try {
      selectedCardType.value = editingPaymentMethod!.cardType;
      cardNumberController.text = editingPaymentMethod!.cardNumber;
      cardholderNameController.text = editingPaymentMethod!.cardholderName;
      expiryDateController.text = editingPaymentMethod!.expiryDate;
      isDefault.value = editingPaymentMethod!.isDefault;
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> checkIfShouldBeDefault() async {
    // In a real app, this would check if there are any existing payment methods
    // For now, just set it to true for the first one
    isDefault.value = true;
  }
  
  Future<void> savePaymentMethod() async {
    if (!formKey.currentState!.validate()) return;
    
    isSaving.value = true;
    
    try {
      // Get formatted values
      final String cardNumber = cardNumberController.text;
      
      // In a real app, you would securely store the card info and tokenize it
      // For demo, we'll just save a masked version
      final String maskedCardNumber = 
          '**** **** **** ${cardNumber.replaceAll(' ', '').substring(12)}';
      
      final paymentMethod = PaymentMethodModel(
        id: isEditing ? editingPaymentMethod!.id : const Uuid().v4(),
        cardType: selectedCardType.value,
        cardNumber: maskedCardNumber,
        cardholderName: cardholderNameController.text,
        expiryDate: expiryDateController.text,
        isDefault: isDefault.value,
      );
      
      // In a real app, you would send this to your payment processor
      // and store the token, not the actual card details
      
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      Get.back(result: paymentMethod);
      Get.snackbar(
        'Success',
        isEditing 
            ? 'Payment method updated successfully' 
            : 'Payment method added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save payment method: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }
}