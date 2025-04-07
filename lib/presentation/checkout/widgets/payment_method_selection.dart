import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dimension_constants.dart';

class PaymentMethodSelection extends StatelessWidget {
  final String selectedMethod;
  final List<String> paymentMethods;
  final Function(String) onSelect;

  const PaymentMethodSelection({
    super.key,
    required this.selectedMethod,
    required this.paymentMethods,
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
            ...paymentMethods.map(
              (method) => _buildPaymentMethodOption(method),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption(String method) {
    final bool isSelected = method == selectedMethod;
    final IconData icon = _getIconForMethod(method);

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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorConstants.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: ColorConstants.primary),
            ),
            const SizedBox(width: DimensionConstants.spacingM),
            Expanded(
              child: Text(
                method,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
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

  IconData _getIconForMethod(String method) {
    switch (method) {
      case 'Credit Card':
        return Icons.credit_card;
      case 'PayPal':
        return Icons.account_balance_wallet;
      case 'Apple Pay':
        return Icons.apple;
      case 'Google Pay':
        return Icons.g_mobiledata;
      default:
        return Icons.payment;
    }
  }
}
