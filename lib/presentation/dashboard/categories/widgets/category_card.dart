import 'package:flutter/material.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/dimension_constants.dart';
import '../../../../data/models/category_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final bool isSubcategory;
  final VoidCallback onTap;

  const CategoryCard({
    Key? key,
    required this.category,
    this.isSubcategory = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDarkMode
            ? ColorConstants.textPrimaryDark
            : ColorConstants.textPrimaryLight;
    final secondaryTextColor =
        isDarkMode
            ? ColorConstants.textSecondaryDark
            : ColorConstants.textSecondaryLight;
    final cardColor =
        isDarkMode ? ColorConstants.cardDark : ColorConstants.cardLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isSubcategory ? 80 : 120,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(
            isSubcategory
                ? DimensionConstants.radiusS
                : DimensionConstants.radiusM,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Category Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  isSubcategory
                      ? DimensionConstants.radiusS
                      : DimensionConstants.radiusM,
                ),
                bottomLeft: Radius.circular(
                  isSubcategory
                      ? DimensionConstants.radiusS
                      : DimensionConstants.radiusM,
                ),
              ),
              child: Container(
                width: isSubcategory ? 80 : 120,
                height: isSubcategory ? 80 : 120,
                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                child:
                    category.image != null
                        ? Image.network(
                          category.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                color:
                                    isDarkMode
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade400,
                                size: isSubcategory ? 24 : 32,
                              ),
                            );
                          },
                        )
                        : Center(
                          child: Icon(
                            Icons.category,
                            color:
                                isDarkMode
                                    ? Colors.grey.shade600
                                    : Colors.grey.shade400,
                            size: isSubcategory ? 24 : 32,
                          ),
                        ),
              ),
            ),

            // Category Info
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(
                  isSubcategory
                      ? DimensionConstants.paddingM
                      : DimensionConstants.paddingL,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Category Name
                    Text(
                      category.name,
                      style: TextStyle(
                        fontSize:
                            isSubcategory
                                ? DimensionConstants.textM
                                : DimensionConstants.textL,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Description
                    if (category.description != null && !isSubcategory) ...[
                      const SizedBox(height: DimensionConstants.marginS),
                      Text(
                        category.description!,
                        style: TextStyle(
                          fontSize: DimensionConstants.textS,
                          color: secondaryTextColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    // Subcategories count if any
                    if (category.subcategories?.isNotEmpty == true &&
                        !isSubcategory) ...[
                      const SizedBox(height: DimensionConstants.marginS),
                      Text(
                        '${category.subcategories!.length} subcategories',
                        style: TextStyle(
                          fontSize: DimensionConstants.textXS,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Arrow
            Padding(
              padding: const EdgeInsets.all(DimensionConstants.paddingM),
              child: Icon(
                Icons.arrow_forward_ios,
                color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
                size: isSubcategory ? 16 : 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
