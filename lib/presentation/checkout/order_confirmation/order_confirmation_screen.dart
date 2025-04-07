import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dimension_constants.dart';
import '../../../data/models/order_model.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/custom_button.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderModel order = Get.arguments;
    final dateFormatter = DateFormat('MMMM dd, yyyy');
    final currencyFormatter = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DimensionConstants.paddingM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: DimensionConstants.spacingL),

              // Success animation
              SizedBox(
                height: 200,
                child: Lottie.asset(
                  'assets/animations/order_success.json',
                  repeat: false,
                ),
              ),

              const SizedBox(height: DimensionConstants.spacingL),

              // Success message
              const Text(
                'Order Placed Successfully!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.primary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: DimensionConstants.spacingM),

              const Text(
                'Thank you for your purchase. Your order has been received and is being processed.',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConstants.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: DimensionConstants.spacingL),

              // Order details card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    DimensionConstants.radiusM,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(DimensionConstants.paddingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Order Number',
                            style: TextStyle(
                              color: ColorConstants.textSecondary,
                            ),
                          ),
                          Text(
                            order.id,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Date',
                            style: TextStyle(
                              color: ColorConstants.textSecondary,
                            ),
                          ),
                          Text(
                            dateFormatter.format(order.createdAt),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount',
                            style: TextStyle(
                              color: ColorConstants.textSecondary,
                            ),
                          ),
                          Text(
                            currencyFormatter.format(order.total),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.primary,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Payment Method',
                            style: TextStyle(
                              color: ColorConstants.textSecondary,
                            ),
                          ),
                          Text(
                            order.paymentMethod,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      const Text(
                        'Items',
                        style: TextStyle(color: ColorConstants.textSecondary),
                      ),
                      const SizedBox(height: 8),
                      ...order.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Text(
                                '${item.quantity} × ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  item.product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(
                                currencyFormatter.format(
                                  (item.discountedPrice ?? item.product.price) *
                                      item.quantity,
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: DimensionConstants.spacingL),

              // Shipping information
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(DimensionConstants.paddingM),
                decoration: BoxDecoration(
                  color: ColorConstants.surfaceVariant,
                  borderRadius: BorderRadius.circular(
                    DimensionConstants.radiusM,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Shipping Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(order.shippingAddress.name),
                    Text(order.shippingAddress.phone),
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

              const SizedBox(height: DimensionConstants.spacingL),

              CustomButton(
                onPressed: () => Get.offAllNamed(AppRoutes.dashboard),
                text: 'Continue Shopping',
                isFullWidth: true,
              ),

              const SizedBox(height: DimensionConstants.spacingM),

              OutlinedButton(
                onPressed: () => Get.toNamed(AppRoutes.orders),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  side: const BorderSide(color: ColorConstants.primary),
                  foregroundColor: ColorConstants.primary,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('View My Orders'),
              ),

              const SizedBox(height: DimensionConstants.spacingL),
            ],
          ),
        ),
      ),
    );
  }
}
