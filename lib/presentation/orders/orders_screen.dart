import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../widgets/custom_shimmer.dart';
import 'orders_controller.dart';
import 'widgets/order_filter_tabs.dart';
import 'widgets/order_item_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
      builder: (controller) {
        // For development purposes, generate mock data
        if (controller.orders.isEmpty &&
            !controller.isLoading.value &&
            !controller.hasError.value) {
          controller.generateMockOrders();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Orders'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => controller.refreshOrders(),
                tooltip: 'Refresh',
              ),
            ],
          ),
          body: Column(
            children: [
              // Order filter tabs
              Obx(
                () => OrderFilterTabs(
                  selectedFilter: controller.selectedFilter.value,
                  onFilterChanged: controller.filterOrders,
                ),
              ),

              const SizedBox(height: DimensionConstants.spacingM),

              // Orders list
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value && controller.orders.isEmpty) {
                    return _buildLoadingShimmer();
                  } else if (controller.hasError.value &&
                      controller.orders.isEmpty) {
                    return _buildErrorState(
                      controller.errorMessage.value,
                      controller,
                    );
                  } else if (controller.orders.isEmpty) {
                    return _buildEmptyState();
                  } else {
                    return RefreshIndicator(
                      onRefresh: controller.refreshOrders,
                      child: ListView.builder(
                        controller: controller.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(
                          top: DimensionConstants.paddingS,
                          bottom: DimensionConstants.paddingL,
                        ),
                        itemCount:
                            controller.orders.length +
                            (controller.hasMorePages.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == controller.orders.length) {
                            return controller.isLoading.value
                                ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                                : const SizedBox.shrink();
                          }

                          final order = controller.orders[index];
                          return OrderItemCard(
                            order: order,
                            onCancelOrder: controller.cancelOrder,
                          );
                        },
                      ),
                    );
                  }
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(DimensionConstants.paddingM),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: DimensionConstants.paddingM),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
            ),
            child: Padding(
              padding: const EdgeInsets.all(DimensionConstants.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomShimmer(
                        height: 20,
                        width: 120,
                        borderRadius: DimensionConstants.radiusS,
                      ),
                      CustomShimmer(
                        height: 24,
                        width: 80,
                        borderRadius: DimensionConstants.radiusM,
                      ),
                    ],
                  ),
                  const SizedBox(height: DimensionConstants.spacingM),
                  CustomShimmer(
                    height: 16,
                    width: 160,
                    borderRadius: DimensionConstants.radiusS,
                  ),
                  const SizedBox(height: DimensionConstants.spacingS),
                  CustomShimmer(
                    height: 16,
                    width: 120,
                    borderRadius: DimensionConstants.radiusS,
                  ),
                  const SizedBox(height: DimensionConstants.spacingL),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomShimmer(
                        height: 20,
                        width: 80,
                        borderRadius: DimensionConstants.radiusS,
                      ),
                      CustomShimmer(
                        height: 20,
                        width: 100,
                        borderRadius: DimensionConstants.radiusS,
                      ),
                    ],
                  ),
                  const SizedBox(height: DimensionConstants.spacingM),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomShimmer(
                        height: 40,
                        width: 100,
                        borderRadius: DimensionConstants.radiusS,
                      ),
                      const SizedBox(width: DimensionConstants.spacingM),
                      CustomShimmer(
                        height: 40,
                        width: 100,
                        borderRadius: DimensionConstants.radiusS,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String errorMessage, OrdersController controller) {
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
              onPressed: () => controller.refreshOrders(),
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DimensionConstants.paddingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              color: ColorConstants.primary,
              size: 80,
            ),
            const SizedBox(height: DimensionConstants.spacingM),
            Text(
              'No Orders Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color:
                    Get.isDarkMode ? Colors.white : ColorConstants.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DimensionConstants.spacingS),
            Text(
              'Looks like you haven\'t placed any orders yet.',
              style: TextStyle(
                fontSize: 16,
                color:
                    Get.isDarkMode
                        ? Colors.white70
                        : ColorConstants.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DimensionConstants.spacingL),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('Start Shopping'),
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
