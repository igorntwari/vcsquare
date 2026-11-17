// Composer for a text post and its campus audience.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/post_model.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../shared/widgets/avatars/user_avatar.dart';
import '../../../shared/widgets/inputs/app_text_area.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final TextEditingController _bodyController = TextEditingController();
  static const String _audienceValue = 'Everyone';
  bool _isPublishing = false;

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    final user = ref.read(currentUserProvider).value;
    final body = _bodyController.text.trim();
    if (body.isEmpty || user == null || _isPublishing) return;
    setState(() => _isPublishing = true);
    try {
      await ref
          .read(postsRepositoryProvider)
          .createPost(
            PostModel(
              id: '',
              author: user,
              createdAt: DateTime.now(),
              body: body,
              audience: _audienceValue,
            ),
          );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text(AppStrings.saveFailed)));
    } finally {
      if (mounted) setState(() => _isPublishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final canPublish =
        user != null &&
        _bodyController.text.trim().isNotEmpty &&
        !_isPublishing;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.createPostTitle),
        leading: IconButton(
          tooltip: AppStrings.close,
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
        actions: [
          TextButton(
            onPressed: canPublish ? _publish : null,
            child: _isPublishing
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(AppStrings.publishPost),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Row(
            children: [
              UserAvatar(size: 40, imagePath: user?.avatarPath),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  user?.name ?? AppStrings.profile,
                  style: AppTypography.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextArea(
            controller: _bodyController,
            hintText: AppStrings.postBodyHint,
            minLines: 7,
            maxLength: 2000,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(AppStrings.postAudience, style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          const ChoiceChip(
            label: Text(AppStrings.audienceCampus),
            selected: true,
          ),
        ],
      ),
    );
  }
}
