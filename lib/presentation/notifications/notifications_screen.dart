import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../data/models/notification_model.dart';
import '../../widgets/animated_fade_in.dart';
import 'notifications_controller.dart';

class NotificationsScreen extends GetView<NotificationsController> {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode
            ? ColorConstants.backgroundDark
            : ColorConstants.backgroundLight;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildLoadingView();
          }

          if (controller.hasError.value) {
            return _buildErrorView();
          }

          if (controller.notifications.isEmpty) {
            return _buildEmptyView();
          }

          return _buildNotificationsList(context);
        }),
      ),
    );
  }

  Widget _buildNotificationsList(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDarkMode
            ? ColorConstants.textPrimaryDark
            : ColorConstants.textPrimaryLight;

    return RefreshIndicator(
      onRefresh: controller.refreshNotifications,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar
          SliverAppBar(
            title: const Text('Notifications'),
            floating: true,
            pinned: true,
            actions: [
              // Mark all as read button
              IconButton(
                icon: const Icon(Icons.done_all),
                tooltip: 'Mark all as read',
                onPressed: controller.markAllAsRead,
              ),
            ],
          ),

          // Notifications list
          SliverPadding(
            padding: const EdgeInsets.all(DimensionConstants.paddingL),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == 0) {
                    // Show heading for unread notifications
                    final unreadCount =
                        controller.notifications.where((n) => !n.isRead).length;

                    if (unreadCount == 0) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(
                        left: DimensionConstants.paddingS,
                        bottom: DimensionConstants.paddingM,
                      ),
                      child: Text(
                        'New ($unreadCount)',
                        style: TextStyle(
                          fontSize: DimensionConstants.textL,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    );
                  }

                  // Adjusted index to account for the heading
                  final adjustedIndex = index - 1;

                  // Show unread notifications first
                  final unreadNotifications =
                      controller.notifications.where((n) => !n.isRead).toList();
                  final readNotifications =
                      controller.notifications.where((n) => n.isRead).toList();

                  // Show "Earlier" heading before read notifications
                  if (adjustedIndex == unreadNotifications.length &&
                      readNotifications.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: DimensionConstants.paddingS,
                        top: DimensionConstants.paddingL,
                        bottom: DimensionConstants.paddingM,
                      ),
                      child: Text(
                        'Earlier',
                        style: TextStyle(
                          fontSize: DimensionConstants.textL,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    );
                  }

                  // Get the correct notification
                  late final NotificationModel notification;
                  if (adjustedIndex < unreadNotifications.length) {
                    notification = unreadNotifications[adjustedIndex];
                  } else if (adjustedIndex > unreadNotifications.length) {
                    // Adjusted for the "Earlier" heading
                    notification =
                        readNotifications[adjustedIndex -
                            unreadNotifications.length -
                            1];
                  } else {
                    // This is the "Earlier" heading, already handled above
                    return const SizedBox.shrink();
                  }

                  return AnimatedFadeIn(
                    delay: Duration(milliseconds: index * 50),
                    child: NotificationTile(
                      notification: notification,
                      onTap: () {
                        // Mark as read if not already
                        if (!notification.isRead) {
                          controller.markAsRead(notification.id);
                        }

                        // Handle navigation based on notification type/data
                        if (notification.data != null &&
                            notification.data!.containsKey('route')) {
                          final route = notification.data!['route'] as String;
                          Get.toNamed(route, arguments: notification.data);
                        }
                      },
                      onDismiss:
                          () => controller.deleteNotification(notification.id),
                    ),
                  );
                },
                childCount:
                    2 + controller.notifications.length, // +2 for headings
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 60,
            color: ColorConstants.error,
          ),
          const SizedBox(height: DimensionConstants.marginL),
          Text(
            controller.errorMessage.value,
            style: const TextStyle(
              fontSize: DimensionConstants.textL,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DimensionConstants.marginL),
          ElevatedButton(
            onPressed: controller.refreshNotifications,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: DimensionConstants.marginL),
          const Text(
            'No Notifications',
            style: TextStyle(
              fontSize: DimensionConstants.textXL,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: DimensionConstants.marginM),
          const Text(
            'You don\'t have any notifications yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: DimensionConstants.textM,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const NotificationTile({
    Key? key,
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        isDarkMode ? ColorConstants.cardDark : ColorConstants.cardLight;
    final textColor =
        isDarkMode
            ? ColorConstants.textPrimaryDark
            : ColorConstants.textPrimaryLight;
    final secondaryTextColor =
        isDarkMode
            ? ColorConstants.textSecondaryDark
            : ColorConstants.textSecondaryLight;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: DimensionConstants.paddingL),
        color: ColorConstants.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) => onDismiss(),
      child: Container(
        margin: const EdgeInsets.only(bottom: DimensionConstants.marginM),
        decoration: BoxDecoration(
          color:
              notification.isRead
                  ? cardColor
                  : cardColor.withOpacity(isDarkMode ? 0.6 : 0.9),
          borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border:
              !notification.isRead
                  ? Border.all(
                    color: _getNotificationColor(notification.type),
                    width: 1,
                  )
                  : null,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
          child: Padding(
            padding: const EdgeInsets.all(DimensionConstants.paddingL),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getNotificationColor(
                      notification.type,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      DimensionConstants.radiusS,
                    ),
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    color: _getNotificationColor(notification.type),
                  ),
                ),

                const SizedBox(width: DimensionConstants.marginM),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: DimensionConstants.textM,
                          fontWeight:
                              notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(height: DimensionConstants.marginXS),

                      // Body
                      Text(
                        notification.body,
                        style: TextStyle(
                          fontSize: DimensionConstants.textS,
                          color: secondaryTextColor,
                        ),
                      ),

                      const SizedBox(height: DimensionConstants.marginS),

                      // Timestamp
                      Text(
                        _formatTimestamp(notification.createdAt),
                        style: TextStyle(
                          fontSize: DimensionConstants.textXS,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Read/Unread indicator
                if (!notification.isRead)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _getNotificationColor(notification.type),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return Icons.local_shipping;
      case NotificationType.promotion:
        return Icons.local_offer;
      case NotificationType.account:
        return Icons.account_circle;
      case NotificationType.priceAlert:
        return Icons.price_change;
      case NotificationType.general:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return ColorConstants.info;
      case NotificationType.promotion:
        return ColorConstants.accent;
      case NotificationType.account:
        return ColorConstants.primary;
      case NotificationType.priceAlert:
        return Colors.green;
      case NotificationType.general:
        return Colors.grey;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return DateFormat('MMM d, y').format(timestamp);
    }
  }
}
