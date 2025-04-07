import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dimension_constants.dart';
import '../../../data/models/payment_method_model.dart';

class PaymentCard extends StatelessWidget {
  final PaymentMethodModel paymentMethod;
  final bool isDefault;
  final VoidCallback onTap;
  final VoidCallback onSetDefault;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PaymentCard({
    super.key,
    required this.paymentMethod,
    required this.isDefault,
    required this.onTap,
    required this.onSetDefault,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: DimensionConstants.spacingM),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        side: BorderSide(
          color: isDefault ? ColorConstants.primary : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(DimensionConstants.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Card logo
                      Icon(
                        _getCardIcon(paymentMethod.cardType),
                        size: 32,
                        color: ColorConstants.primary,
                      ),
                      const SizedBox(width: DimensionConstants.spacingM),
                      Text(
                        paymentMethod.cardType,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  if (isDefault)
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
              const SizedBox(height: DimensionConstants.spacingM),
              Text(
                paymentMethod.cardNumber,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    paymentMethod.cardholderName,
                    style: const TextStyle(color: ColorConstants.textSecondary),
                  ),
                  const Spacer(),
                  Text(
                    'Exp: ${paymentMethod.expiryDate}',
                    style: const TextStyle(color: ColorConstants.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!isDefault)
                    TextButton.icon(
                      onPressed: onSetDefault,
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text('Set as Default'),
                      style: TextButton.styleFrom(
                        foregroundColor: ColorConstants.primary,
                      ),
                    ),
                  const Spacer(),
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Edit',
                    color: ColorConstants.info,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Delete',
                    color: ColorConstants.error,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCardIcon(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return Icons.credit_card;
      case 'mastercard':
        return Icons.credit_card;
      case 'american express':
      case 'amex':
        return Icons.credit_card;
      case 'discover':
        return Icons.credit_card;
      case 'paypal':
        return Icons.account_balance_wallet;
      default:
        return Icons.credit_card;
    }
  }
}
