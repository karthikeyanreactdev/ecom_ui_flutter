import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dimension_constants.dart';
import '../../../widgets/animated_fade_in.dart';
import '../../../widgets/custom_button.dart';
import '../dashboard_controller.dart';
import 'cart_controller.dart';
import 'widgets/cart_item_tile.dart';
import 'widgets/cart_summary.dart';
import 'widgets/promo_code_field.dart';
import 'widgets/shipping_options.dart';

class CartScreen extends GetView<CartController> {
  const CartScreen({Key? key}) : super(key: key);

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

          if (controller.cartItems.isEmpty) {
            return _buildEmptyCartView();
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App Bar
              SliverAppBar(
                title: Text('Shopping Cart (${controller.cartItems.length})'),
                floating: true,
                backgroundColor: backgroundColor,
              ),

              // Cart Items
              SliverPadding(
                padding: const EdgeInsets.all(DimensionConstants.paddingL),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = controller.cartItems[index];
                    return AnimatedFadeIn(
                      delay: Duration(milliseconds: index * 50),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: DimensionConstants.paddingL,
                        ),
                        child: CartItemTile(
                          item: item,
                          onIncreaseQuantity: () {
                            HapticFeedback.selectionClick();
                            controller.increaseQuantity(item);
                          },
                          onDecreaseQuantity: () {
                            HapticFeedback.selectionClick();
                            controller.decreaseQuantity(item);
                          },
                          onRemove: () {
                            HapticFeedback.mediumImpact();
                            controller.removeItem(item);
                          },
                        ),
                      ),
                    );
                  }, childCount: controller.cartItems.length),
                ),
              ),

              // Promo Code
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DimensionConstants.paddingL,
                    vertical: DimensionConstants.paddingM,
                  ),
                  child: PromoCodeField(
                    controller: controller.promoCodeController,
                    isValid: controller.isPromoCodeValid.value,
                    isLoading: controller.isApplyingPromo.value,
                    onApply: () {
                      HapticFeedback.mediumImpact();
                      controller.applyPromoCode();
                    },
                    onRemove: () {
                      HapticFeedback.selectionClick();
                      controller.removePromoCode();
                    },
                  ),
                ),
              ),

              // Shipping Options
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DimensionConstants.paddingL,
                    vertical: DimensionConstants.paddingM,
                  ),
                  child: ShippingOptions(
                    selectedOption: controller.shippingOption.value,
                    onOptionSelected: (option) {
                      HapticFeedback.selectionClick();
                      controller.setShippingOption(option);
                    },
                    freeShippingThreshold: 50.0,
                    currentSubtotal: controller.subtotal.value,
                  ),
                ),
              ),

              // Order Summary
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(DimensionConstants.paddingL),
                  child: CartSummary(
                    subtotal: controller.subtotal.value,
                    shippingCost: controller.shippingCost.value,
                    tax: controller.tax.value,
                    discount: controller.promoDiscount.value,
                    total: controller.total.value,
                  ),
                ),
              ),

              // Checkout Button
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: DimensionConstants.paddingL,
                    right: DimensionConstants.paddingL,
                    bottom:
                        DimensionConstants.paddingL +
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: CustomButton(
                    text: 'Proceed to Checkout',
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      controller.proceedToCheckout();
                    },
                    isFullWidth: true,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildEmptyCartView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: DimensionConstants.marginL),
          const Text(
            'Your Cart is Empty',
            style: TextStyle(
              fontSize: DimensionConstants.textXL,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: DimensionConstants.marginM),
          const Text(
            'Looks like you haven\'t added\nany items to your cart yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: DimensionConstants.textM,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: DimensionConstants.marginXL),
          CustomButton(
            text: 'Start Shopping',
            onPressed: () {
              // Navigate to home and select the first tab
              Get.find<DashboardController>().changePage(0);
            },
          ),
        ],
      ),
    );
  }
}
