import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dimension_constants.dart';

class ShippingMethodSelection extends StatelessWidget {
  final String selectedMethod;
  final Map<String, double> shippingRates;
  final Function(String) onSelect;

  const ShippingMethodSelection({
    super.key,
    required this.selectedMethod,
    required this.shippingRates,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DimensionConstants.paddingM),
        child: Column(
          children: [
            ...shippingRates.entries.map(
              (entry) => _buildShippingMethodOption(entry.key, entry.value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingMethodOption(String method, double rate) {
    final bool isSelected = method == selectedMethod;
    final currencyFormatter = NumberFormat.currency(symbol: '\$');

    String estimatedDelivery;
    switch (method) {
      case 'Standard':
        estimatedDelivery = '3-5 business days';
        break;
      case 'Express':
        estimatedDelivery = '2-3 business days';
        break;
      case 'Next Day':
        estimatedDelivery = 'Next business day';
        break;
      default:
        estimatedDelivery = 'Delivery time varies';
        break;
    }

    return InkWell(
      onTap: () => onSelect(method),
      borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DimensionConstants.paddingM,
          vertical: DimensionConstants.paddingM,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
          border: Border.all(
            color: isSelected ? ColorConstants.primary : ColorConstants.divider,
            width: isSelected ? 2 : 1,
          ),
          color:
              isSelected ? ColorConstants.primaryLight.withOpacity(0.1) : null,
        ),
        margin: const EdgeInsets.only(bottom: DimensionConstants.spacingS),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    estimatedDelivery,
                    style: TextStyle(
                      color: ColorConstants.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              currencyFormatter.format(rate),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? ColorConstants.primary : null,
              ),
            ),
            const SizedBox(width: DimensionConstants.spacingS),
            Radio<String>(
              value: method,
              groupValue: selectedMethod,
              onChanged: (value) => onSelect(value!),
              activeColor: ColorConstants.primary,
            ),
          ],
        ),
      ),
    );
  }
}
