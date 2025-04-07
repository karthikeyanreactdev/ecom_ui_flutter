import 'package:flutter/material.dart';
import '../core/constants/dimension_constants.dart';
import '../core/constants/color_constants.dart';
import '../core/constants/animation_constants.dart';

class BottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int? badgeCount;

  BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.badgeCount,
  });
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  final List<BottomNavItem> items;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: DimensionConstants.bottomNavBarHeight,
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          items.length,
          (index) => _buildNavItem(
            index: index,
            item: items[index],
            isActive: currentIndex == index,
            colorScheme: colorScheme,
            theme: theme,
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required BottomNavItem item,
    required bool isActive,
    required ColorScheme colorScheme,
    required ThemeData theme,
  }) {
    final iconColor =
        isActive ? colorScheme.primary : theme.bottomNavigationBarTheme.unselectedItemColor;
    final textColor =
        isActive ? colorScheme.primary : theme.bottomNavigationBarTheme.unselectedItemColor;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Icon with animation
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: 1.0,
                    end: isActive ? 1.2 : 1.0,
                  ),
                  curve: Curves.easeInOut,
                  duration: const Duration(
                      milliseconds: AnimationConstants.fastDuration),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Icon(
                        isActive ? item.activeIcon : item.icon,
                        color: iconColor,
                        size: 24,
                      ),
                    );
                  },
                ),
                // Badge indicator if needed
                if (item.badgeCount != null && item.badgeCount! > 0)
                  Positioned(
                    top: -5,
                    right: -10,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        item.badgeCount! > 9 ? '9+' : '${item.badgeCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            // Label with fade animation
            AnimatedOpacity(
              opacity: isActive ? 1.0 : 0.7,
              duration: const Duration(
                  milliseconds: AnimationConstants.fastDuration),
              child: Text(
                item.label,
                style: theme.bottomNavigationBarTheme.selectedLabelStyle?.copyWith(
                  color: textColor,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
