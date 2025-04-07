import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import 'payment_method_controller.dart';
import 'widgets/payment_card.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentMethodController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('Payment Methods')),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.paymentMethods.isEmpty) {
              return _buildEmptyState();
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(DimensionConstants.paddingM),
                    itemCount: controller.paymentMethods.length,
                    itemBuilder: (context, index) {
                      final method = controller.paymentMethods[index];
                      return PaymentCard(
                        paymentMethod: method,
                        isDefault: method.isDefault,
                        onTap: () => controller.selectPaymentMethod(method),
                        onSetDefault:
                            () => controller.setDefaultPaymentMethod(method),
                        onEdit:
                            () => Get.toNamed(
                              AppRoutes.editPaymentMethod,
                              arguments: method,
                            ),
                        onDelete: () => controller.deletePaymentMethod(method),
                      );
                    },
                  ),
                ),
                _buildBottomButton(),
              ],
            );
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Get.toNamed(AppRoutes.addPaymentMethod),
            backgroundColor: ColorConstants.primary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.credit_card_off_outlined,
            size: 80,
            color: ColorConstants.primary.withOpacity(0.5),
          ),
          const SizedBox(height: DimensionConstants.spacingM),
          Text(
            'No Payment Methods',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Get.isDarkMode ? Colors.white : ColorConstants.textPrimary,
            ),
          ),
          const SizedBox(height: DimensionConstants.spacingS),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'You haven\'t added any payment methods yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    Get.isDarkMode
                        ? Colors.white70
                        : ColorConstants.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: DimensionConstants.spacingL),
          CustomButton(
            onPressed: () => Get.toNamed(AppRoutes.addPaymentMethod),
            text: 'Add Payment Method',
            icon: Icons.add_card,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    if (Get.parameters.containsKey('fromCheckout') &&
        Get.parameters['fromCheckout'] == 'true') {
      return SafeArea(
        child: Container(
          padding: const EdgeInsets.all(DimensionConstants.paddingM),
          width: double.infinity,
          child: CustomButton(
            onPressed: () => Get.back(),
            text: 'Confirm Selection',
            isFullWidth: true,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
