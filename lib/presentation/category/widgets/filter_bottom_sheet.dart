import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dimension_constants.dart';
import '../../../data/models/category_model.dart';

class FilterBottomSheet extends StatelessWidget {
  final Map<String, dynamic> activeFilters;
  final Function(String, dynamic) onFilterToggled;
  final VoidCallback onResetFilters;
  final CategoryModel category;

  const FilterBottomSheet({
    Key? key,
    required this.activeFilters,
    required this.onFilterToggled,
    required this.onResetFilters,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? ColorConstants.cardDark : ColorConstants.cardLight;
    final textColor =
        isDarkMode
            ? ColorConstants.textPrimaryDark
            : ColorConstants.textPrimaryLight;
    final secondaryTextColor =
        isDarkMode
            ? ColorConstants.textSecondaryDark
            : ColorConstants.textSecondaryLight;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.only(
        top: DimensionConstants.paddingL,
        bottom: DimensionConstants.paddingXL,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(DimensionConstants.radiusXL),
          topRight: Radius.circular(DimensionConstants.radiusXL),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const SizedBox(height: DimensionConstants.marginL),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DimensionConstants.paddingL,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: DimensionConstants.textXL,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Row(
                  children: [
                    if (activeFilters.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          onResetFilters();
                        },
                        child: const Text(
                          'Reset',
                          style: TextStyle(
                            color: ColorConstants.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close, color: secondaryTextColor),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(),

          // Filter content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price range
                  _buildFilterSection(
                    title: 'Price Range',
                    child: _buildPriceFilters(context),
                  ),

                  // Brands
                  _buildFilterSection(
                    title: 'Brand',
                    child: _buildBrandFilters(context),
                  ),

                  // Rating
                  _buildFilterSection(
                    title: 'Rating',
                    child: _buildRatingFilters(context),
                  ),

                  // Availability
                  _buildFilterSection(
                    title: 'Availability',
                    child: _buildAvailabilityFilters(context),
                  ),

                  // Discounted
                  _buildFilterSection(
                    title: 'Discount',
                    child: _buildDiscountFilters(context),
                  ),

                  const SizedBox(height: DimensionConstants.marginXXL),
                ],
              ),
            ),
          ),

          // Apply button
          Padding(
            padding: const EdgeInsets.all(DimensionConstants.paddingL),
            child: SizedBox(
              width: double.infinity,
              height: DimensionConstants.buttonHeight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      DimensionConstants.radiusM,
                    ),
                  ),
                ),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  Get.back();
                },
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontSize: DimensionConstants.textL,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({required String title, required Widget child}) {
    final isDarkMode = Get.isDarkMode;
    final textColor =
        isDarkMode
            ? ColorConstants.textPrimaryDark
            : ColorConstants.textPrimaryLight;

    return Padding(
      padding: const EdgeInsets.only(
        left: DimensionConstants.paddingL,
        right: DimensionConstants.paddingL,
        top: DimensionConstants.paddingL,
        bottom: DimensionConstants.paddingM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: DimensionConstants.textL,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: DimensionConstants.marginM),
          child,
        ],
      ),
    );
  }

  Widget _buildPriceFilters(BuildContext context) {
    return Wrap(
      spacing: DimensionConstants.marginS,
      runSpacing: DimensionConstants.marginS,
      children: [
        _buildFilterChip(
          context: context,
          label: 'Under \$50',
          value: 'under-50',
          filterKey: 'price',
          isSelected: activeFilters['price'] == 'under-50',
          onSelected: () => onFilterToggled('price', 'under-50'),
        ),
        _buildFilterChip(
          context: context,
          label: '\$50 - \$100',
          value: '50-100',
          filterKey: 'price',
          isSelected: activeFilters['price'] == '50-100',
          onSelected: () => onFilterToggled('price', '50-100'),
        ),
        _buildFilterChip(
          context: context,
          label: '\$100 - \$200',
          value: '100-200',
          filterKey: 'price',
          isSelected: activeFilters['price'] == '100-200',
          onSelected: () => onFilterToggled('price', '100-200'),
        ),
        _buildFilterChip(
          context: context,
          label: '\$200 - \$500',
          value: '200-500',
          filterKey: 'price',
          isSelected: activeFilters['price'] == '200-500',
          onSelected: () => onFilterToggled('price', '200-500'),
        ),
        _buildFilterChip(
          context: context,
          label: 'Over \$500',
          value: 'over-500',
          filterKey: 'price',
          isSelected: activeFilters['price'] == 'over-500',
          onSelected: () => onFilterToggled('price', 'over-500'),
        ),
      ],
    );
  }

  Widget _buildBrandFilters(BuildContext context) {
    // Mock brands based on category
    final List<String> brands = _getBrandsForCategory(category);

    return Wrap(
      spacing: DimensionConstants.marginS,
      runSpacing: DimensionConstants.marginS,
      children:
          brands.map((brand) {
            return _buildFilterChip(
              context: context,
              label: brand,
              value: brand,
              filterKey: 'brand',
              isSelected: activeFilters['brand'] == brand,
              onSelected: () => onFilterToggled('brand', brand),
            );
          }).toList(),
    );
  }

  Widget _buildRatingFilters(BuildContext context) {
    return Wrap(
      spacing: DimensionConstants.marginS,
      runSpacing: DimensionConstants.marginS,
      children: [
        _buildFilterChip(
          context: context,
          label: '4★ & above',
          value: '4-and-up',
          filterKey: 'rating',
          isSelected: activeFilters['rating'] == '4-and-up',
          onSelected: () => onFilterToggled('rating', '4-and-up'),
        ),
        _buildFilterChip(
          context: context,
          label: '3★ & above',
          value: '3-and-up',
          filterKey: 'rating',
          isSelected: activeFilters['rating'] == '3-and-up',
          onSelected: () => onFilterToggled('rating', '3-and-up'),
        ),
        _buildFilterChip(
          context: context,
          label: '2★ & above',
          value: '2-and-up',
          filterKey: 'rating',
          isSelected: activeFilters['rating'] == '2-and-up',
          onSelected: () => onFilterToggled('rating', '2-and-up'),
        ),
      ],
    );
  }

  Widget _buildAvailabilityFilters(BuildContext context) {
    return Wrap(
      spacing: DimensionConstants.marginS,
      runSpacing: DimensionConstants.marginS,
      children: [
        _buildFilterChip(
          context: context,
          label: 'In Stock',
          value: 'in-stock',
          filterKey: 'availability',
          isSelected: activeFilters['availability'] == 'in-stock',
          onSelected: () => onFilterToggled('availability', 'in-stock'),
        ),
        _buildFilterChip(
          context: context,
          label: 'Out of Stock',
          value: 'out-of-stock',
          filterKey: 'availability',
          isSelected: activeFilters['availability'] == 'out-of-stock',
          onSelected: () => onFilterToggled('availability', 'out-of-stock'),
        ),
      ],
    );
  }

  Widget _buildDiscountFilters(BuildContext context) {
    return Wrap(
      spacing: DimensionConstants.marginS,
      runSpacing: DimensionConstants.marginS,
      children: [
        _buildFilterChip(
          context: context,
          label: 'On Sale',
          value: 'on-sale',
          filterKey: 'discount',
          isSelected: activeFilters['discount'] == 'on-sale',
          onSelected: () => onFilterToggled('discount', 'on-sale'),
        ),
        _buildFilterChip(
          context: context,
          label: '10% or more',
          value: '10-or-more',
          filterKey: 'discount',
          isSelected: activeFilters['discount'] == '10-or-more',
          onSelected: () => onFilterToggled('discount', '10-or-more'),
        ),
        _buildFilterChip(
          context: context,
          label: '20% or more',
          value: '20-or-more',
          filterKey: 'discount',
          isSelected: activeFilters['discount'] == '20-or-more',
          onSelected: () => onFilterToggled('discount', '20-or-more'),
        ),
        _buildFilterChip(
          context: context,
          label: '30% or more',
          value: '30-or-more',
          filterKey: 'discount',
          isSelected: activeFilters['discount'] == '30-or-more',
          onSelected: () => onFilterToggled('discount', '30-or-more'),
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required String value,
    required String filterKey,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    final isDarkMode = Get.isDarkMode;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onSelected();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DimensionConstants.paddingM,
          vertical: DimensionConstants.paddingS,
        ),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? ColorConstants.primary
                  : isDarkMode
                  ? Colors.grey.shade800
                  : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
          border:
              isSelected
                  ? Border.all(color: ColorConstants.primary, width: 1)
                  : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: DimensionConstants.textS,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color:
                isSelected
                    ? Colors.white
                    : isDarkMode
                    ? ColorConstants.textPrimaryDark
                    : ColorConstants.textPrimaryLight,
          ),
        ),
      ),
    );
  }

  List<String> _getBrandsForCategory(CategoryModel category) {
    // Mock brands based on category
    switch (category.id) {
      case '1': // Electronics
        return ['Apple', 'Samsung', 'Sony', 'LG', 'Bose', 'Dell', 'HP'];
      case '2': // Fashion
        return [
          'Nike',
          'Adidas',
          'Zara',
          'H&M',
          'Levi\'s',
          'Gucci',
          'Calvin Klein',
        ];
      case '3': // Home & Kitchen
        return [
          'Ikea',
          'Crate & Barrel',
          'KitchenAid',
          'Cuisinart',
          'Dyson',
          'Ninja',
        ];
      case '4': // Beauty
        return [
          'L\'Oreal',
          'Maybelline',
          'MAC',
          'Estee Lauder',
          'Clinique',
          'Fenty',
        ];
      case '5': // Sports
        return [
          'Nike',
          'Adidas',
          'Under Armour',
          'Puma',
          'Reebok',
          'New Balance',
        ];
      default:
        return ['Brand A', 'Brand B', 'Brand C', 'Brand D', 'Brand E'];
    }
  }
}
