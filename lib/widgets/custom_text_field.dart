import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/dimension_constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onEditingComplete;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final Color? fillColor;
  final Color? borderColor;
  final Color? hintColor;
  final Color? textColor;
  final double? borderRadius;
  final TextCapitalization textCapitalization;
  final bool readOnly;
  final String? errorText;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.focusNode,
    this.textInputAction,
    this.padding,
    this.height,
    this.fillColor,
    this.borderColor,
    this.hintColor,
    this.textColor,
    this.borderRadius,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors based on theme and custom values
    final Color textFieldFillColor =
        fillColor ?? theme.inputDecorationTheme.fillColor!;
    final Color textFieldTextColor =
        textColor ?? theme.textTheme.bodyLarge!.color!;
    final Color textFieldHintColor = hintColor ?? theme.hintColor;
    final Color textFieldBorderColor =
        borderColor ??
        theme.inputDecorationTheme.enabledBorder!.borderSide.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label above text field
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: DimensionConstants.marginS),
        ],

        // Text field
        SizedBox(
          height: height,
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            validator: validator,
            maxLines: maxLines,
            minLines: minLines,
            enabled: enabled,
            onTap: onTap,
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted,
            onEditingComplete: onEditingComplete,
            focusNode: focusNode,
            textInputAction: textInputAction,
            textCapitalization: textCapitalization,
            readOnly: readOnly,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textFieldTextColor,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: textFieldHintColor.withOpacity(0.5),
                fontSize: DimensionConstants.textM,
              ),
              filled: true,
              fillColor: textFieldFillColor,
              prefixIcon:
                  prefixIcon != null
                      ? Icon(
                        prefixIcon,
                        color: colorScheme.primary,
                        size: DimensionConstants.iconM,
                      )
                      : null,
              suffixIcon: suffixIcon,
              contentPadding:
                  padding ?? const EdgeInsets.all(DimensionConstants.paddingL),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius ?? DimensionConstants.radiusM,
                ),
                borderSide: BorderSide(color: textFieldBorderColor, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius ?? DimensionConstants.radiusM,
                ),
                borderSide: BorderSide(color: textFieldBorderColor, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius ?? DimensionConstants.radiusM,
                ),
                borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius ?? DimensionConstants.radiusM,
                ),
                borderSide: BorderSide(
                  color: theme.colorScheme.error,
                  width: 1.0,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius ?? DimensionConstants.radiusM,
                ),
                borderSide: BorderSide(
                  color: theme.colorScheme.error,
                  width: 1.5,
                ),
              ),
              errorStyle: TextStyle(
                color: theme.colorScheme.error,
                fontSize: DimensionConstants.textS,
              ),
              errorText: errorText,
            ),
          ),
        ),
      ],
    );
  }
}
