// Inbox screen listing conversations.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/dummy/dummy_conversations.dart';
import '../../../data/dummy/dummy_users.dart';
import '../../../data/models/conversation_model.dart';
import '../../../shared/widgets/buttons/floating_pill_button.dart';
import '../../../shared/widgets/chips/app_chip.dart';
import '../../../shared/widgets/chips/filter_chip_bar.dart';
import '../../../shared/widgets/feedback/empty_state.dart';
import '../../../shared/widgets/inputs/app_search_bar.dart';
import '../../../shared/widgets/layout/app_top_bar.dart';
import '../widgets/conversation_tile.dart';
import 'chat_screen.dart';

enum _InboxFilter { all, marketplace, official, unread }

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  _InboxFilter _filter = _InboxFilter.all;
  String _query = '';

  // Conversations opened this session; their unread count is cleared.
  final Set<String> _openedIds = {};

  int _unreadCount(ConversationModel conversation) =>
      _openedIds.contains(conversation.id) ? 0 : conversation.unreadCount;

  List<ConversationModel> get _visibleConversations {
    final query = _query.trim().toLowerCase();
    return dummyConversations.where((conversation) {
      final matchesFilter = switch (_filter) {
        _InboxFilter.all => true,
        _InboxFilter.marketplace =>
          conversation.type == ConversationType.marketplace,
        _InboxFilter.official => conversation.type == ConversationType.official,
        _InboxFilter.unread => _unreadCount(conversation) > 0,
      };
      if (!matchesFilter) return false;
      if (query.isEmpty) return true;
      final haystack = [
        conversation.participant.name,
        conversation.subject ?? '',
        conversation.listing?.title ?? '',
        conversation.lastMessage.text,
      ].join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  Future<void> _openChat(ConversationModel conversation) async {
    setState(() => _openedIds.add(conversation.id));
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChatScreen(conversation: conversation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final conversations = _visibleConversations;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Column(
      children: [
        AppTopBar(
          title: AppStrings.navMessages,
          avatarImagePath: dummyCurrentUser.avatarPath,
          hasUnreadNotifications: true,
        ),
        Expanded(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildSearchRow()),
                  SliverToBoxAdapter(
                    child: FilterChipBar(
                      chips: const [
                        AppChip(label: AppStrings.filterAllChats),
                        AppChip(
                          label: AppStrings.filterMarketplace,
                          icon: Icons.storefront_outlined,
                        ),
                        AppChip(label: AppStrings.filterOfficial),
                        AppChip(label: AppStrings.filterUnread),
                      ],
                      onSelected: (index) => setState(
                        () => _filter = _InboxFilter.values[index],
                      ),
                    ),
                  ),
                  SliverPadding(
                    // Leaves room for the floating New Chat button.
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      bottomInset + AppSpacing.xxxl + AppSpacing.xxl,
                    ),
                    sliver: conversations.isEmpty
                        ? const SliverToBoxAdapter(
                            child: EmptyState(
                              icon: Icons.forum_outlined,
                              title: AppStrings.noChatsTitle,
                              message: AppStrings.noChatsMessage,
                            ),
                          )
                        : SliverList.separated(
                            itemCount: conversations.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: AppSpacing.sm),
                            itemBuilder: (context, index) {
                              final conversation = conversations[index];
                              return ConversationTile(
                                conversation: conversation,
                                unreadCount: _unreadCount(conversation),
                                onTap: () => _openChat(conversation),
                              );
                            },
                          ),
                  ),
                ],
              ),
              Positioned(
                right: AppSpacing.lg,
                bottom: bottomInset + AppSpacing.lg,
                child: FloatingPillButton(
                  icon: Icons.add_comment_outlined,
                  label: AppStrings.newChat,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Light search field with a round "new message" button beside it.
  Widget _buildSearchRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: AppSearchBar(
              hintText: AppStrings.messagesSearchHint,
              onDark: false,
              showFilter: false,
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            tooltip: AppStrings.newMessage,
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primary,
              fixedSize: const Size.square(AppSizes.tapTarget),
            ),
            icon: const Icon(
              Icons.edit_square,
              size: AppSizes.iconMd,
              color: AppColors.textOnDark,
            ),
          ),
        ],
      ),
    );
  }
}
