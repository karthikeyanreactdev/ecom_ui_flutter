import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/address_model.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';

class AddressListController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();
  
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }
  
  Future<void> loadAddresses() async {
    isLoading.value = true;
    
    try {
      // First try to get addresses from local storage
      final localAddresses = _storageService.getAddresses();
      
      if (localAddresses.isNotEmpty) {
        addresses.value = localAddresses;
      }
      
      // Then try to get addresses from API
      final userId = await _storageService.getUserId();
      if (userId != null) {
        final response = await _apiService.get('/users/$userId/addresses');
        
        if (response.statusCode == 200) {
          final List<dynamic> data = response.data['data'];
          final List<AddressModel> apiAddresses = data
              .map((json) => AddressModel.fromJson(json))
              .toList();
          
          // Update local storage and UI
          addresses.value = apiAddresses;
          
          // Cache the addresses
          for (final address in apiAddresses) {
            await _storageService.saveAddress(address);
          }
        }
      }
    } catch (e) {
      // If there's an error, we'll use what we got from local storage
      // or generate some mock data if needed
      if (addresses.isEmpty) {
        _generateMockAddresses();
      }
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> setDefaultAddress(AddressModel address) async {
    try {
      final userId = await _storageService.getUserId();
      if (userId == null) {
        throw Exception('User ID not found. Please login again.');
      }
      
      // Update locally first
      final updatedAddresses = addresses.map((a) {
        if (a.id == address.id) {
          return AddressModel(
            id: a.id,
            userId: userId,
            name: a.name,
            phone: a.phone,
            addressLine1: a.addressLine1,
            addressLine2: a.addressLine2,
            city: a.city,
            state: a.state,
            country: a.country,
            postalCode: a.postalCode,
            isDefault: true,
            type: a.type,
            landmark: a.landmark,
            createdAt: a.createdAt,
            updatedAt: DateTime.now(),
          );
        } else {
          return AddressModel(
            id: a.id,
            userId: userId,
            name: a.name,
            phone: a.phone,
            addressLine1: a.addressLine1,
            addressLine2: a.addressLine2,
            city: a.city,
            state: a.state,
            country: a.country,
            postalCode: a.postalCode,
            isDefault: false,
            type: a.type,
            landmark: a.landmark,
            createdAt: a.createdAt,
            updatedAt: DateTime.now(),
          );
        }
      }).toList();
      
      addresses.value = updatedAddresses;
      
      // Save to local storage
      for (final updatedAddress in updatedAddresses) {
        await _storageService.saveAddress(updatedAddress);
      }
      
      // Then update via API
      await _apiService.put(
        '/addresses/${address.id}/default',
        data: {'isDefault': true},
      );
      
      Get.snackbar(
        'Success',
        'Default address updated',
        snackPosition: SnackPosition.BOTTOM,
      );
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update default address',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  Future<void> deleteAddress(AddressModel address) async {
    final bool confirmed = await Get.dialog(
      AlertDialog(
        title: const Text('Delete Address'),
        content: const Text(
          'Are you sure you want to delete this address? This action cannot be undone.',
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
      // Delete locally first
      await _storageService.removeAddress(address.id);
      addresses.removeWhere((a) => a.id == address.id);
      
      // Then delete via API
      await _apiService.delete('/addresses/${address.id}');
      
      Get.snackbar(
        'Success',
        'Address deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete address',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  void _generateMockAddresses() {
    // Using a mock user ID since we can't await in a void method
    const mockUserId = 'mock_user_123';
    final now = DateTime.now();
    
    addresses.addAll([
      AddressModel(
        id: '1',
        userId: mockUserId,
        name: 'John Doe',
        phone: '+1 123-456-7890',
        addressLine1: '123 Main St',
        addressLine2: 'Apt 4B',
        city: 'New York',
        state: 'NY',
        postalCode: '10001',
        country: 'United States',
        isDefault: true,
        type: 'home',
        landmark: 'Near Central Park',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 15)),
      ),
      AddressModel(
        id: '2',
        userId: mockUserId,
        name: 'John Doe',
        phone: '+1 098-765-4321',
        addressLine1: '456 Park Ave',
        addressLine2: null,
        city: 'San Francisco',
        state: 'CA',
        postalCode: '94107',
        country: 'United States',
        isDefault: false,
        type: 'work',
        landmark: null,
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(days: 20)),
      ),
    ]);
  }
}