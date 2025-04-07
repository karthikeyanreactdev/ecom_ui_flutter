import 'package:flutter/material.dart';
import '../core/constants/animation_constants.dart';
import '../core/constants/dimension_constants.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final bool isOutlined;
  final bool isFullWidth;
  final IconData? icon;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final double? elevation;
  final Color? borderColor;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.isOutlined = false,
    this.isFullWidth = false,
    this.icon,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.elevation,
    this.borderColor,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: AnimationConstants.buttonScaleDuration,
      ),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    _animationController.forward();
  }

  void _onTapUp(_) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors based on button state and type
    final Color bgColor =
        widget.backgroundColor ??
        (widget.isOutlined
            ? Colors.transparent
            : widget.isDisabled
            ? colorScheme.primary.withOpacity(0.4)
            : colorScheme.primary);

    final Color txtColor =
        widget.textColor ??
        (widget.isOutlined
            ? colorScheme.primary
            : widget.isDisabled
            ? colorScheme.onPrimary.withOpacity(0.7)
            : colorScheme.onPrimary);

    // Button content
    Widget buttonContent;
    if (widget.isLoading) {
      // Show loading indicator
      buttonContent = SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(txtColor),
        ),
      );
    } else {
      // Show text and optional icon
      if (widget.icon != null) {
        buttonContent = Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: theme.textTheme.labelLarge?.copyWith(
                color: txtColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: DimensionConstants.marginS),
            Icon(widget.icon, size: 18, color: txtColor),
          ],
        );
      } else {
        buttonContent = Text(
          widget.text,
          style: theme.textTheme.labelLarge?.copyWith(
            color: txtColor,
            fontWeight: FontWeight.w600,
          ),
        );
      }
    }

    // Determine button size
    final double btnHeight = widget.height ?? DimensionConstants.buttonHeight;
    double? btnWidth;
    if (widget.isFullWidth) {
      btnWidth = double.infinity;
    } else if (widget.width != null) {
      btnWidth = widget.width;
    }

    // Apply button style
    final borderRadius = widget.borderRadius ?? DimensionConstants.radiusM;
    final elevation = widget.elevation ?? (widget.isOutlined ? 0 : 1);

    // Create button with animation
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isDisabled ? 1.0 : _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: widget.isDisabled ? null : _onTapDown,
        onTapUp: widget.isDisabled ? null : _onTapUp,
        onTapCancel: widget.isDisabled ? null : _onTapCancel,
        child: InkWell(
          onTap:
              widget.isDisabled || widget.isLoading ? null : widget.onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor:
              widget.isOutlined
                  ? colorScheme.primary.withOpacity(0.1)
                  : colorScheme.onPrimary.withOpacity(0.1),
          child: Ink(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border:
                  widget.isOutlined
                      ? Border.all(
                        color:
                            widget.isDisabled
                                ? colorScheme.primary.withOpacity(0.4)
                                : widget.borderColor ?? colorScheme.primary,
                        width: 1.5,
                      )
                      : null,
              boxShadow:
                  elevation > 0
                      ? [
                        BoxShadow(
                          color: colorScheme.shadow.withOpacity(0.1),
                          blurRadius: elevation * 2,
                          offset: Offset(0, elevation),
                        ),
                      ]
                      : null,
            ),
            width: btnWidth,
            height: btnHeight,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DimensionConstants.paddingL,
                ),
                child: buttonContent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
