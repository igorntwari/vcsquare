// The avatar on Edit profile, with a button to change it.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/avatars/user_avatar.dart';

class ProfilePhotoEditor extends StatelessWidget {
  const ProfilePhotoEditor({
    super.key,
    required this.photoUrl,
    required this.newPhoto,
    required this.onChange,
  });

  final String? photoUrl;

  // Picked but not uploaded yet; shown instead of [photoUrl].
  final XFile? newPhoto;
  final VoidCallback? onChange;

  @override
  Widget build(BuildContext context) {
    const size = AppSizes.avatarEdit;
    final avatar = newPhoto == null
        ? UserAvatar(size: size, imagePath: photoUrl)
        : ClipOval(
            child: Image.file(
              File(newPhoto!.path),
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          );

    return Column(
      children: [
        Semantics(
          button: true,
          label: AppStrings.changePhoto,
          child: GestureDetector(
            onTap: onChange,
            child: Stack(
              children: [
                avatar,
                const Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: AppSizes.iconMd * 0.75,
                    backgroundColor: AppColors.primary,
                    child: Icon(
                      Icons.photo_camera,
                      size: AppSizes.iconSm,
                      color: AppColors.textOnDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextButton(
          onPressed: onChange,
          child: Text(
            AppStrings.changePhoto,
            style: AppTypography.titleMedium.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
