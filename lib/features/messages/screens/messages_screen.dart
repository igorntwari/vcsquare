// Inbox screen listing live conversations.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/conversation_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../shared/widgets/buttons/floating_pill_button.dart';
import '../../../shared/widgets/chips/app_chip.dart';
import '../../../shared/widgets/chips/filter_chip_bar.dart';
import '../../../shared/widgets/feedback/empty_state.dart';
import '../../../shared/widgets/feedback/error_state.dart';
import '../../../shared/widgets/inputs/app_search_bar.dart';
import '../../../shared/widgets/layout/app_top_bar.dart';
import '../providers/chats_providers.dart';
import '../widgets/conversation_tile.dart';
import '../widgets/new_chat_sheet.dart';
import 'chat_screen.dart';

enum _InboxFilter { all, marketplace, official, unread }

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  _InboxFilter _filter = _InboxFilter.all;
  String _query = '';

  List<ConversationModel> _filtered(List<ConversationModel> all) {
    final query = _query.trim().toLowerCase();

    return all.where((conversation) {
      // Hide conversations without messages.
      if (conversation.lastMessage.text.isEmpty) return false;

      final matchesFilter = switch (_filter) {
        _InboxFilter.all => true,
        _InboxFilter.marketplace =>
          conversation.type == ConversationType.marketplace,
        _InboxFilter.official => conversation.type == ConversationType.official,
        _InboxFilter.unread => conversation.unreadCount > 0,
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
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChatScreen(conversation: conversation),
      ),
    );
  }

  Future<void> _newChat() async {
    final repo = ref.read(chatsRepositoryProvider);
    final me = await ref.read(currentUserIdProvider.future);
    if (me == null) return;

    try {
      final people = await repo.fetchPeople(me);

      if (!mounted) return;

      final picked = await showModalBottomSheet<UserModel>(
        context: context,
        isScrollControlled: true,
        builder: (_) => NewChatSheet(people: people),
      );

      if (picked == null) return;

      final conversation = await repo.openConversation(
        userId: me,
        other: picked,
      );

      if (!mounted) return;

      await _openChat(conversation);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not start the chat. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final inbox = ref.watch(conversationsProvider);
    final currentUser = ref.watch(currentUserProvider).value;
    final conversations = _filtered(inbox.value ?? const []);
    final loading = inbox.isLoading && !inbox.hasValue;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Column(
      children: [
        AppTopBar(
          title: AppStrings.navMessages,
          avatarImagePath: currentUser?.avatarPath,
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
                      onSelected: (index) =>
                          setState(() => _filter = _InboxFilter.values[index]),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      bottomInset + AppSpacing.xxxl + AppSpacing.xxl,
                    ),
                    sliver: conversations.isEmpty
                        ? SliverToBoxAdapter(
                            child: inbox.hasError
                                ? ErrorState(
                                    onRetry: () =>
                                        ref.invalidate(conversationsProvider),
                                  )
                                : loading
                                ? const Padding(
                                    padding: EdgeInsets.all(AppSpacing.xxl),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : const EmptyState(
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
                                currentUserId: currentUser?.id ?? '',
                                unreadCount: conversation.unreadCount,
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
                  onPressed: _newChat,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

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
            onPressed: _newChat,
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
