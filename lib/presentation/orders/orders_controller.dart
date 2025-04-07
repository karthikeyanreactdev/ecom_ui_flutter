import 'package:ecom_ui_flutter/data/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/order_model.dart';
import '../../services/api_service.dart';
import '../../services/connectivity_service.dart';

class OrdersController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final ConnectivityService _connectivityService =
      Get.find<ConnectivityService>();

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMorePages = true.obs;
  final RxString selectedFilter = 'all'.obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadOrders();
    scrollController.addListener(_scrollListener);
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!isLoading.value && hasMorePages.value) {
        loadMoreOrders();
      }
    }
  }

  Future<void> loadOrders() async {
    if (!await _connectivityService.isConnected()) {
      hasError.value = true;
      errorMessage.value =
          'No internet connection. Please check your network and try again.';
      return;
    }

    isLoading.value = true;
    hasError.value = false;
    currentPage.value = 1;

    try {
      final response = await _apiService.get(
        '/orders',
        queryParameters: {
          'page': currentPage.value,
          'limit': 10,
          'status': selectedFilter.value == 'all' ? null : selectedFilter.value,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        orders.value = data.map((json) => OrderModel.fromJson(json)).toList();
        hasMorePages.value = orders.length < response.data['total'];
      } else {
        hasError.value = true;
        errorMessage.value = 'Failed to load orders. Please try again.';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'An error occurred: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreOrders() async {
    if (!await _connectivityService.isConnected()) {
      Get.snackbar('Error', 'No internet connection');
      return;
    }

    isLoading.value = true;
    currentPage.value++;

    try {
      final response = await _apiService.get(
        '/orders',
        queryParameters: {
          'page': currentPage.value,
          'limit': 10,
          'status': selectedFilter.value == 'all' ? null : selectedFilter.value,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final newOrders =
            data.map((json) => OrderModel.fromJson(json)).toList();

        if (newOrders.isEmpty) {
          hasMorePages.value = false;
        } else {
          orders.addAll(newOrders);
          hasMorePages.value = orders.length < response.data['total'];
        }
      } else {
        currentPage.value--;
        Get.snackbar('Error', 'Failed to load more orders');
      }
    } catch (e) {
      currentPage.value--;
      Get.snackbar('Error', 'An error occurred while loading more orders');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOrders() async {
    loadOrders();
  }

  void filterOrders(String status) {
    if (selectedFilter.value != status) {
      selectedFilter.value = status;
      loadOrders();
    }
  }

  Future<void> cancelOrder(String orderId) async {
    if (!await _connectivityService.isConnected()) {
      Get.snackbar('Error', 'No internet connection');
      return;
    }

    try {
      final response = await _apiService.put(
        '/orders/$orderId/cancel',
        data: {'status': 'cancelled'},
      );

      if (response.statusCode == 200) {
        final int index = orders.indexWhere((order) => order.id == orderId);
        if (index != -1) {
          final OrderModel updatedOrder = OrderModel.fromJson(response.data);
          orders[index] = updatedOrder;
          orders.refresh();
          Get.snackbar('Success', 'Order cancelled successfully');
        }
      } else {
        Get.snackbar('Error', 'Failed to cancel order');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while cancelling the order');
    }
  }

  // Generate mock data for development purposes
  void generateMockOrders() {
    final List<OrderModel> mockOrders = [];
    final List<String> statuses = [
      'pending',
      'processing',
      'shipped',
      'delivered',
      'cancelled',
    ];
    final List<String> paymentMethods = [
      'Credit Card',
      'PayPal',
      'Apple Pay',
      'Google Pay',
    ];

    for (int i = 0; i < 10; i++) {
      final String orderId = 'ORD${100000 + i}';
      final String status = statuses[i % statuses.length];
      final String paymentMethod = paymentMethods[i % paymentMethods.length];
      final DateTime createdAt = DateTime.now().subtract(Duration(days: i * 3));

      mockOrders.add(
        OrderModel(
          id: orderId,
          userId: 'user123',
          items: [], // Mock items would be added here
          shippingAddress: AddressModel(
            id: 'addr${100 + i}',
            userId: 'user123', // Using the same userId as the order
            name: 'John Doe',
            phone: '+1234567890',
            addressLine1: '123 Main St',
            addressLine2: 'Apt 4B',
            city: 'New York',
            state: 'NY',
            country: 'United States',
            postalCode: '10001',
            isDefault: true,
            type: 'home',
            landmark: i % 3 == 0 ? 'Near subway station' : null,
            createdAt: createdAt.subtract(const Duration(days: 15)),
            updatedAt: createdAt.subtract(const Duration(days: 15)),
          ),
          paymentMethod: paymentMethod,
          status: status,
          subtotal: 100.0 + (i * 10),
          shipping: 10.0,
          tax: 8.5,
          discount: i % 2 == 0 ? 15.0 : 0.0,
          total: 118.5 + (i * 10) - (i % 2 == 0 ? 15.0 : 0.0),
          trackingNumber: i % 3 == 0 ? 'TRK${200000 + i}' : null,
          couponCode: i % 2 == 0 ? 'DISCOUNT15' : null,
          notes: i % 4 == 0 ? 'Please deliver after 5 PM' : null,
          createdAt: createdAt,
          updatedAt: createdAt.add(const Duration(hours: 2)),
        ),
      );
    }

    orders.value = mockOrders;
    isLoading.value = false;
    hasError.value = false;
    hasMorePages.value = false;
  }
}
