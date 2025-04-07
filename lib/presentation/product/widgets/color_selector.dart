import 'package:flutter/material.dart';
import '../../../core/constants/dimension_constants.dart';

class ColorSelector extends StatelessWidget {
  final List<String> colors;
  final String? selectedColor;
  final Function(String) onColorSelected;

  const ColorSelector({
    Key? key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: colors.map((color) {
          final isSelected = color == selectedColor;
          
          // Parse the color from the string
          final colorValue = _getColorFromString(color);
          
          return GestureDetector(
            onTap: () => onColorSelected(color),
            child: Container(
              margin: const EdgeInsets.only(right: DimensionConstants.marginM),
              child: Column(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: colorValue,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? const Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _getReadableColorName(color),
                    style: TextStyle(
                      fontSize: DimensionConstants.textXS,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  
  Color _getColorFromString(String colorString) {
    switch (colorString.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'orange':
        return Colors.orange;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'grey':
      case 'gray':
        return Colors.grey;
      case 'brown':
        return Colors.brown;
      case 'teal':
        return Colors.teal;
      case 'indigo':
        return Colors.indigo;
      case 'cyan':
        return Colors.cyan;
      case 'lime':
        return Colors.lime;
      case 'amber':
        return Colors.amber;
      default:
        // Try to parse hex color if it starts with #
        if (colorString.startsWith('#')) {
          try {
            return Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
          } catch (e) {
            return Colors.grey; // Default color if parsing fails
          }
        }
        return Colors.grey; // Default color
    }
  }
  
  String _getReadableColorName(String color) {
    // Capitalize first letter
    return color.substring(0, 1).toUpperCase() + color.substring(1).toLowerCase();
  }
}