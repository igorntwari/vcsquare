// Static UI copy and labels.
abstract final class AppStrings {
  // Splash
  static const String splashTitle = 'Welcome to Virtual Campus Community';
  static const String splashSubtitle =
      'A closed, trusted network exclusively for African Leadership '
      'University students, faculty, and accredited campus staff.';
  static const String getStarted = 'GET STARTED';

  // Login
  static const String continueWithGoogle = 'CONTINUE WITH GOOGLE';
  static const String whyInstitutionalLogin = 'WHY INSTITUTIONAL LOGIN?';
  static const String activePeersOnline = '1,400+ active peers online';
  static const String hubLive = 'Hub Live';
  static const String termsPrefix = 'By continuing, you agree to the ';
  static const String campusHonorCode = 'Campus Honor Code';
  static const String acceptableUsePolicy = 'Acceptable Use Policy';
  static const String privacyPolicy = 'Privacy Policy';
  static const String universityName = 'African Leadership University';
  static const String studentLifeDivision = 'Student Life Division';
  static const String bulletSeparator = '•';

  // Why institutional login
  static const String whyInstitutionalLoginTitle = 'Why institutional login?';
  static const String campusProtection = 'Campus Protection';
  static const String verifiedCommunityTitle = '100% Verified Community';
  static const String verifiedCommunityBody =
      'Eliminates spammers and outside bots. Every profile corresponds '
      'directly to an enrolled peer, facilitator, or staff member.';
  static const String safeMarketplaceTitle = 'Safe Peer-to-Peer Marketplace';
  static const String safeMarketplaceBody =
      'Buy, trade, and sell tech, textbooks, and campus gear with full '
      'accountability and on-campus handover points.';
  static const String officialClubsTitle = 'Official Clubs & Mission Circles';
  static const String officialClubsBody =
      'Access protected club rooms, study groups, campus transport threads, '
      'and official student government voting channels.';
  static const String goBack = 'Go back';

  // Top bar
  static const String virtualCommunity = 'VIRTUAL COMMUNITY';
  static const String notifications = 'Notifications';
  static const String profile = 'Profile';

  // Home header
  static const String searchHint = 'Search campus pulses, clubs, classmates...';
  static const String searchFilter = 'Filter';
  static const String composerHint = 'Share an update, idea or question...';
  static const String attachMedia = 'Attach media';
  static const String createPoll = 'Create poll';

  // Home feed filters
  static const String filterAllCampus = 'All Campus';
  static const String filterMyFeed = 'My Feed';
  static const String filterOfficialAnnouncements = 'Official Announcements';
  static const String filterStudentLife = 'Student Life';
  static const String filterTechInnovation = 'Tech & Innovation';

  // Feed posts
  static const String pinnedAnnouncement = 'PINNED ANNOUNCEMENT';
  static const String verified = 'Verified';
  static const String clubHub = 'Club Hub';
  static const String joinClub = 'Join Club';
  static const String joined = 'Joined';
  static const String mandatoryRead = 'Mandatory Read';
  static const String freeEntry = 'Free Entry';
  static const String rsvpNow = 'RSVP Now';
  static const String addToCalendar = 'Add to Calendar';
  static const String like = 'Like';
  static const String comment = 'Comment';
  static const String share = 'Share';
  static const String save = 'Save';
  static const String moreOptions = 'More options';
  static const String timezone = 'CAT';

  // Market
  static const String marketSearchHint =
      'Search textbooks, tech, furniture...';
  static const String marketLocation = 'Kigali Innovation City';
  static const String verifiedStudentSellers = 'Verified Student Sellers';
  static const String underBudget = 'Under RWF 50,000';
  static const String browseCategories = 'BROWSE CATEGORIES';
  static String categoriesCount(int count) => '$count Categories';
  static const String peerTradeGuardTitle = 'ALU Peer Trade Guard';
  static const String peerTradeGuardBody =
      'Every seller is an authenticated ALU student or staff member.';
  static const String recentListings = 'Recent Campus Listings';
  static const String recentListingsSubtitle =
      'Updated 4 mins ago across Kigali campus';
  static const String sortLatest = 'Latest';
  static const String sortPriceLowHigh = 'Price: Low-High';
  static const String sortDistance = 'Distance';
  static const String favorite = 'Save item';
  static const String exchangeTipTitle = 'Meeting for Exchanges?';
  static const String exchangeTipBody =
      'Use the Innovation Hub Atrium or ALU Library Foyer for safe peer '
      'handoffs during daylight hours.';
  static const String sellAnItem = 'Sell an Item';
  static const String noListingsTitle = 'No listings match';
  static const String noListingsMessage =
      'Try another category or clear your filters.';

  // Explore
  static const String exploreSearchHint =
      'Search posts, listings, students, clubs...';
  static const String filterAll = 'All';
  static const String filterPosts = 'Posts';
  static const String filterListings = 'Listings';
  static const String filterPeople = 'People';
  static const String filterCommunities = 'Communities';
  static const String trendingTitle = 'Trending on ALU Campus';
  static const String livePulse = 'Live Pulse';
  static const String verifiedInstitutional = 'VERIFIED INSTITUTIONAL';
  static const String officialHandles = 'Official School Handles';
  static const String seeDirectory = 'See directory';
  static const String campusHubs = 'CAMPUS HUBS';
  static const String discoverCommunities = 'Discover Communities';
  static const String exploreAll = 'Explore all';
  static const String peerNetwork = 'PEER NETWORK';
  static const String peopleYouMayKnow = 'People You May Know';
  static const String syncContacts = 'Sync Contacts';
  static const String follow = 'Follow';
  static const String following = 'Following';
  static const String join = 'Join';
  static const String connect = 'Connect';
  static const String requestSent = 'Request sent';
  static String activeMembers(int count) => '$count active members';
  static String mutualPeers(int count, String interest) =>
      '$count mutual peers $bulletSeparator $interest';

