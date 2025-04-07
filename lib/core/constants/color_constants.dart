import 'package:flutter/material.dart';

abstract class ColorConstants {
  // Primary colors
  static const primary = Color(0xFF4A55A2);
  static const primaryLight = Color(0xFF7895CB);
  static const primaryDark = Color(0xFF3B4480);
  
  // Accent colors
  static const accent = Color(0xFFF99417);
  static const accentLight = Color(0xFFFFC26F);
  static const accentDark = Color(0xFFE17B15);
  
  // Background colors
  static const backgroundLight = Color(0xFFF8FAFC);
  static const backgroundDark = Color(0xFF121418);
  
  // Surface colors
  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF1E1F25);
  static const surfaceVariant = Color(0xFFEEEFF4);
  
  // Card colors
  static const cardLight = Color(0xFFFFFFFF);
  static const cardDark = Color(0xFF1E1F25);
  
  // Text colors
  static const textPrimary = Color(0xFF1A1C1E);
  static const textSecondary = Color(0xFF5F6367);
  static const textTertiary = Color(0xFF9E9E9E);
  static const textOnPrimary = Color(0xFFFFFFFF);
  static const textPrimaryLight = Color(0xFF1A1C1E);
  static const textPrimaryDark = Color(0xFFF8F9FA);
  static const textSecondaryLight = Color(0xFF5F6367);
  static const textSecondaryDark = Color(0xFFABB0B6);
  
  // Utility colors
  static const success = Color(0xFF66BB6A);
  static const successLight = Color(0xFFE8F5E9);
  static const successDark = Color(0xFF2E7D32);
  
  static const error = Color(0xFFEF5350);
  static const errorLight = Color(0xFFFFEBEE);
  static const errorDark = Color(0xFFC62828);
  
  static const warning = Color(0xFFFFCA28);
  static const warningLight = Color(0xFFFFF3E0);
  static const warningDark = Color(0xFFF57C00);
  
  static const info = Color(0xFF42A5F5);
  static const infoLight = Color(0xFFE3F2FD);
  static const infoDark = Color(0xFF1976D2);
  
  // Border and divider colors
  static const divider = Color(0xFFE0E0E0);
  static const border = Color(0xFFBDBDBD);
  static const dividerLight = Color(0xFFE0E0E0);
  static const dividerDark = Color(0xFF2C2D35);
  
  // Overlay colors
  static final overlay30 = Colors.black.withOpacity(0.3);
  static final overlay50 = Colors.black.withOpacity(0.5);
  static final overlay70 = Colors.black.withOpacity(0.7);
  
  // Icon colors
  static const iconActive = primary;
  static const iconInactive = Color(0xFF9E9E9E);
  
  // Skeleton loading colors
  static const shimmerBaseLight = Color(0xFFEBEBF4);
  static const shimmerHighlightLight = Color(0xFFF4F4F4);
  static const shimmerBaseColorDark = Color(0xFF2A2C36);
  static const shimmerHighlightColorDark = Color(0xFF3B3D49);
}