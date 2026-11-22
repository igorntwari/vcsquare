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

  // Loading and errors
  static const String loading = 'Loading';
  static const String errorTitle = 'Something went wrong';
  static const String errorMessage =
      'We couldn\'t load this. Check your connection and try again.';
  static const String retry = 'Try again';
  static const String saveFailed = 'Couldn\'t save that. Please try again.';
  static const String signInFailed = 'Couldn\'t sign you in. Please try again.';
  static const String sendFailed = 'Message not sent. Please try again.';

  // Notifications inbox
  static const String markAllRead = 'Mark all read';
  static const String notificationsSubtitle = 'Campus alerts and activity';
  static const String noNotificationsTitle = 'You\'re all caught up';
  static const String noNotificationsMessage =
      'Announcements, messages and activity will show up here.';
  static const String notificationRemoved = 'Notification removed';
  static const String untitledNotification = 'New notification';

  // Home header
  static const String searchHint = 'Search campus pulses, clubs, classmates...';
  static const String noMatchingPostsTitle = 'No posts match';
  static const String noMatchingPostsMessage =
      'Try another search or choose a different feed filter.';
  static const String searchFilter = 'Filter';
  static const String composerHint = 'Share an update, idea or question...';
  static const String attachMedia = 'Attach media';
  static const String createPoll = 'Create poll';
  static const String createPostTitle = 'Create post';
  static const String postAudience = 'Who can see this?';
  static const String audienceCampus = 'All Campus';
  static const String postBodyHint = 'What would you like to share?';
  static const String publishPost = 'Post';
  static const String postBodyRequired = 'Write something before posting.';
  static const String postPublished = 'Your post was shared.';
  static const String pollQuestion = 'Poll question';
  static const String addPollOption = 'Add option';
  static const String pollVoteRecorded =
      'Your vote is recorded. Tap another option to change it.';
  static String pollOption(int number) => 'Option $number';
  static const String removePollOption = 'Remove option';
  static const String addPostPhoto = 'Add photo';
  static const String removePostPhoto = 'Remove photo';
  static const String imageTooLarge = 'Choose an image smaller than 8 MB.';
  static const String postCopied = 'Post text copied to clipboard.';
  static const String commentsTitle = 'Comments';
  static const String commentHint = 'Write a comment...';
  static const String noCommentsMessage = 'Be the first to comment.';

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
  static const String rsvped = 'Going';
  static const String addToCalendar = 'Add to Calendar';
  static const String like = 'Like';
  static const String comment = 'Comment';
  static const String share = 'Share';
  static const String save = 'Save';
  static const String moreOptions = 'More options';
  static const String timezone = 'CAT';

  // Market
  static const String marketSearchHint = 'Search textbooks, tech, furniture...';
  static const String listingDetailsTitle = 'Listing details';
  static const String listingDetailsSection = 'Item details';
  static const String publishListing = 'Publish listing';
  static const String noListingDescription = 'No description provided.';
  static String previewPhotoCount(int count) => '$count photos added';
  static const String messageSeller = 'Message seller';
  static const String myListings = 'My listings';
  static const String markListingSold = 'Mark as sold';
  static const String deleteListing = 'Delete listing';
  static const String listingMarkedSold = 'Listing marked as sold.';
  static const String listingDeleted = 'Listing deleted.';
  static const String listingSold = 'Sold';
  static const String confirmDeleteListing = 'Delete this listing?';
  static const String noDraftsSaved = 'You have no saved drafts yet.';
  static const String draftLoaded = 'Draft loaded.';
  static const String deleteDraft = 'Delete draft';
  static const String draftTitleFallback = 'Untitled draft';
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
  static const String sortPickupHub = 'Pickup hub';
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
  static const String noExploreResultsTitle = 'No matching results';
  static const String noExploreResultsMessage =
      'Try another search or choose a different filter.';
  static const String exploreSearchResults = 'Search results';
  static const String filterAll = 'All';
  static const String filterPosts = 'Posts';
  static const String filterListings = 'Listings';
  static const String filterPeople = 'People';
  static const String filterCommunities = 'Communities';
  static const String trendingTitle = 'Trending on ALU Campus';
  static const String livePulse = 'Live Pulse';
  static const String verifiedInstitutional = 'VERIFIED INSTITUTIONAL';
  static const String officialHandles = 'Official School Handles';
  static const String officialAccountDetailsTitle = 'Official account';
  static const String communityDetailsTitle = 'Community';
  static const String seeDirectory = 'See directory';
  static const String campusHubs = 'CAMPUS HUBS';
  static const String discoverCommunities = 'Discover Communities';
  static const String exploreAll = 'Explore all';
  static const String peerNetwork = 'PEER NETWORK';
  static const String peopleYouMayKnow = 'People You May Know';
  static const String syncContacts = 'Sync Contacts';
  static const String follow = 'Follow';
  static const String onCampus = 'ON CAMPUS';
  static const String studentsOnCampus = 'Students on campus';
  static const String noStudentsYet = 'No other students have joined yet.';
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
  static const String comingSoon = 'Coming soon.';
  static const String edit = 'Edit';
  static const String statPosts = 'Posts';
  static const String statListings = 'Listings';
  static const String statFollowers = 'Followers';
  static const String statFollowing = 'Following';
  static const String tabMyPosts = 'My Posts';
  static const String tabPosts = 'Posts';
  static const String noStudentPostsTitle = 'No posts yet';
  static const String noStudentPostsMessage = 'Nothing shared yet.';
  static const String noStudentListingsTitle = 'No listings yet';
  static const String noStudentListingsMessage = 'Nothing for sale right now.';
  static String tabListings(int count) => 'Listings ($count)';
  static const String tabSaved = 'Saved Items';
  static const String accountVerification = 'ACCOUNT & CAMPUS VERIFICATION';
  static const String studentIdCardTitle = 'Digital Student ID Card';
  static const String studentIdCardSubtitle =
      'Verified for Academic Year 2026–2027';
  static const String securitySettingsTitle = 'Account & Security Settings';
  static const String securitySettingsSubtitle =
      'Edit profile, sign out, delete account';
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
  static const String proTipBody = ' Items with 3+ clear campus photos sell ';
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

  // Sign in and sign up
  static const String signInTitle = 'Sign in to your campus';
  static const String signInSubtitle =
      'Use your ALU email or your ALU Google account.';
  static const String signUpTitle = 'Create your account';
  static const String signUpSubtitle =
      'Only @alustudent.com and @alueducation.com emails can join.';
  static const String emailLabel = 'ALU email';
  static const String emailHint = 'you@alustudent.com';
  static const String passwordLabel = 'Password';
  static const String passwordHint = 'Your password';
  static const String newPasswordHint = 'At least 8 characters, with a number';
  static const String confirmPasswordLabel = 'Confirm password';
  static const String confirmPasswordHint = 'Type it again';
  static const String fullNameLabel = 'Full name';
  static const String fullNameHint = 'e.g. Amara Kamau';
  static const String showPassword = 'Show password';
  static const String hidePassword = 'Hide password';
  static const String signIn = 'SIGN IN';
  static const String createAccount = 'CREATE ACCOUNT';
  static const String orDivider = 'or';
  static const String forgotPassword = 'Forgot password?';
  static const String noAccountPrompt = 'New to the campus network? ';
  static const String createAccountLink = 'Create an account';
  static const String haveAccountPrompt = 'Already have an account? ';
  static const String signInLink = 'Sign in';
  static const String acceptTermsFirst =
      'Please accept the campus terms to continue.';

  // Forgot password
  static const String resetPasswordTitle = 'Reset your password';
  static const String resetPasswordSubtitle =
      'Enter your ALU email and we\'ll send you a link to choose a new '
      'password.';
  static const String sendResetLink = 'SEND RESET LINK';
  static const String resetLinkSentTitle = 'Check your inbox';
  static String resetLinkSent(String email) =>
      'If an account exists for $email, a reset link is on its way. '
      'It can take a minute, and may land in spam.';
  static const String backToSignIn = 'BACK TO SIGN IN';

  // Verify email
  static const String verifyEmailTitle = 'Verify your email';
  static String verifyEmailBody(String email) =>
      'We sent a verification link to $email. Open it on any device, then '
      'come back here. This page updates on its own.';
  static const String iVerified = 'I\'VE VERIFIED MY EMAIL';
  static const String resendEmail = 'Resend email';
  static String resendIn(int seconds) => 'Resend in ${seconds}s';
  static const String verificationSent = 'Verification email sent.';
  static const String notVerifiedYet =
      'Not verified yet. Open the link in the email first.';
  static const String useDifferentAccount = 'Use a different account';

  // Validation
  static const String fieldRequired = 'This field is required.';
  static const String emailRequired = 'Enter your ALU email.';
  static const String emailInvalid = 'That doesn\'t look like an email.';
  static const String emailNotAlu =
      'Use your @alustudent.com or @alueducation.com email.';
  static const String passwordRequired = 'Enter your password.';
  static const String passwordTooShort = 'Use at least 8 characters.';
  static const String passwordTooWeak = 'Mix letters and at least one number.';
  static const String passwordsDontMatch = 'Passwords don\'t match.';
  static const String nameRequired = 'Enter your name.';
  static const String nameTooShort = 'Name is too short.';
  static const String nameTooLong = 'Name is too long.';
  static const String handleRequired = 'Choose a handle.';
  static const String handleLength = 'Use 3 to 30 characters.';
  static const String handleInvalid =
      'Use lowercase letters, numbers, dots and underscores.';
  static String tooLong(int max) => 'Keep it under $max characters.';

  // Auth errors
  static const String authInvalidCredential = 'Email or password is incorrect.';
  static const String authEmailInUse =
      'An account already exists for this email. Sign in instead.';
  static const String authWeakPassword =
      'That password is too weak. Use at least 8 characters with a number.';
  static const String authInvalidEmail = 'That email address isn\'t valid.';
  static const String authUserDisabled =
      'This account has been disabled. Contact Student Life.';
  static const String authTooManyRequests =
      'Too many attempts. Wait a few minutes and try again.';
  static const String authNetwork =
      'No connection. Check your internet and try again.';
  static const String authDomainNotAllowed =
      'Only ALU accounts can join. Use your @alustudent.com or '
      '@alueducation.com account.';
  static const String authDifferentMethod =
      'This email is registered with another sign-in method. Try Google or '
      'your password instead.';
  static const String authRequiresRecentLogin =
      'For your security, sign in again and retry.';
  static const String authGoogleNotConfigured =
      'Google sign-in isn\'t set up on this build. Use email instead.';
  static const String authUnknown = 'Something went wrong. Please try again.';

  // Account settings
  static const String editProfile = 'Edit profile';
  static const String editProfileSubtitle = 'Name, handle, bio and programme';
  static const String signOut = 'Sign out';
  static const String signOutSubtitle = 'You can sign back in any time';
  static const String signOutConfirmTitle = 'Sign out?';
  static const String signOutConfirmBody =
      'You\'ll need to sign in again to use the campus network.';
  static const String deleteAccount = 'Delete account';
  static const String deleteAccountSubtitle =
      'Permanently remove your profile, posts and listings';
  static const String deleteAccountConfirmTitle = 'Delete your account?';
  static const String deleteAccountConfirmBody =
      'This permanently deletes your profile, posts, listings, likes and '
      'saved items. Messages you sent stay with the people you sent them to. '
      'This can\'t be undone.';
  static const String deleteAccountPasswordPrompt =
      'Enter your password to confirm.';
  static const String deleteAccountGooglePrompt =
      'You\'ll be asked to choose your Google account again to confirm.';
  static const String deleteForever = 'Delete forever';
  static const String cancel = 'Cancel';
  static const String accountDeleted = 'Your account has been deleted.';
  static const String accountSection = 'ACCOUNT';
  static const String dangerSection = 'DANGER ZONE';

  // Edit profile
  static const String saveChanges = 'SAVE CHANGES';
  static const String profileUpdated = 'Profile updated.';
  static const String handleLabel = 'Handle';
  static const String handleHint = '@amara.builds';
  static const String cohortLabel = 'Cohort';
  static const String cohortHint = 'e.g. ALU \'27';
  static const String roleTagLabel = 'Role';
  static const String roleTagHint = 'e.g. Student Leader • Year 3';
  static const String campusLabel = 'Campus';
  static const String campusHint = 'e.g. ALU Kigali Campus';
  static const String programLabel = 'Programme';
  static const String programHint = 'e.g. BSc Software Engineering • 2027';
  static const String bioLabel = 'Bio';
  static const String bioHint = 'Tell classmates what you\'re working on.';
  static const String changePhoto = 'Change photo';
  static const String chooseFromGallery = 'Choose from gallery';
  static const String takePhoto = 'Take a photo';
  static const String removeProfilePhoto = 'Remove photo';
  static const String photoPickFailed = 'Couldn\'t open your photos.';
  static const String discardChangesTitle = 'Discard changes?';
  static const String discardChangesBody =
      'Your edits to your profile haven\'t been saved.';
  static const String discard = 'Discard';
  static const String keepEditing = 'Keep editing';

  // Notification settings
  static const String notificationSettings = 'Notification settings';
  static const String notificationSettingsSubtitle =
      'Choose which alerts you get';
  static const String pushSection = 'PUSH NOTIFICATIONS';
  static const String whileOpenSection = 'WHILE THE APP IS OPEN';
  static const String topicAnnouncements = 'Campus announcements';
  static const String topicAnnouncementsSubtitle =
      'News and events from official handles';
  static const String topicMarketplace = 'Marketplace';
  static const String topicMarketplaceSubtitle =
      'New listings and deals on campus';
  static const String topicMessages = 'Messages';
  static const String topicMessagesSubtitle = 'When someone messages you';
  static const String inAppAlerts = 'Show alerts';
  static const String inAppAlertsSubtitle =
      'Pop up new notifications while you\'re using the app';
  static const String settingNotSaved =
      'Couldn\'t update that setting. Check your connection and try again.';
  static const String notificationsOffTitle = 'Notifications are off';
  static const String notificationsOffMessage =
      'Turn them on for vsquare in your phone\'s Settings to get alerts.';

  // Chat options menu
  static const String muteChat = 'Mute notifications';
  static const String unmuteChat = 'Unmute notifications';
  static const String chatMuted = 'Chat muted.';
  static const String chatUnmuted = 'Chat unmuted.';
  static const String blockUser = 'Block';
  static const String blockConfirmTitle = 'Block this person?';
  static const String blockConfirmBody =
      'They\'ll disappear from your inbox and you won\'t see this chat again.';
  static const String userBlocked =
      'Blocked. This chat is hidden from your inbox.';
}
