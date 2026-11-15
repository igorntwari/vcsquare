// Every model written with toFirestore() reads back the same with
// fromFirestore().
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/data/dummy/dummy_categories.dart';
import 'package:vsquare/data/dummy/dummy_communities.dart';
import 'package:vsquare/data/dummy/dummy_conversations.dart';
import 'package:vsquare/data/dummy/dummy_listings.dart';
import 'package:vsquare/data/dummy/dummy_official_handles.dart';
import 'package:vsquare/data/dummy/dummy_peer_suggestions.dart';
import 'package:vsquare/data/dummy/dummy_pickup_hubs.dart';
import 'package:vsquare/data/dummy/dummy_posts.dart';
import 'package:vsquare/data/dummy/dummy_profile.dart';
import 'package:vsquare/data/dummy/dummy_trending_topics.dart';
import 'package:vsquare/data/dummy/dummy_users.dart';
import 'package:vsquare/data/models/category_model.dart';
import 'package:vsquare/data/models/community_model.dart';
import 'package:vsquare/data/models/conversation_model.dart';
import 'package:vsquare/data/models/listing_model.dart';
import 'package:vsquare/data/models/message_model.dart';
import 'package:vsquare/data/models/official_handle_model.dart';
import 'package:vsquare/data/models/peer_suggestion_model.dart';
import 'package:vsquare/data/models/pickup_hub_model.dart';
import 'package:vsquare/data/models/post_model.dart';
import 'package:vsquare/data/models/profile_model.dart';
import 'package:vsquare/data/models/trending_topic_model.dart';
import 'package:vsquare/data/models/user_model.dart';

// Timestamps keep millisecond precision, so compare at that resolution.
int ms(DateTime value) => value.millisecondsSinceEpoch;

void main() {
  test('UserModel', () {
    for (final user in dummyUsers) {
      final back = UserModel.fromFirestore(user.id, user.toFirestore());
      expect(back.toFirestore(), user.toFirestore());
    }
  });

  test('ProfileModel keeps profile and user fields in one document', () {
    final data = dummyProfile.toFirestore();
    final back = ProfileModel.fromFirestore(
      data,
      user: UserModel.fromFirestore(dummyProfile.user.id, data),
    );
    expect(back.toFirestore(), data);
  });

  test('PostModel stores authorId and resolves the author back', () {
    for (final post in dummyPosts) {
      final data = post.toFirestore();
      expect(data['authorId'], post.author.id);
      expect(data['createdAt'], isA<Timestamp>());
      final back = PostModel.fromFirestore(
        post.id,
        data,
        author: post.author,
        commentAuthor: post.commentPreview?.author,
      );
      expect(back.toFirestore(), data);
      expect(ms(back.createdAt), ms(post.createdAt));
      expect(back.event?.title, post.event?.title);
    }
  });

  test('ListingModel stores sellerId and enum names', () {
    for (final listing in dummyListings) {
      final data = listing.toFirestore();
      expect(data['sellerId'], listing.seller.id);
      expect(data['condition'], listing.condition.name);
      final back = ListingModel.fromFirestore(
        listing.id,
        data,
        seller: listing.seller,
      );
      expect(back.toFirestore(), data);
    }
  });

  test('Fixed data stores icon names, not IconData', () {
    for (final c in dummyCategories) {
      expect(c.toFirestore()['iconName'], isA<String>());
      final back = CategoryModel.fromFirestore(c.id, c.toFirestore());
      expect(back.icon, c.icon);
      expect(back.toFirestore(), c.toFirestore());
    }
    for (final h in dummyOfficialHandles) {
      final back = OfficialHandleModel.fromFirestore(h.id, h.toFirestore());
      expect(back.icon, h.icon);
      expect(back.toFirestore(), h.toFirestore());
    }
    for (final h in dummyPickupHubs) {
      final back = PickupHubModel.fromFirestore(h.id, h.toFirestore());
      expect(back.icon, h.icon);
      expect(back.toFirestore(), h.toFirestore());
    }
  });

  test('CommunityModel stores member ids', () {
    for (final c in dummyCommunities) {
      final data = c.toFirestore();
      expect(
        CommunityModel.memberPreviewIdsOf(data),
        c.members.map((m) => m.id).toList(),
      );
      final back = CommunityModel.fromFirestore(c.id, data, members: c.members);
      expect(back.toFirestore(), data);
    }
  });

  test('TrendingTopicModel and PeerSuggestionModel', () {
    for (final t in dummyTrendingTopics) {
      expect(
        TrendingTopicModel.fromFirestore(t.toFirestore()).toFirestore(),
        t.toFirestore(),
      );
    }
    for (final s in dummyPeerSuggestions) {
      final back = PeerSuggestionModel.fromFirestore(
        s.toFirestore(),
        user: s.user,
      );
      expect(back.toFirestore(), s.toFirestore());
    }
  });

  test('MessageModel stores senderId instead of isMine', () {
    final message = MessageModel(
      id: 'm1',
      text: 'Hi',
      sentAt: DateTime(2026, 11, 15, 9, 30),
      senderId: 'u_amara',
      status: MessageStatus.sent,
    );
    final back = MessageModel.fromFirestore('m1', message.toFirestore());
    expect(back.isFrom('u_amara'), isTrue);
    expect(back.isFrom('u_kofi'), isFalse);
    expect(back.toFirestore(), message.toFirestore());
  });

  test('ConversationModel reads unread count for the current user', () {
    final conversation = dummyConversations.first;
    final data = conversation.toFirestore(currentUserId: dummyCurrentUser.id);
    expect(data['participantIds'], [
      dummyCurrentUser.id,
      conversation.participant.id,
    ]);
    expect(
      ConversationModel.otherParticipantId(data, dummyCurrentUser.id),
      conversation.participant.id,
    );
    final back = ConversationModel.fromFirestore(
      conversation.id,
      data,
      currentUserId: dummyCurrentUser.id,
      participant: conversation.participant,
      listing: conversation.listing,
    );
    expect(back.unreadCount, conversation.unreadCount);
    expect(back.lastMessage.text, conversation.lastMessage.text);
  });
}
