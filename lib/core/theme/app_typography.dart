// Text style tokens used across the app.
import 'package:flutter/painting.dart';

// Styles carry no color. Apply one with copyWith(color: AppColors.x) or let the
// theme supply it, so the same style works on light and dark backgrounds.
abstract final class AppTypography {
  static const String headingFamily = 'PlusJakartaSans';
  static const String bodyFamily = 'DMSans';

  // Onboarding welcome title, event banner headline.
  static const TextStyle displayLarge = TextStyle(
    fontFamily: headingFamily,
    fontSize: 34,
    fontWeight: FontWeight.w800,
    height: 36 / 28,
    letterSpacing: -0.7,
  );
  

  // Profile name.
  static const TextStyle headingLarge = TextStyle(
    fontFamily: headingFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    letterSpacing: -0.6,
  );

  // Screen titles, section headings, post author names.
  static const TextStyle headingMedium = TextStyle(
    fontFamily: headingFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
    letterSpacing: -0.09,
  );

  // Listing titles, settings tile titles, banner titles.
  static const TextStyle titleLarge = TextStyle(
    fontFamily: headingFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 20 / 14,
    letterSpacing: 0.14,
  );

  // Benefit card titles, pickup hub options.
  static const TextStyle titleMedium = TextStyle(
    fontFamily: headingFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 0.14,
  );

  // Post bodies, descriptions, onboarding intro copy.
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 22.75 / 14,
  );

  // Card descriptions, comments, search placeholder.
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 18 / 13,
  );

  // Handles, timestamps, subtitles, nav labels.
  static const TextStyle bodySmall = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: 0.12,
  );

  // Small regular-weight labels ("CONTINUE WITH GOOGLE", text links).
  static const TextStyle bodySmallRegular = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
  );

  // Tiny meta text in badges and listing footers.
  static const TextStyle caption = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 16 / 10,
  );

  // Form labels and filter chip labels.
  static const TextStyle label = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.24,
  );

  // Status tags and small pills ("Like New", "Free Entry", sort pills).
  static const TextStyle chip = TextStyle(
    fontFamily: bodyFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 14 / 11,
    letterSpacing: 0.44,
  );

  // Uppercase section labels ("PINNED ANNOUNCEMENT", "BROWSE CATEGORIES").
  static const TextStyle overline = TextStyle(
    fontFamily: headingFamily,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    height: 14 / 11,
    letterSpacing: 0.55,
  );

  // Full-width and pill buttons.
  static const TextStyle button = TextStyle(
    fontFamily: headingFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 20 / 14,
    letterSpacing: 0.14,
  );

  // Compact inline buttons ("RSVP Now", "Join Club").
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: headingFamily,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    height: 14 / 11,
    letterSpacing: 0.44,
  );

  // Listing card prices.
  static const TextStyle price = TextStyle(
    fontFamily: headingFamily,
    fontSize: 18,
    fontWeight: FontWeight.w800,
    height: 24 / 18,
    letterSpacing: -0.09,
  );

  // Asking price input on the sell screen.
  static const TextStyle priceLarge = TextStyle(
    fontFamily: headingFamily,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    height: 36 / 28,
    letterSpacing: -0.56,
  );
}
