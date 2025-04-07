import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter/services.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart' as carousel;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../core/constants/color_constants.dart';
import '../core/constants/dimension_constants.dart';

class BannerSlider extends StatefulWidget {
  final List<String> bannerUrls;
  final double height;
  final Function(int)? onBannerTap;

  const BannerSlider({
    Key? key,
    required this.bannerUrls,
    this.height = DimensionConstants.bannerHeight,
    this.onBannerTap,
  }) : super(key: key);

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int _currentIndex = 0;
  final carousel.CarouselSliderController _carouselController =
      carousel.CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        carousel.CarouselSlider.builder(
          controller: _carouselController,
          itemCount: widget.bannerUrls.length,
          itemBuilder: (context, index, realIndex) {
            return GestureDetector(
              onTap: () {
                if (widget.onBannerTap != null) {
                  HapticFeedback.lightImpact();
                  widget.onBannerTap!(index);
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: DimensionConstants.marginS,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    DimensionConstants.radiusM,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    DimensionConstants.radiusM,
                  ),
                  child: Image.network(
                    widget.bannerUrls[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: widget.height,
                        color:
                            isDarkMode
                                ? ColorConstants.cardDark
                                : ColorConstants.shimmerBaseLight,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: widget.height,
                        color:
                            isDarkMode
                                ? ColorConstants.cardDark
                                : Colors.grey.shade200,
                        child: const Icon(
                          Icons.error_outline,
                          color: Colors.grey,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          options: carousel.CarouselOptions(
            height: widget.height,
            viewportFraction: 0.9,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.15,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: DimensionConstants.marginM),
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: widget.bannerUrls.length,
          effect: ExpandingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: ColorConstants.primary,
            dotColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
          ),
        ),
      ],
    );
  }
}
