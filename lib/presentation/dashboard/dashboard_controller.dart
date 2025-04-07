import 'package:get/get.dart';
import '../../services/storage_service.dart';

class DashboardController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  // Observable variables
  final currentIndex = 0.obs;
  final cartItemCount = 0.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Load cart item count
    updateCartItemCount();
    // Listen for cart changes
    ever(_storageService.getCartItems().obs, (_) => updateCartItemCount());
  }
  
  // Update cart badge count
  void updateCartItemCount() {
    final cartItems = _storageService.getCartItems();
    cartItemCount.value = cartItems.isEmpty ? 0 : cartItems.length;
  }
  
  // Change current page
  void changePage(int index) {
    currentIndex.value = index;
  }
}
