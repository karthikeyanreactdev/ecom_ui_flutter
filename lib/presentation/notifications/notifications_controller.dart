import 'package:get/get.dart';
import '../../data/models/notification_model.dart';
import '../../services/api_service.dart';

class NotificationsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  
  // Observable variables
  final notifications = <NotificationModel>[].obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }
  
  Future<void> fetchNotifications() async {
    isLoading.value = true;
    hasError.value = false;
    
    try {
      // Simulate API request - in production, this would be a real API call
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Load mock data
      notifications.value = _getMockNotifications();
      
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = 'Failed to load notifications. Please try again.';
      print('Error fetching notifications: $e');
    }
  }
  
  Future<void> refreshNotifications() async {
    return fetchNotifications();
  }
  
  Future<void> markAsRead(String notificationId) async {
    try {
      // Find notification
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index == -1) return;
      
      // Create updated notification
      final notification = notifications[index];
      final updatedNotification = notification.copyWith(isRead: true);
      
      // Update in list
      notifications[index] = updatedNotification;
      
      // In a real app, this would send a request to the API
      // await _apiService.markNotificationAsRead(notificationId);
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }
  
  Future<void> markAllAsRead() async {
    try {
      // Update all notifications in the list
      final updatedNotifications = notifications.map(
        (notification) => notification.copyWith(isRead: true)
      ).toList();
      
      notifications.value = updatedNotifications;
      
      // In a real app, this would send a request to the API
      // await _apiService.markAllNotificationsAsRead();
    } catch (e) {
      print('Error marking all notifications as read: $e');
    }
  }
  
  Future<void> deleteNotification(String notificationId) async {
    try {
      // Remove from list
      notifications.removeWhere((n) => n.id == notificationId);
      
      // In a real app, this would send a request to the API
      // await _apiService.deleteNotification(notificationId);
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }
  
  List<NotificationModel> _getMockNotifications() {
    final now = DateTime.now();
    
    return [
      NotificationModel(
        id: '1',
        title: 'New Arrivals',
        body: 'Check out our latest products that just arrived in store!',
        type: NotificationType.promotion,
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 2)),
        data: {
          'route': '/dashboard',
          'tabIndex': 0,
        },
      ),
      NotificationModel(
        id: '2',
        title: 'Special Offer',
        body: 'Use code SAVE20 to get 20% off on all electronics!',
        type: NotificationType.promotion,
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1)),
        data: {
          'route': '/dashboard',
          'tabIndex': 0,
        },
      ),
      NotificationModel(
        id: '3',
        title: 'Order #1234 Shipped',
        body: 'Your order has been shipped and is on its way to you.',
        type: NotificationType.order,
        isRead: false,
        createdAt: now.subtract(const Duration(days: 2)),
        data: {
          'route': '/orders',
          'orderId': '1234',
        },
      ),
      NotificationModel(
        id: '4',
        title: 'Price Drop Alert',
        body: 'The item in your wishlist is now 15% off!',
        type: NotificationType.priceAlert,
        isRead: false,
        createdAt: now.subtract(const Duration(days: 3)),
        data: {
          'route': '/wishlist',
        },
      ),
      NotificationModel(
        id: '5',
        title: 'Wallet Credit Added',
        body: '\$10 wallet credit added to your account.',
        type: NotificationType.account,
        isRead: true,
        createdAt: now.subtract(const Duration(days: 5)),
        data: {
          'route': '/profile',
        },
      ),
      NotificationModel(
        id: '6',
        title: 'Weekend Sale',
        body: 'Get up to 50% off on selected items this weekend only!',
        type: NotificationType.promotion,
        isRead: true,
        createdAt: now.subtract(const Duration(days: 7)),
        data: {
          'route': '/dashboard',
          'tabIndex': 0,
        },
      ),
    ];
  }
}