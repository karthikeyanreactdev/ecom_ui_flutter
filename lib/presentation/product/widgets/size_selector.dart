import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dimension_constants.dart';

class SizeSelector extends StatelessWidget {
  final List<String> sizes;
  final String? selectedSize;
  final Function(String) onSizeSelected;

  const SizeSelector({
    Key? key,
    required this.sizes,
    required this.selectedSize,
    required this.onSizeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDarkMode
            ? ColorConstants.textPrimaryDark
            : ColorConstants.textPrimaryLight;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children:
            sizes.map((size) {
              final isSelected = size == selectedSize;

              return GestureDetector(
                onTap: () => onSizeSelected(size),
                child: Container(
                  margin: const EdgeInsets.only(
                    right: DimensionConstants.marginM,
                  ),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? ColorConstants.primary
                            : isDarkMode
                            ? Colors.black12
                            : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(
                      DimensionConstants.radiusS,
                    ),
                    border: Border.all(
                      color:
                          isSelected
                              ? ColorConstants.primary
                              : Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      size,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : textColor,
                        fontSize: DimensionConstants.textM,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
