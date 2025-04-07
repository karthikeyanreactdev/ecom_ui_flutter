import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimension_constants.dart';
import '../../data/models/product_model.dart';
import '../../widgets/custom_button.dart';
import 'write_review_controller.dart';

class WriteReviewScreen extends StatelessWidget {
  const WriteReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WriteReviewController>(
      builder: (controller) {
        final ProductModel product = Get.arguments;

        return Scaffold(
          appBar: AppBar(title: const Text('Write a Review')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(DimensionConstants.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Info
                _buildProductInfo(product),

                const SizedBox(height: DimensionConstants.spacingL),

                // Rating
                const Text(
                  'Your Rating',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: DimensionConstants.spacingM),
                Center(
                  child: Obx(
                    () => RatingBar.builder(
                      initialRating: controller.rating.value,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder:
                          (context, _) => const Icon(
                            Icons.star,
                            color: ColorConstants.warning,
                          ),
                      onRatingUpdate: (rating) {
                        controller.rating.value = rating;
                      },
                    ),
                  ),
                ),

                const SizedBox(height: DimensionConstants.spacingL),

                // Review Title
                const Text(
                  'Review Title',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: DimensionConstants.spacingM),
                TextField(
                  controller: controller.titleController,
                  decoration: InputDecoration(
                    hintText: 'Summarize your experience',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        DimensionConstants.radiusM,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: DimensionConstants.paddingM,
                      vertical: 14,
                    ),
                  ),
                  maxLength: 100,
                ),

                const SizedBox(height: DimensionConstants.spacingM),

                // Review Content
                const Text(
                  'Your Review',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: DimensionConstants.spacingM),
                TextField(
                  controller: controller.reviewController,
                  decoration: InputDecoration(
                    hintText: 'Share your thoughts about this product',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        DimensionConstants.radiusM,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(
                      DimensionConstants.paddingM,
                    ),
                  ),
                  maxLines: 5,
                  maxLength: 500,
                ),

                const SizedBox(height: DimensionConstants.spacingL),

                // Photos
                const Text(
                  'Add Photos (Optional)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: DimensionConstants.spacingM),
                Obx(
                  () => SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        // Add photo button
                        InkWell(
                          onTap: controller.pickImage,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: ColorConstants.divider),
                              borderRadius: BorderRadius.circular(
                                DimensionConstants.radiusS,
                              ),
                            ),
                            child: const Icon(
                              Icons.add_a_photo_outlined,
                              color: ColorConstants.textSecondary,
                            ),
                          ),
                        ),
                        // Selected photos
                        ...controller.selectedImages.map(
                          (image) => Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                margin: const EdgeInsets.only(left: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    DimensionConstants.radiusS,
                                  ),
                                  image: DecorationImage(
                                    image: FileImage(image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: InkWell(
                                  onTap: () => controller.removeImage(image),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: DimensionConstants.spacingL),

                // Submit button
                Obx(
                  () => CustomButton(
                    onPressed:
                        controller.isSubmitting.value
                            ? null
                            : () => controller.submitReview(product.id),
                    text:
                        controller.isSubmitting.value
                            ? 'Submitting...'
                            : 'Submit Review',
                    isLoading: controller.isSubmitting.value,
                    isFullWidth: true,
                  ),
                ),

                const SizedBox(height: DimensionConstants.spacingM),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductInfo(ProductModel product) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product image
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DimensionConstants.radiusS),
            image: DecorationImage(
              image: NetworkImage(product.images.first),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: DimensionConstants.spacingM),

        // Product details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                product.brand ?? 'Unknown Brand',
                style: const TextStyle(
                  color: ColorConstants.textSecondary,
                  fontSize: 14,
                ),
              ),
              // if (product.variants.isNotEmpty) ...[
              //   const SizedBox(height: 4),
              //   Text(
              //     'Variant: ${product.variants.first.name}',
              //     style: const TextStyle(
              //       color: ColorConstants.textSecondary,
              //       fontSize: 14,
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ],
    );
  }
}
