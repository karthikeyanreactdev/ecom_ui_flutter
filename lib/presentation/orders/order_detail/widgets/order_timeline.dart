import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../../../core/constants/color_constants.dart';

class OrderTimeline extends StatelessWidget {
  final String status;

  const OrderTimeline({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Column(
        children: [
          _buildTimelineTile(
            isFirst: true,
            isLast: false,
            isActive: true,
            title: 'Order Placed',
            subtitle: 'Your order has been placed',
            icon: Icons.shopping_cart_checkout,
          ),
          _buildTimelineTile(
            isFirst: false,
            isLast: false,
            isActive: _isStatusActive('processing'),
            title: 'Processing',
            subtitle: 'Your order is being processed',
            icon: Icons.inventory,
          ),
          _buildTimelineTile(
            isFirst: false,
            isLast: false,
            isActive: _isStatusActive('shipped'),
            title: 'Shipped',
            subtitle: 'Your order has been shipped',
            icon: Icons.local_shipping,
          ),
          _buildTimelineTile(
            isFirst: false,
            isLast: true,
            isActive: _isStatusActive('delivered'),
            title: 'Delivered',
            subtitle: 'Your order has been delivered',
            icon: Icons.check_circle,
          ),
        ],
      ),
    );
  }

  bool _isStatusActive(String checkStatus) {
    final statuses = ['pending', 'processing', 'shipped', 'delivered'];
    final currentIndex = statuses.indexOf(status.toLowerCase());
    final checkIndex = statuses.indexOf(checkStatus.toLowerCase());
    
    // If the order is cancelled, nothing beyond "Order Placed" is active
    if (status.toLowerCase() == 'cancelled') {
      return false;
    }
    
    return currentIndex >= checkIndex && checkIndex != -1;
  }

  Widget _buildTimelineTile({
    required bool isFirst,
    required bool isLast,
    required bool isActive,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.2,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 40,
        height: 40,
        indicator: Container(
          decoration: BoxDecoration(
            color: isActive ? ColorConstants.primary : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.white : Colors.grey,
            size: 20,
          ),
        ),
      ),
      beforeLineStyle: LineStyle(
        color: isActive ? ColorConstants.primary : Colors.grey.shade300,
        thickness: 2,
      ),
      afterLineStyle: LineStyle(
        color: isActive && !isLast ? ColorConstants.primary : Colors.grey.shade300,
        thickness: 2,
      ),
      endChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isActive ? ColorConstants.textPrimary : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: isActive ? ColorConstants.textSecondary : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}