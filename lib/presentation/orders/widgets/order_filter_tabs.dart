import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';

class OrderFilterTabs extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const OrderFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildFilterChip('all', 'All'),
          _buildFilterChip('pending', 'Pending'),
          _buildFilterChip('processing', 'Processing'),
          _buildFilterChip('shipped', 'Shipped'),
          _buildFilterChip('delivered', 'Delivered'),
          _buildFilterChip('cancelled', 'Cancelled'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final bool isSelected = selectedFilter == value;
    
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: ColorConstants.primaryLight,
        labelStyle: TextStyle(
          color: isSelected ? ColorConstants.primary : ColorConstants.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        onSelected: (selected) {
          if (selected) {
            onFilterChanged(value);
          }
        },
      ),
    );
  }
}