  // Messages
  static const String messagesSearchHint =
      'Search chats, items, or classmates...';
  static const String newMessage = 'New message';
  static const String newChat = 'New Chat';
  static const String filterAllChats = 'All Chats';
  static const String filterMarketplace = 'Marketplace';
  static const String filterOfficial = 'Official';
  static const String filterUnread = 'Unread';
  static const String official = 'Official';
  static const String handover = 'Handover';
  static const String pickupPrefix = 'Pickup:';
  static const String you = 'You:';
  static const String online = 'Online';
  static const String messageHint = 'Write a message...';
  static const String send = 'Send';
  static const String attach = 'Attach';
  static const String back = 'Back';
  static const String viewListing = 'View';
  static const String noChatsTitle = 'No chats here yet';
  static const String noChatsMessage =
      'Start a conversation with a classmate or seller.';
  static String unreadMessages(int count) => '$count unread';

  // Profile
  static const String accountSettings = 'Account settings';
  static const String studentId = 'Student ID';
  static const String edit = 'Edit';
  static const String statPosts = 'Posts';
  static const String statListings = 'Listings';
  static const String statFollowers = 'Followers';
  static const String statFollowing = 'Following';
  static const String tabMyPosts = 'My Posts';
  static String tabListings(int count) => 'Listings ($count)';
  static const String tabSaved = 'Saved Items';
  static const String accountVerification = 'ACCOUNT & CAMPUS VERIFICATION';
  static const String studentIdCardTitle = 'Digital Student ID Card';
  static const String studentIdCardSubtitle =
      'Verified for Academic Year 2026–2027';
  static const String securitySettingsTitle = 'Account & Security Settings';
  static const String securitySettingsSubtitle =
      '2FA, email alerts, payment payout methods';
  static const String campusAccessTitle = 'Kigali Innovation City Access';
  static const String campusAccessSubtitle =
      'Smart lock badge • ALU Hub access enabled';
  static const String noPostsTitle = 'No posts yet';
  static const String noPostsMessage = 'Share an update from the Home tab.';
  static const String noSavedTitle = 'Nothing saved yet';
  static const String noSavedMessage =
      'Tap the heart on a listing to keep it here.';

  // Sell an item
  static const String close = 'Close';
  static const String sellSubtitle = 'Pan-African Campus Exchange';
  static const String drafts = 'Drafts';
  static const String draftSaved = 'Draft saved';
  static const String stepOneOfTwo = 'Step 1 of 2';
  static const String photosAndDetails = 'Photos & Item Details';
  static String percentComplete(int percent) => '$percent% complete';
  static const String visualProof = 'Visual Proof';
  static const String visualProofHint =
      '1 to 6 photos. Drag to set cover hero shot.';
  static String photosAdded(int count, int max) => '$count of $max added';
  static const String coverPhoto = 'COVER PHOTO';
  static const String holdToReorder = 'Hold to reorder';
  static const String deletePhoto = 'Delete photo';
  static const String addAngle = 'Add Angle';
  static const String receiptBox = 'Receipt/Box';
  static const String extraPhoto = 'Extra Photo';
  static const String proTipLead = 'Pro tip:';
  static const String proTipBody =
      ' Items with 3+ clear campus photos sell ';
  static const String proTipHighlight = '2x faster';
  static const String proTipEnd = ' during term start.';
  static const String itemSpecifics = 'Item Specifics';
  static const String itemSpecificsHint =
      'Be clear and searchable for peer students.';
  static const String listingTitle = 'Listing Title';
  static const String listingTitleHint = 'e.g. Sony WH-1000XM4 Headphones';
  static const String category = 'Category';
  static const String condition = 'Condition';
  static const String conditionNewHint = 'Unopened with seals';
  static const String conditionLikeNewHint = 'Mint condition, rarely used';
  static const String conditionUsedHint = 'Good working, minor wear';
  static const String conditionForPartsHint = 'Non-functional / DIY';
  static const String askingPrice = 'Asking Price';
  static const String currencyRwf = 'RWF';
  static const String openToNegotiation = 'Open to negotiation';
  static const String openToNegotiationHint =
      'Allows buyers to offer counter-prices';
  static const String campusPickupHub = 'Campus Pickup Hub';
  static const String campusPickupHubHint = 'Designated safe exchange zones';
  static const String pickupTrustNote =
      'Peer-to-peer campus exchanges require no digital payment in-app. '
      'Inspect items thoroughly before cash or MoMo exchange.';
  static const String descriptionTitle = 'Description & Highlights';
  static const String descriptionHint =
      'What makes it great? Mention accessories, battery life, and where '
      'to pick it up.';
  static const String quickAdd = 'Quick add:';
  static const String quickAddOriginalBox = 'Original box';
  static const String quickAddWarranty = 'Under warranty';
  static const String quickAddMovingOut = 'Moving out sale';
  static const String saveDraft = 'Save Draft';
  static const String previewListing = 'Preview Listing';
  static const String completeToPreview =
      'Add a title, category, condition and price to preview.';
  static String characterCount(int used, int max) => '$used/$max';

  // Listing conditions
  static const String conditionNew = 'New';
  static const String conditionLikeNew = 'Like New';
  static const String conditionGood = 'Good Cond.';
  static const String conditionUsed = 'Used';
  static const String conditionForParts = 'For Parts';

  // Bottom nav
  static const String navHome = 'Home';
  static const String navMarket = 'Market';
  static const String navExplore = 'Explore';
  static const String navMessages = 'Messages';
  static const String navProfile = 'Profile';
}
