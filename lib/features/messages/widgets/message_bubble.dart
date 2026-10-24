// Bubble showing a single chat message.
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/message_model.dart';

// Navy on the right for the current user, white on the left for others.
class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final isMine = message.isMine;
    final textColor = isMine ? AppColors.textOnDark : AppColors.textPrimary;
    final metaColor = isMine ? AppColors.textOnDarkMuted : AppColors.textMuted;
    const big = Radius.circular(AppRadius.lg);
    const small = Radius.circular(AppRadius.xs);

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.sizeOf(context).width * AppSizes.bubbleMaxWidthFactor,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isMine ? AppColors.bubbleMine : AppColors.bubbleTheirs,
            borderRadius: BorderRadius.only(
              topLeft: big,
              topRight: big,
              bottomLeft: isMine ? big : small,
              bottomRight: isMine ? small : big,
            ),
            boxShadow: isMine ? null : AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: isMine
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                message.text,
                style: AppTypography.bodyLarge.copyWith(color: textColor),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Formatters.time24(message.sentAt),
                    style: AppTypography.caption.copyWith(color: metaColor),
                  ),
                  if (isMine) ...[
                    const SizedBox(width: AppSpacing.xs),
                    Icon(
                      message.status == MessageStatus.read
                          ? Icons.done_all
                          : Icons.check,
                      size: AppSizes.iconXs,
                      color: message.status == MessageStatus.read
                          ? AppColors.readReceipt
                          : metaColor,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
