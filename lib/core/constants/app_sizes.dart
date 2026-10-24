// Fixed component sizes such as icon, avatar and button heights.
abstract final class AppSizes {
  // Max width of centered intro copy on onboarding screens.
  static const double onboardingTextMaxWidth = 320;

  // Outline width for buttons and inputs.
  static const double borderThin = 1;

  // Small inline icons (Google logo, checkbox).
  static const double iconSm = 16;

  // Icons inside buttons ("Go back" arrow).
  static const double iconMd = 20;

  // Round icon badge on benefit cards.
  static const double iconCircleMd = 40;

  // Check mark inside the checkbox.
  static const double iconXs = 12;

  // Tiny avatar in the "Hub Live" card.
  static const double avatarXs = 28;

  // Live / online status dot, notification dot.
  static const double statusDot = 8;

  // Bell and other top bar icons.
  static const double iconLg = 24;

  // Minimum tappable area for icon buttons.
  static const double tapTarget = 44;

  // Avatar in the top bar.
  static const double avatarSm = 32;

  // ALU crest in the top bar.
  static const double crest = 30;

  // Height of the top bar content (below the status bar).
  static const double topBarHeight = 64;

  // Height of the bottom nav content (above the home indicator).
  static const double navBarHeight = 64;

  // Red circle behind the active nav icon.
  static const double navActiveCircle = 56;

  // Minimum width of a bottom nav item.
  static const double navItemMinWidth = 56;

  // Height and minimum width of a count badge.
  static const double countBadge = 16;

  // Outline around the online dot.
  static const double borderThick = 2;

  // Avatar in the composer bar.
  static const double avatarMd = 40;

  // Green online dot on avatars.
  static const double onlineBadge = 12;

  // Compact icon buttons (composer attach / poll).
  static const double iconButtonSm = 32;

  // Round action button inside the search field.
  static const double iconButtonXs = 28;

  // Height of the composer bar.
  static const double composerHeight = 56;

  // Height of a filter chip.
  static const double chipHeight = 32;

  // Post author avatar.
  static const double avatarLg = 44;

  // Avatar in the inline comment preview.
  static const double avatarXxs = 24;

  // Height of a post photo.
  static const double postImageHeight = 184;

  // Minimum height of the event flyer.
  static const double eventBannerMinHeight = 170;

  // Minimum width of the date box on the event flyer.
  static const double eventDateMinWidth = 50;

  // Blurred corner flares on the event flyer.
  static const double eventFlare = 128;

  // Gradient strip on top of the pinned announcement.
  static const double accentStrip = 4;

  // Seller avatar on listing cards.
  static const double avatarXxxs = 20;

  // Height of a category tile.
  static const double categoryTileHeight = 86;

  // Icon circle inside a category tile.
  static const double categoryIconCircle = 44;

  // Height of a listing card in the 2-column grid.
  static const double listingCardHeight = 298;

  // Height of the photo on a listing card.
  static const double listingImageHeight = 173;

  // Blurred flare on the trust banner.
  static const double trustBannerFlare = 96;

  // Avatar on handle cards and people suggestions.
  static const double avatarXl = 48;

  // Width of an official handle card in the sideways list.
  static const double handleCardWidth = 220;

  // Height of the sideways official handles list.
  static const double handleCardHeight = 224;

  // Cover image on a community card.
  static const double communityImage = 56;

  // Height of the prominent Follow / Join pill buttons.
  static const double pillButtonHeight = 36;

  // Round connect button on people suggestions.
  static const double connectButton = 36;

  // Small activity dot ("Next meetup").
  static const double activityDot = 6;

  // Thumbnail in the listing chip on chats.
  static const double listingThumb = 40;

  // Unread count bubble on a conversation.
  static const double unreadBadge = 20;

  // Status dot on inbox avatars.
  static const double avatarStatusDot = 14;

  // Widest a chat bubble can grow, as a share of the screen width.
  static const double bubbleMaxWidthFactor = 0.75;

  // Round send button in the chat input bar.
  static const double sendButton = 44;

  // Profile cover banner height.
  static const double profileCoverHeight = 144;

  // Large profile avatar (including its white ring).
  static const double avatarXxl = 96;

  // How far the profile avatar overlaps the cover banner.
  static const double profileAvatarOverlap = 64;

  // Online pulse badge on the profile avatar.
  static const double profileStatusBadge = 20;

  // Height of the Student ID / Edit buttons on the profile.
  static const double profileActionHeight = 40;

  // Square icon box on settings tiles.
  static const double settingsIconBox = 36;

  // Images inside profile post cards.
  static const double profilePostImageHeight = 128;

  // Height of the progress track on the sell form.
  static const double progressTrack = 6;

  // Height of the cover photo slot on the sell form.
  static const double coverPhotoHeight = 176;

  // Height of the condition option cards.
  static const double conditionCardHeight = 80;

  // Height of single-line form inputs.
  static const double inputHeight = 48;

  // Height of the large price input.
  static const double priceInputHeight = 56;

  // Radio circles on option cards.
  static const double radioSize = 20;

  // Height of the sell form's bottom action buttons.
  static const double bottomActionHeight = 48;

  // Max lengths on the sell form.
  static const int listingTitleMaxLength = 80;
  static const int descriptionMaxLength = 1000;
  static const int maxListingPhotos = 6;
  static const int priceMaxDigits = 9;
}
