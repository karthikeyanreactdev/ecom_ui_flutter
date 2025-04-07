import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../data/models/address_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import 'address_list_controller.dart';

class AddressListScreen extends StatelessWidget {
  const AddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressListController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('My Addresses')),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.addresses.isEmpty) {
              return _buildEmptyState();
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(DimensionConstants.paddingM),
                    itemCount: controller.addresses.length,
                    itemBuilder: (context, index) {
                      final address = controller.addresses[index];
                      return _buildAddressCard(address, controller);
                    },
                  ),
                ),
                _buildBottomButton(),
              ],
            );
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Get.toNamed(AppRoutes.addAddress),
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
            Icons.location_off_outlined,
            size: 80,
            color: ColorConstants.primary.withOpacity(0.5),
          ),
          const SizedBox(height: DimensionConstants.spacingM),
          Text(
            'No Addresses Found',
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
              'You haven\'t added any shipping addresses yet.',
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
            onPressed: () => Get.toNamed(AppRoutes.addAddress),
            text: 'Add New Address',
            icon: Icons.add_location_alt_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(
    AddressModel address,
    AddressListController controller,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: DimensionConstants.spacingM),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        side: BorderSide(
          color:
              address.isDefault ? ColorConstants.primary : Colors.transparent,
          width: 1.5,
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
                Text(
                  address.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (address.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ColorConstants.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Default',
                      style: TextStyle(
                        color: ColorConstants.primaryDark,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(address.phone),
            const SizedBox(height: 4),
            Text(address.addressLine1),
            if (address.addressLine2 != null &&
                address.addressLine2!.isNotEmpty)
              Text(address.addressLine2!),
            Text('${address.city}, ${address.state} ${address.postalCode}'),
            Text(address.country),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!address.isDefault)
                  TextButton.icon(
                    onPressed: () => controller.setDefaultAddress(address),
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text('Set as Default'),
                    style: TextButton.styleFrom(
                      foregroundColor: ColorConstants.primary,
                    ),
                  ),
                const Spacer(),
                IconButton(
                  onPressed:
                      () => Get.toNamed(
                        AppRoutes.editAddress,
                        arguments: address,
                      ),
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Edit',
                  color: ColorConstants.info,
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => controller.deleteAddress(address),
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Delete',
                  color: ColorConstants.error,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    // This button appears when coming from checkout
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
