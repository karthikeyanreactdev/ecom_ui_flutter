import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';

class OrderStatusChip extends StatelessWidget {
  final String status;

  const OrderStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String displayText = status.toUpperCase();

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = ColorConstants.warningLight;
        textColor = ColorConstants.warningDark;
        break;
      case 'processing':
        backgroundColor = ColorConstants.infoLight;
        textColor = ColorConstants.infoDark;
        break;
      case 'shipped':
        backgroundColor = ColorConstants.primaryLight;
        textColor = ColorConstants.primaryDark;
        break;
      case 'delivered':
        backgroundColor = ColorConstants.successLight;
        textColor = ColorConstants.successDark;
        break;
      case 'cancelled':
        backgroundColor = ColorConstants.errorLight;
        textColor = ColorConstants.errorDark;
        break;
      default:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}