import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'checkout_controller.dart';
import 'widgets/address_selection_card.dart';
import 'widgets/order_summary_card.dart';
import 'widgets/payment_method_selection.dart';
import 'widgets/shipping_method_selection.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('Checkout')),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(DimensionConstants.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shipping Address
                  const Text(
                    'Shipping Address',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: DimensionConstants.spacingM),

                  AddressSelectionCard(
                    address: controller.selectedAddress.value,
                    onSelectAddress: controller.selectAddress,
                    onAddNewAddress: controller.addNewAddress,
                  ),

                  const SizedBox(height: DimensionConstants.spacingL),

                  // Shipping Method
                  const Text(
                    'Shipping Method',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: DimensionConstants.spacingM),

                  ShippingMethodSelection(
                    selectedMethod: controller.selectedShippingMethod.value,
                    shippingRates: controller.shippingRates,
                    onSelect: controller.selectShippingMethod,
                  ),

                  const SizedBox(height: DimensionConstants.spacingL),

                  // Payment Method
                  const Text(
                    'Payment Method',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: DimensionConstants.spacingM),

                  PaymentMethodSelection(
                    selectedMethod: controller.selectedPaymentMethod.value,
                    paymentMethods: controller.paymentMethods,
                    onSelect: controller.selectPaymentMethod,
                  ),

                  const SizedBox(height: DimensionConstants.spacingL),

                  // Promo Code
                  const Text(
                    'Promo Code',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: DimensionConstants.spacingM),

                  if (controller.promoApplied.value)
                    // Show applied promo code
                    Container(
                      padding: const EdgeInsets.all(
                        DimensionConstants.paddingM,
                      ),
                      decoration: BoxDecoration(
                        color: ColorConstants.successLight,
                        borderRadius: BorderRadius.circular(
                          DimensionConstants.radiusM,
                        ),
                        border: Border.all(color: ColorConstants.success),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: ColorConstants.success,
                          ),
                          const SizedBox(width: DimensionConstants.spacingM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Code Applied: ${controller.appliedPromoCode.value}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstants.success,
                                  ),
                                ),
                                Text(
                                  'Discount: ${NumberFormat.currency(symbol: '\$').format(controller.discount.value)}',
                                  style: const TextStyle(
                                    color: ColorConstants.success,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            color: ColorConstants.success,
                            onPressed: controller.removePromoCode,
                          ),
                        ],
                      ),
                    ),
                  if (!controller.promoApplied.value)
                    // Show promo code input field
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: controller.promoController,
                            label: 'Enter promo code',
                            prefixIcon: Icons.discount_outlined,
                            errorText:
                                controller.promoError.value.isEmpty
                                    ? null
                                    : controller.promoError.value,
                          ),
                        ),
                        const SizedBox(width: DimensionConstants.spacingM),
                        ElevatedButton(
                          onPressed:
                              controller.isValidatingPromo.value
                                  ? null
                                  : controller.applyPromoCode,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: DimensionConstants.paddingM,
                              vertical:
                                  14, // Match the height of the text field
                            ),
                            backgroundColor: ColorConstants.primary,
                          ),
                          child:
                              controller.isValidatingPromo.value
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Text('Apply'),
                        ),
                      ],
                    ),

                  const SizedBox(height: DimensionConstants.spacingL),

                  // Order Summary
                  const Text(
                    'Order Summary',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: DimensionConstants.spacingM),

                  OrderSummaryCard(
                    subtotal: controller.subtotal.value,
                    shipping: controller.shipping.value,
                    tax: controller.tax.value,
                    discount: controller.discount.value,
                    total: controller.total.value,
                  ),

                  const SizedBox(height: DimensionConstants.spacingL),

                  // Place Order Button
                  CustomButton(
                    onPressed:
                        controller.isProcessingOrder.value
                            ? null
                            : controller.placeOrder,
                    text:
                        controller.isProcessingOrder.value
                            ? 'Processing...'
                            : 'Place Order',
                    isLoading: controller.isProcessingOrder.value,
                    isFullWidth: true,
                  ),

                  const SizedBox(height: DimensionConstants.spacingM),

                  // Terms and conditions note
                  const Text(
                    'By placing your order, you agree to our Terms of Service and Privacy Policy.',
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorConstants.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: DimensionConstants.spacingM),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
