import 'package:flutter/material.dart';

/// ألوان التطبيق – تُستخدم في الثيم الفاتح والداكن
class AppColors {
  AppColors._();

  // ─── Primary Palette ─────────────────────────────────────────
  static const Color primary = Color(0xFF6C63FF);       // بنفسجي-أزرق حديث
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color primaryDark = Color(0xFF3D35CC);

  // ─── Secondary Palette ───────────────────────────────────────
  static const Color secondary = Color(0xFF00D4AA);     // أخضر-فيروزي
  static const Color secondaryLight = Color(0xFF5DFFDA);
  static const Color secondaryDark = Color(0xFF009E7C);

  // ─── Neutral ─────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF0D0D0D);
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // ─── Semantic ────────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ─── Light Theme Surfaces ────────────────────────────────────
  static const Color lightBackground = Color(0xFFF8F9FE);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);

  // ─── Dark Theme Surfaces ─────────────────────────────────────
  static const Color darkBackground = Color(0xFF0F0F1A);
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color darkCard = Color(0xFF16213E);
}
