// Color palette tokens used across the app.
import 'package:flutter/painting.dart';

abstract final class AppColors {
  // ---------------------------------------------------------------------------
  // Section A: Palette (raw brand colors). Source of truth for every hex value.
  // ---------------------------------------------------------------------------

  // Cards, sheets, text and icons on navy or gradient backgrounds.
  static const Color white = Color(0xFFFFFFFF);

  // Brand navy: headers, primary buttons, active chips, headings and names.
  static const Color navyPrimary = Color(0xFF0A192F);

  // Brand red: prices, "Sell an Item" FAB, notification dots, pinned labels.
  static const Color redPrimary = Color(0xFFC8102E);

  // Brand green: "Hub Live", verified badges, online dots, "Like New" tags.
  static const Color greenPrimary = Color(0xFF10B981);

  // Top stop of the splash and login background gradient.
  static const Color navyIndigo = Color(0xFF152B67);

  // Navy at 20%: search field, filter chips and inputs sitting on light or hero areas.
  static const Color navyTint = Color(0x330A192F);

  // White at 60%: glossy highlight at the top of the primary button.
  static const Color glassHighlight = Color(0x99FFFFFF);

  // White at 40%: outline of glossy buttons on dark backgrounds.
  static const Color glassBorder = Color(0x66FFFFFF);

  // White at 80%: primary button label.
  static const Color whiteSoft = Color(0xCCFFFFFF);

  // Navy at 60%: lower half of the primary button sheen.
  static const Color navyGlass = Color(0x990A192F);

  // Lightest lavender grey: sell screen body, bottom nav, checkbox fill.
  static const Color grey50 = Color(0xFFFAF8FF);

  // Muted lavender surface: callouts, tip cards, category circles, photo slots.
  static const Color grey100 = Color(0xFFF2F3FF);

  // Chips, tags, segmented controls, progress tracks and hairline borders.
  static const Color grey200 = Color(0xFFEAEDFF);

  // Cohort chips, "Student ID" button, clubs icon circle.
  static const Color grey300 = Color(0xFFE2E7FF);

  // Location badges on listing photos ("Hostel Block B", "CS Core").
  static const Color grey400 = Color(0xFFDAE2FD);

  // Secondary text on navy cards (selected condition description).
  static const Color grey500 = Color(0xFFB9C7E4);

  // Muted text: timestamps, handles, helper text, placeholders, counters.
  static const Color grey600 = Color(0xFF64748B);

  // Secondary text: chip labels, form labels, engagement counts, comments.
  static const Color grey700 = Color(0xFF334155);

  // Light red circle behind the lock icon, "Join Club" pill, leader tag.
  static const Color redSurface = Color(0xFFFEF2F2);

  // Light green behind verified badges, "Mandatory Read", condition tags.
  static const Color greenSurface = Color(0xFFECFDF5);

  // Lavender circle behind club and community icons.
  static const Color blueSurface = grey300;

  // Orange at 20%: tip icon circle and drafts count pill.
  static const Color orangeSurface = Color(0x33F4A261);

  // Trending topics, "ANNUAL SHOWCASE" label, selected condition check, link underline.
  static const Color orangeAccent = Color(0xFFF4A261);

  // Text on orange surfaces (drafts count).
  static const Color orangeDeep = Color(0xFFBB7336);

  // ---------------------------------------------------------------------------
  // Section B: Semantic aliases. Screens use these, never the palette directly.
  // ---------------------------------------------------------------------------

  // Scaffold background behind cards.
  static const Color background = grey50;

  // Cards, inputs, bottom sheets.
  static const Color surface = white;

  // Callouts, tip cards, icon circles, inactive photo slots.
  static const Color surfaceMuted = grey100;

  // Headings, names, titles and body copy.
  static const Color textPrimary = navyPrimary;

  // Chip labels, form labels, comments, engagement counts.
  static const Color textSecondary = grey700;

  // Timestamps, handles, helper text, placeholders.
  static const Color textMuted = grey600;

  // Text on navy headers, primary buttons and the onboarding gradient.
  static const Color textOnDark = white;

  // Secondary text on navy cards.
  static const Color textOnDarkMuted = grey500;

  // Slightly dimmed text on navy buttons ("GET STARTED").
  static const Color textOnDarkSoft = whiteSoft;

  // Input and card outlines.
  static const Color border = grey200;

  // Hairline separators between rows and sections.
  static const Color divider = grey200;

  // Primary buttons, headers, active chips and tabs.
  static const Color primary = navyPrimary;

  // Brand highlight: prices, FAB, badges, pinned labels.
  static const Color accent = redPrimary;

  // Verified, live and positive states.
  static const Color success = greenPrimary;

  // Validation errors and destructive actions.
  static const Color error = redPrimary;

  // Warnings and attention states.
  static const Color warning = orangeAccent;

  // Default icon color on light surfaces.
  static const Color iconDefault = navyPrimary;

  // Inactive nav icons and secondary icons.
  static const Color iconMuted = grey600;

  // Splash, login and "why institutional login" background, navy at top to crimson at bottom.
  static const LinearGradient onboardingGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [navyIndigo, redPrimary],
  );

  // Glossy sheen painted over the navy fill of the primary button.
  static const LinearGradient primaryButtonSheen = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [glassHighlight, navyGlass],
    stops: [0, 0.40385],
  );

  // Thin accent strip on top of pinned announcement cards.
  static const LinearGradient announcementStripGradient = LinearGradient(
    colors: [navyPrimary, orangeAccent, redPrimary],
  );
}
