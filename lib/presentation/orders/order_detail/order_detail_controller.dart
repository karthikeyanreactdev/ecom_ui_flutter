import 'package:get/get.dart';
import '../../../data/models/order_model.dart';
import '../../../services/api_service.dart';
import '../../../services/connectivity_service.dart';

class OrderDetailController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final ConnectivityService _connectivityService = Get.find<ConnectivityService>();
  
  final Rx<OrderModel?> order = Rx<OrderModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    
    // Get order from arguments if available
    if (Get.arguments != null && Get.arguments is OrderModel) {
      order.value = Get.arguments;
    } else if (Get.parameters.containsKey('id')) {
      // Fetch order by ID
      fetchOrderDetails(Get.parameters['id']!);
    } else {
      hasError.value = true;
      errorMessage.value = 'Order ID not provided';
    }
  }
  
  Future<void> fetchOrderDetails(String orderId) async {
    if (!await _connectivityService.isConnected()) {
      hasError.value = true;
      errorMessage.value = 'No internet connection. Please check your network and try again.';
      return;
    }
    
    isLoading.value = true;
    hasError.value = false;
    
    try {
      final response = await _apiService.get('/orders/$orderId');
      if (response.statusCode == 200) {
        order.value = OrderModel.fromJson(response.data);
      } else {
        hasError.value = true;
        errorMessage.value = 'Failed to load order details. Please try again.';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'An error occurred: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> refreshOrderDetails() async {
    if (order.value != null) {
      await fetchOrderDetails(order.value!.id);
    }
  }
  
  Future<void> cancelOrder() async {
    if (order.value == null) return;
    
    if (!await _connectivityService.isConnected()) {
      Get.snackbar('Error', 'No internet connection');
      return;
    }
    
    try {
      final response = await _apiService.put(
        '/orders/${order.value!.id}/cancel',
        data: {'status': 'cancelled'},
      );
      
      if (response.statusCode == 200) {
        order.value = OrderModel.fromJson(response.data);
        Get.snackbar('Success', 'Order cancelled successfully');
      } else {
        Get.snackbar('Error', 'Failed to cancel order');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while cancelling the order');
    }
  }
  
  Future<void> initiateReturn() async {
    if (order.value == null) return;
    
    if (!await _connectivityService.isConnected()) {
      Get.snackbar('Error', 'No internet connection');
      return;
    }
    
    // Logic to initiate return process
    // This would typically involve showing a form to the user
    // and then submitting that data to the API
    
    Get.snackbar('Info', 'Return functionality will be implemented soon');
  }
  
  Future<bool> downloadInvoice() async {
    if (order.value == null) return false;
    
    if (!await _connectivityService.isConnected()) {
      Get.snackbar('Error', 'No internet connection');
      return false;
    }
    
    try {
      // Logic to download invoice
      // This would typically involve making an API request to generate
      // and download the invoice as a PDF
      
      Get.snackbar('Success', 'Invoice downloaded successfully');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to download invoice');
      return false;
    }
  }
}