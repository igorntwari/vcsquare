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

  // White at 61%: fine print on the onboarding gradient.
  static const Color whiteFaint = Color(0x9CFFFFFF);

  // White at 10%: date box on the event flyer.
  static const Color glassSubtle = Color(0x1AFFFFFF);

  // Navy at 80%: location pill over post photos.
  static const Color navyScrim = Color(0xCC0A192F);

  // Red at 15%: softer flare on the marketplace trust banner.
  static const Color redFlareSoft = Color(0x26C8102E);

  // Red at 30%: blurred flare in the corner of the event flyer.
  static const Color redFlare = Color(0x4DC8102E);

  // White at 20%: translucent pill fields on navy (composer prompt).
  static const Color glassFill = Color(0x33FFFFFF);

  // Lavender white at 50%: frosted bottom navigation bar.
  static const Color frostedLavender = Color(0x80FAF8FF);

  // Navy at 5%: shadow cast upward by the bottom navigation bar.
  static const Color navyShadowSoft = Color(0x0D0A192F);

  // Red at 35%: glow under the active nav circle and red floating buttons.
  static const Color redGlow = Color(0x59C8102E);

  // Black at 60%: round delete button over photos, bottom of photo scrims.
  static const Color blackScrim = Color(0x99000000);

  // Black at 20%: top of photo scrims.
  static const Color blackScrimLight = Color(0x33000000);

  // Fully transparent black: middle of photo scrims.
  static const Color blackTransparent = Color(0x00000000);

  // Fully transparent white: start of white fades.
  static const Color whiteTransparent = Color(0x00FFFFFF);

  // Navy at 16%: option cards and notes on the sell form.
  static const Color navyTintSoft = Color(0x290A192F);

  // Navy at 60%: secondary text on navy-tinted fields.
  static const Color navyMuted = Color(0x990A192F);

  // Lavender white at 95%: frosted header and bottom bar on the sell form.
  static const Color frostedStrong = Color(0xF2FAF8FF);

  // Black at 5%: soft card shadows.
  static const Color blackShadow = Color(0x0D000000);

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

  // Fine print on the onboarding gradient (terms, footer).
  static const Color textOnDarkFaint = whiteFaint;

  // Card drop shadows.
  static const Color shadow = blackShadow;

  // Frosted background of the bottom navigation bar.
  static const Color navBarBackground = frostedLavender;

  // Navy header behind the top bar on main tabs.
  static const Color topBarBackground = navyPrimary;

  // Search field sitting on the navy header.
  static const Color searchFieldOnDark = navyTint;

  // Composer prompt pill on the navy header.
  static const Color composerFieldOnDark = glassFill;

  // Small round action button inside the search field.
  static const Color searchActionBackground = grey50;

  // Unselected filter chip.
  static const Color chipBackground = grey200;

  // Selected filter chip.
  static const Color chipSelectedBackground = navyPrimary;

  // Online status dot.
  static const Color online = greenPrimary;

  // Liked thumb and count.
  static const Color likeActive = redPrimary;

  // Location pill over post photos.
  static const Color imageCaptionBackground = navyScrim;

  // Empty photo slot while an image is missing.
  static const Color imagePlaceholder = grey200;

  // Event flyer background.
  static const Color eventBannerBackground = navyPrimary;

  // Kicker label and month on the event flyer.
  static const Color eventHighlight = orangeAccent;

  // Date box on the event flyer.
  static const Color eventDateBackground = glassSubtle;

  // Orange flare in the top-right corner of the event flyer.
  static const Color eventFlareWarm = orangeSurface;

  // Red flare in the bottom-left corner of the event flyer.
  static const Color eventFlareCool = redFlare;

  // "Free Entry" badge.
  static const Color freeEntryBackground = redPrimary;

  // Ticket price badge.
  static const Color priceTagBackground = orangeAccent;

  // Listing prices.
  static const Color price = redPrimary;

  // Round favourite button over listing photos.
  static const Color favoriteButtonBackground = whiteSoft;

  // Location pill in the marketplace quick filters.
  static const Color locationPillBackground = navyTint;

  // Dark tag over listing photos ("Kigali Pickup").
  static const Color listingTagDark = navyScrim;

  // Light tag over listing photos ("Hostel Block B").
  static const Color listingTagLight = grey400;

  // Blurred flare on the marketplace trust banner.
  static const Color trustBannerFlare = redFlareSoft;

  // Icon circle on navy banners.
  static const Color iconCircleOnDark = glassSubtle;

  // Warm section kicker ("CAMPUS HUBS") and warm trending tags.
  static const Color kickerWarm = orangeAccent;

  // Chat bubble the current user sent.
  static const Color bubbleMine = navyPrimary;

  // Chat bubble someone else sent.
  static const Color bubbleTheirs = white;

  // Search field sitting on a light background.
  static const Color searchFieldOnLight = grey100;

  // Text field fill in the chat input bar.
  static const Color inputFill = grey100;

  // Read receipt ticks.
  static const Color readReceipt = greenPrimary;

  // Translucent round button over the profile cover.
  static const Color coverButtonBackground = navyGlass;

  // White fade at the bottom of the profile cover.
  static const LinearGradient coverFade = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [whiteTransparent, white],
    stops: [0.15, 1],
  );

  // Navy-to-crimson cover banner on the profile.
  static const LinearGradient profileCoverGradient = LinearGradient(
    colors: [navyPrimary, navyIndigo, redPrimary],
  );

  // Option cards and fields on the sell form (navy at 16%).
  static const Color formOptionBackground = navyTintSoft;

  // Secondary text on light navy-tinted fields (navy at 60%).
  static const Color textOnTint = navyMuted;

  // Selected option ring on the sell form.
  static const Color selectionRing = orangeSurface;

  // Frosted header and bottom bar on the sell form.
  static const Color frostedSurface = frostedStrong;

  // Round delete button over uploaded photos.
  static const Color photoActionBackground = blackScrim;

  // Darkens the top and bottom of the cover photo so overlays stay readable.
  static const LinearGradient photoScrim = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [blackScrimLight, blackTransparent, blackScrim],
  );

  // Underline under links on dark backgrounds.
  static const Color linkUnderlineOnDark = glassBorder;


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
