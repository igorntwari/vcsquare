// Comments list and composer for a single Home post.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/post_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/posts/post_comment.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../shared/widgets/avatars/user_avatar.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../providers/home_providers.dart';

class PostCommentsSheet extends ConsumerStatefulWidget {
  const PostCommentsSheet({super.key, required this.post});

  final PostModel post;

  @override
  ConsumerState<PostCommentsSheet> createState() => _PostCommentsSheetState();
}

class _PostCommentsSheetState extends ConsumerState<PostCommentsSheet> {
  final TextEditingController _controller = TextEditingController();
  List<PostComment> _comments = const [];
  bool _isLoading = true;
  bool _isSending = false;
  bool _hasError = false;
  bool _hasChanges = false;
  late int _commentCount = widget.post.commentCount;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final comments = await ref
          .read(postsRepositoryProvider)
          .fetchComments(widget.post.id);
      if (!mounted) return;
      setState(() => _comments = comments);
    } catch (_) {
      if (!mounted) return;
      setState(() => _hasError = true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _sendComment() async {
    final author = ref.read(currentUserProvider).value;
    final text = _controller.text.trim();
    if (author == null || text.isEmpty || _isSending) return;
    setState(() => _isSending = true);
    try {
      await ref
          .read(postsRepositoryProvider)
          .addComment(postId: widget.post.id, author: author, text: text);
      if (!mounted) return;
      _hasChanges = true;
      _commentCount++;
      ref.invalidate(homeFeedProvider);
      _controller.clear();
      await _loadComments();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text(AppStrings.saveFailed)));
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final user = ref.watch(currentUserProvider).value;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: size.height * 0.72,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${AppStrings.commentsTitle} ($_commentCount)',
                        style: AppTypography.headingMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: AppStrings.close,
                      onPressed: () => Navigator.of(context).pop(_hasChanges),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(child: _buildCommentList()),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    UserAvatar(size: 36, imagePath: user?.avatarPath),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppTextField(
                        controller: _controller,
                        hintText: AppStrings.commentHint,
                        maxLength: 1000,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    IconButton(
                      tooltip: AppStrings.send,
                      onPressed:
                          user != null &&
                              _controller.text.trim().isNotEmpty &&
                              !_isSending
                          ? _sendComment
                          : null,
                      icon: _isSending
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_hasError) {
      return Center(
        child: TextButton(
          onPressed: _loadComments,
          child: const Text(AppStrings.retry),
        ),
      );
    }
    if (_comments.isEmpty) {
      final preview = widget.post.commentPreview;
      if (preview == null) {
        return const Center(child: Text(AppStrings.noCommentsMessage));
      }
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _CommentTile(
            author: preview.author,
            text: preview.text,
            time: Formatters.timeAgo(widget.post.createdAt),
          ),
        ],
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: _comments.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.lg),
      itemBuilder: (context, index) {
        final comment = _comments[index];
        return _CommentTile(
          author: comment.author,
          text: comment.text,
          time: Formatters.timeAgo(comment.createdAt),
        );
      },
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({
    required this.author,
    required this.text,
    required this.time,
  });

  final UserModel author;
  final String text;
  final String time;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      UserAvatar(size: 36, imagePath: author.avatarPath),
      const SizedBox(width: AppSpacing.sm),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    author.name,
                    style: AppTypography.label.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  time,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              text,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
