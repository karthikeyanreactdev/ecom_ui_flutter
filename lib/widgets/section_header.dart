import 'package:flutter/material.dart';
import '../core/constants/color_constants.dart';
import '../core/constants/dimension_constants.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;
  final double bottomPadding;

  const SectionHeader({
    Key? key,
    required this.title,
    this.actionText,
    this.onActionTap,
    this.bottomPadding = DimensionConstants.marginM,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDarkMode
            ? ColorConstants.textPrimaryDark
            : ColorConstants.textPrimaryLight;

    return Padding(
      padding: EdgeInsets.only(
        left: DimensionConstants.paddingL,
        right: DimensionConstants.paddingL,
        bottom: bottomPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: DimensionConstants.textXL,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          if (actionText != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionText!,
                style: const TextStyle(
                  fontSize: DimensionConstants.textM,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
