import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/order_model.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dimension_constants.dart';
import '../../../routes/app_routes.dart';
import 'order_status_chip.dart';

class OrderItemCard extends StatelessWidget {
  final OrderModel order;
  final Function(String) onCancelOrder;

  const OrderItemCard({
    super.key,
    required this.order,
    required this.onCancelOrder,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$');
    final dateFormatter = DateFormat('MMM dd, yyyy');

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: DimensionConstants.marginM,
        vertical: DimensionConstants.marginS,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
      ),
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.orderDetail, arguments: order);
        },
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(DimensionConstants.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order.id}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  OrderStatusChip(status: order.status),
                ],
              ),
              const SizedBox(height: DimensionConstants.spacingM),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: ColorConstants.textSecondary,
                  ),
                  const SizedBox(width: DimensionConstants.spacingS),
                  Text(
                    'Placed on ${dateFormatter.format(order.createdAt)}',
                    style: const TextStyle(
                      color: ColorConstants.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DimensionConstants.spacingS),
              Row(
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 16,
                    color: ColorConstants.textSecondary,
                  ),
                  const SizedBox(width: DimensionConstants.spacingS),
                  Text(
                    '${order.itemCount} ${order.itemCount == 1 ? 'item' : 'items'}',
                    style: const TextStyle(
                      color: ColorConstants.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (order.trackingNumber != null) ...[
                const SizedBox(height: DimensionConstants.spacingS),
                Row(
                  children: [
                    const Icon(
                      Icons.local_shipping_outlined,
                      size: 16,
                      color: ColorConstants.textSecondary,
                    ),
                    const SizedBox(width: DimensionConstants.spacingS),
                    Text(
                      'Tracking: ${order.trackingNumber}',
                      style: const TextStyle(
                        color: ColorConstants.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
              const Divider(height: DimensionConstants.spacingL),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  Text(
                    currencyFormatter.format(order.total),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: ColorConstants.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DimensionConstants.spacingM),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (order.canCancel)
                    OutlinedButton(
                      onPressed: () => onCancelOrder(order.id),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColorConstants.error,
                        side: const BorderSide(color: ColorConstants.error),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            DimensionConstants.radiusS,
                          ),
                        ),
                      ),
                      child: const Text('Cancel Order'),
                    ),
                  const SizedBox(width: DimensionConstants.spacingM),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.orderDetail, arguments: order);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          DimensionConstants.radiusS,
                        ),
                      ),
                    ),
                    child: const Text('View Details'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
