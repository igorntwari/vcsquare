// Input bar for composing chat messages.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

// Attach button, pill text field and red send button. Clears after sending.
class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key, required this.onSend, this.onAttach});

  final ValueChanged<String> onSend;
  final VoidCallback? onAttach;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();

  bool get _canSend => _controller.text.trim().isNotEmpty;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    if (!_canSend) return;
    widget.onSend(_controller.text.trim());
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const pillBorder = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.navBar,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              IconButton(
                tooltip: AppStrings.attach,
                onPressed: widget.onAttach ?? () {},
                icon: const Icon(
                  Icons.add_circle_outline,
                  size: AppSizes.iconLg,
                  color: AppColors.iconMuted,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  minLines: 1,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.send,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _send(),
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.inputFill,
                    hintText: AppStrings.messageHint,
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textMuted,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    border: pillBorder,
                    enabledBorder: pillBorder,
                    focusedBorder: pillBorder,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                tooltip: AppStrings.send,
                onPressed: _canSend ? _send : null,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  disabledBackgroundColor: AppColors.chipBackground,
                  fixedSize: const Size.square(AppSizes.sendButton),
                ),
                icon: Icon(
                  Icons.send,
                  size: AppSizes.iconMd,
                  color: _canSend ? AppColors.textOnDark : AppColors.iconMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
