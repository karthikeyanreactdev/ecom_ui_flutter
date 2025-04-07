import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dimension_constants.dart';
import '../../../data/models/address_model.dart';

class AddressSelectionCard extends StatelessWidget {
  final AddressModel? address;
  final VoidCallback onSelectAddress;
  final VoidCallback onAddNewAddress;

  const AddressSelectionCard({
    super.key,
    required this.address,
    required this.onSelectAddress,
    required this.onAddNewAddress,
  });

  @override
  Widget build(BuildContext context) {
    if (address == null) {
      return _buildEmptyAddressCard();
    }

    return _buildAddressCard();
  }

  Widget _buildEmptyAddressCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DimensionConstants.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'No shipping address selected',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: DimensionConstants.spacingM),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onSelectAddress,
                    icon: const Icon(Icons.location_on_outlined),
                    label: const Text('Select Address'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      foregroundColor: ColorConstants.primary,
                      side: const BorderSide(color: ColorConstants.primary),
                    ),
                  ),
                ),
                const SizedBox(width: DimensionConstants.spacingM),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onAddNewAddress,
                    icon: const Icon(Icons.add_location_alt_outlined),
                    label: const Text('Add New'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: ColorConstants.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        side: const BorderSide(color: ColorConstants.primary, width: 1.5),
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
                  address!.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (address!.isDefault)
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
            Text(address!.phone),
            const SizedBox(height: 4),
            Text(address!.addressLine1),
            if (address!.addressLine2 != null &&
                address!.addressLine2!.isNotEmpty)
              Text(address!.addressLine2!),
            Text('${address!.city}, ${address!.state} ${address!.postalCode}'),
            Text(address!.country),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onSelectAddress,
                    icon: const Icon(Icons.edit_location_outlined),
                    label: const Text('Change'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      foregroundColor: ColorConstants.primary,
                      side: const BorderSide(color: ColorConstants.primary),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
