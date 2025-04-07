import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dimension_constants.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    Key? key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDarkMode
            ? ColorConstants.textPrimaryDark
            : ColorConstants.textPrimaryLight;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black12 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrement button
          _buildButton(
            icon: Icons.remove,
            onTap: onDecrement,
            isDarkMode: isDarkMode,
          ),

          // Quantity display
          Container(
            width: 50,
            color: isDarkMode ? Colors.black12 : Colors.white,
            child: Center(
              child: Text(
                quantity.toString(),
                style: TextStyle(
                  fontSize: DimensionConstants.textL,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),

          // Increment button
          _buildButton(
            icon: Icons.add,
            onTap: onIncrement,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black12 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
        ),
        child: Icon(
          icon,
          color: ColorConstants.primary,
          size: DimensionConstants.iconM,
        ),
      ),
    );
  }
}
