import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/address_model.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';

class AddressFormController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isDefault = false.obs;

  late AddressModel? editingAddress;
  bool get isEditing => editingAddress != null;

  @override
  void onInit() {
    super.onInit();

    // Check if we are editing an existing address
    if (Get.arguments != null && Get.arguments is AddressModel) {
      editingAddress = Get.arguments;
      loadAddressData();
    } else {
      editingAddress = null;
      // Set default country and potentially other default values
      countryController.text = 'United States';

      // Check if we should set this as default (e.g., if it's the first address)
      checkIfShouldBeDefault();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
    super.onClose();
  }

  Future<void> loadAddressData() async {
    if (editingAddress == null) return;

    isLoading.value = true;

    try {
      nameController.text = editingAddress!.name;
      phoneController.text = editingAddress!.phone;
      addressLine1Controller.text = editingAddress!.addressLine1;
      addressLine2Controller.text = editingAddress!.addressLine2 ?? '';
      cityController.text = editingAddress!.city;
      stateController.text = editingAddress!.state;
      postalCodeController.text = editingAddress!.postalCode;
      countryController.text = editingAddress!.country;
      isDefault.value = editingAddress!.isDefault;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkIfShouldBeDefault() async {
    final addresses = _storageService.getAddresses();
    if (addresses.isEmpty) {
      isDefault.value = true;
    }
  }

  Future<void> saveAddress() async {
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;

    try {
      final userId = await _storageService.getUserId();
      if (userId == null) {
        throw Exception('User ID not found. Please login again.');
      }

      final address = AddressModel(
        id: isEditing ? editingAddress!.id : const Uuid().v4(),
        userId: userId,
        name: nameController.text,
        phone: phoneController.text,
        addressLine1: addressLine1Controller.text,
        addressLine2:
            addressLine2Controller.text.isEmpty
                ? null
                : addressLine2Controller.text,
        city: cityController.text,
        state: stateController.text,
        postalCode: postalCodeController.text,
        country: countryController.text,
        isDefault: isDefault.value,
        type: 'home', // Default type
        createdAt: isEditing ? editingAddress!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // If this is set as default, we need to unset other addresses
      if (address.isDefault) {
        await _updateDefaultAddresses(address.id);
      }

      // Save address to local storage
      await _storageService.saveAddress(address);

      // Save address to API
      // final userId = await _storageService.getUserId();
      // if (userId != null) {
      if (isEditing) {
        await _apiService.put(
          '/addresses/${address.id}',
          data: address.toJson(),
        );
      } else {
        await _apiService.post(
          '/users/$userId/addresses',
          data: address.toJson(),
        );
        // }
      }

      Get.back(result: address);
      Get.snackbar(
        'Success',
        isEditing
            ? 'Address updated successfully'
            : 'Address added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save address: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> _updateDefaultAddresses(String newDefaultId) async {
    final addresses = _storageService.getAddresses();
    final userId = await _storageService.getUserId();

    if (userId == null) {
      throw Exception('User ID not found. Please login again.');
    }

    for (final address in addresses) {
      if (address.id != newDefaultId && address.isDefault) {
        final updatedAddress = AddressModel(
          id: address.id,
          userId: userId,
          name: address.name,
          phone: address.phone,
          addressLine1: address.addressLine1,
          addressLine2: address.addressLine2,
          city: address.city,
          state: address.state,
          country: address.country,
          postalCode: address.postalCode,
          isDefault: false,
          type: address.type,
          createdAt: address.createdAt,
          updatedAt: DateTime.now(),
        );

        await _storageService.saveAddress(updatedAddress);

        // Also update via API
        await _apiService.put(
          '/addresses/${address.id}',
          data: updatedAddress.toJson(),
        );
      }
    }
  }
}
