import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dimension_constants.dart';
import '../../../widgets/custom_shimmer.dart';
import '../widgets/order_status_chip.dart';
import 'order_detail_controller.dart';
import 'widgets/order_timeline.dart';
import 'widgets/order_item_list.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderDetailController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Order Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => controller.refreshOrderDetails(),
                tooltip: 'Refresh',
              ),
            ],
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return _buildLoadingShimmer();
            } else if (controller.hasError.value) {
              return _buildErrorState(
                controller.errorMessage.value,
                controller,
              );
            } else if (controller.order.value == null) {
              return const Center(child: Text('No order details available'));
            } else {
              final order = controller.order.value!;
              final currencyFormatter = NumberFormat.currency(symbol: '\$');
              final dateFormatter = DateFormat('MMM dd, yyyy');
              final cancelledStatus = order.status.toLowerCase() == 'cancelled';

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order header
                    Container(
                      padding: const EdgeInsets.all(
                        DimensionConstants.paddingM,
                      ),
                      color:
                          Get.isDarkMode
                              ? ColorConstants.surfaceDark
                              : ColorConstants.surfaceLight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order #${order.id}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Placed on ${dateFormatter.format(order.createdAt)}',
                                    style: const TextStyle(
                                      color: ColorConstants.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              OrderStatusChip(status: order.status),
                            ],
                          ),
                          const SizedBox(height: DimensionConstants.spacingM),

                          // Tracking number if available
                          if (order.trackingNumber != null) ...[
                            const Text(
                              'Tracking Number',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  order.trackingNumber!,
                                  style: const TextStyle(
                                    color: ColorConstants.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: () {
                                    // Track order functionality
                                    Get.toNamed(
                                      '/track-order',
                                      arguments: order,
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text('Track Package'),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Order timeline (not shown for cancelled orders)
                    if (!cancelledStatus) OrderTimeline(status: order.status),

                    // Order items
                    Container(
                      padding: const EdgeInsets.all(
                        DimensionConstants.paddingM,
                      ),
                      color:
                          Get.isDarkMode
                              ? ColorConstants.surfaceDark
                              : ColorConstants.surfaceLight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Items',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                '${order.itemCount} ${order.itemCount == 1 ? 'item' : 'items'}',
                                style: const TextStyle(
                                  color: ColorConstants.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: DimensionConstants.spacingM),
                          OrderItemList(items: order.items),
                        ],
                      ),
                    ),

                    const SizedBox(height: DimensionConstants.spacingM),

                    // Shipping information
                    Container(
                      padding: const EdgeInsets.all(
                        DimensionConstants.paddingM,
                      ),
                      color:
                          Get.isDarkMode
                              ? ColorConstants.surfaceDark
                              : ColorConstants.surfaceLight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Shipping Address',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: DimensionConstants.spacingM),
                          Text(
                            order.shippingAddress.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(order.shippingAddress.phone),
                          const SizedBox(height: 4),
                          Text(order.shippingAddress.addressLine1),
                          if (order.shippingAddress.addressLine2 != null &&
                              order.shippingAddress.addressLine2!.isNotEmpty)
                            Text(order.shippingAddress.addressLine2!),
                          Text(
                            '${order.shippingAddress.city}, ${order.shippingAddress.state} ${order.shippingAddress.postalCode}',
                          ),
                          Text(order.shippingAddress.country),
                        ],
                      ),
                    ),

                    const SizedBox(height: DimensionConstants.spacingM),

                    // Payment information
                    Container(
                      padding: const EdgeInsets.all(
                        DimensionConstants.paddingM,
                      ),
                      color:
                          Get.isDarkMode
                              ? ColorConstants.surfaceDark
                              : ColorConstants.surfaceLight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Payment Details',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: DimensionConstants.spacingM),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Payment Method'),
                              Text(
                                order.paymentMethod,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),

                          // Price details
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Subtotal'),
                              Text(currencyFormatter.format(order.subtotal)),
                            ],
                          ),
                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Shipping'),
                              Text(currencyFormatter.format(order.shipping)),
                            ],
                          ),
                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Tax'),
                              Text(currencyFormatter.format(order.tax)),
                            ],
                          ),

                          if (order.discount > 0) ...[
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text('Discount'),
                                    if (order.couponCode != null) ...[
                                      const SizedBox(width: 4),
                                      Text(
                                        '(${order.couponCode})',
                                        style: const TextStyle(
                                          color: ColorConstants.success,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Text(
                                  '-${currencyFormatter.format(order.discount)}',
                                  style: const TextStyle(
                                    color: ColorConstants.success,
                                  ),
                                ),
                              ],
                            ),
                          ],

                          const Divider(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
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
                        ],
                      ),
                    ),

                    // Optional order notes
                    if (order.notes != null && order.notes!.isNotEmpty) ...[
                      const SizedBox(height: DimensionConstants.spacingM),
                      Container(
                        padding: const EdgeInsets.all(
                          DimensionConstants.paddingM,
                        ),
                        color:
                            Get.isDarkMode
                                ? ColorConstants.surfaceDark
                                : ColorConstants.surfaceLight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Order Notes',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: DimensionConstants.spacingS),
                            Text(order.notes!),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: DimensionConstants.spacingL),
                  ],
                ),
              );
            }
          }),
          bottomNavigationBar: Obx(() {
            if (controller.order.value == null || controller.isLoading.value) {
              return const SizedBox.shrink();
            }

            final order = controller.order.value!;
            return Container(
              padding: const EdgeInsets.all(DimensionConstants.paddingM),
              decoration: BoxDecoration(
                color:
                    Get.isDarkMode ? ColorConstants.surfaceDark : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (order.canCancel)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => controller.cancelOrder(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ColorConstants.error,
                          side: const BorderSide(color: ColorConstants.error),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Cancel Order'),
                      ),
                    ),
                  if (order.canCancel && order.canReturn)
                    const SizedBox(width: DimensionConstants.spacingM),
                  if (order.canReturn)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => controller.initiateReturn(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ColorConstants.primary,
                          side: const BorderSide(color: ColorConstants.primary),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Return Items'),
                      ),
                    ),
                  if (!order.canCancel && !order.canReturn)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => controller.downloadInvoice(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Download Invoice'),
                      ),
                    ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DimensionConstants.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header shimmer
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(DimensionConstants.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomShimmer(
                        height: 24,
                        width: 150,
                        borderRadius: DimensionConstants.radiusS,
                      ),
                      CustomShimmer(
                        height: 30,
                        width: 100,
                        borderRadius: DimensionConstants.radiusM,
                      ),
                    ],
                  ),
                  const SizedBox(height: DimensionConstants.spacingM),
                  CustomShimmer(
                    height: 18,
                    width: 200,
                    borderRadius: DimensionConstants.radiusS,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: DimensionConstants.spacingM),

          // Timeline shimmer
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(DimensionConstants.paddingM),
              child: Column(
                children: List.generate(4, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        CustomShimmer(height: 40, width: 40, borderRadius: 20),
                        const SizedBox(width: DimensionConstants.spacingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomShimmer(
                                height: 20,
                                width: 120,
                                borderRadius: DimensionConstants.radiusS,
                              ),
                              const SizedBox(
                                height: DimensionConstants.spacingS,
                              ),
                              CustomShimmer(
                                height: 16,
                                width: 180,
                                borderRadius: DimensionConstants.radiusS,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),

          const SizedBox(height: DimensionConstants.spacingM),

          // Items shimmer
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(DimensionConstants.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomShimmer(
                        height: 24,
                        width: 80,
                        borderRadius: DimensionConstants.radiusS,
                      ),
                      CustomShimmer(
                        height: 18,
                        width: 60,
                        borderRadius: DimensionConstants.radiusS,
                      ),
                    ],
                  ),
                  const SizedBox(height: DimensionConstants.spacingM),

                  // Item shimmer
                  ...List.generate(2, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomShimmer(
                            height: 80,
                            width: 80,
                            borderRadius: DimensionConstants.radiusS,
                          ),
                          const SizedBox(width: DimensionConstants.spacingM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomShimmer(
                                  height: 20,
                                  width: double.infinity,
                                  borderRadius: DimensionConstants.radiusS,
                                ),
                                const SizedBox(
                                  height: DimensionConstants.spacingS,
                                ),
                                CustomShimmer(
                                  height: 16,
                                  width: 120,
                                  borderRadius: DimensionConstants.radiusS,
                                ),
                                const SizedBox(
                                  height: DimensionConstants.spacingS,
                                ),
                                CustomShimmer(
                                  height: 18,
                                  width: 100,
                                  borderRadius: DimensionConstants.radiusS,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    String errorMessage,
    OrderDetailController controller,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DimensionConstants.paddingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: ColorConstants.error,
              size: 60,
            ),
            const SizedBox(height: DimensionConstants.spacingM),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:
                    Get.isDarkMode ? Colors.white : ColorConstants.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DimensionConstants.spacingS),
            Text(
              errorMessage,
              style: TextStyle(
                color:
                    Get.isDarkMode
                        ? Colors.white70
                        : ColorConstants.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DimensionConstants.spacingL),
            ElevatedButton.icon(
              onPressed: () => controller.refreshOrderDetails(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: DimensionConstants.paddingL,
                  vertical: DimensionConstants.paddingM,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
