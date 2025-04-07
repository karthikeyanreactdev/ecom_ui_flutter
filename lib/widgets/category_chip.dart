import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/color_constants.dart';
import '../core/constants/dimension_constants.dart';
import '../data/models/category_model.dart';
import '../routes/app_routes.dart';

class CategoryChip extends StatelessWidget {
  final CategoryModel category;

  const CategoryChip({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        isDarkMode ? ColorConstants.cardDark : ColorConstants.cardLight;
    final textColor =
        isDarkMode
            ? ColorConstants.textPrimaryDark
            : ColorConstants.textPrimaryLight;

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.categoryDetail, arguments: category),
      child: Container(
        width: DimensionConstants.categoryImageSize * 1.5,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(DimensionConstants.radiusM),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category image
            Container(
              height: DimensionConstants.categoryImageSize,
              width: DimensionConstants.categoryImageSize,
              margin: const EdgeInsets.only(
                top: DimensionConstants.marginM,
                bottom: DimensionConstants.marginS,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(DimensionConstants.radiusS),
                image:
                    category.image != null
                        ? DecorationImage(
                          image: NetworkImage(category.image!),
                          fit: BoxFit.cover,
                        )
                        : null,
                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
              ),
              child:
                  category.image == null
                      ? Center(
                        child: Icon(
                          Icons.category,
                          color:
                              isDarkMode
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade400,
                          size: DimensionConstants.iconM,
                        ),
                      )
                      : null,
            ),

            // Category name
            Padding(
              padding: const EdgeInsets.only(
                left: DimensionConstants.paddingS,
                right: DimensionConstants.paddingS,
                bottom: DimensionConstants.paddingM,
              ),
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: DimensionConstants.textS,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
