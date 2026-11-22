// Bottom sheet: gallery, camera or remove the current photo.
import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

enum PhotoAction { gallery, camera, remove }

Future<PhotoAction?> showPhotoSourceSheet(
  BuildContext context, {
  required bool canRemove,
}) => showModalBottomSheet<PhotoAction>(
  context: context,
  showDragHandle: true,
  builder: (context) => PhotoSourceSheet(canRemove: canRemove),
);

class PhotoSourceSheet extends StatelessWidget {
  const PhotoSourceSheet({super.key, required this.canRemove});

  final bool canRemove;

  @override
  Widget build(BuildContext context) {
    Widget option(
      IconData icon,
      String label,
      PhotoAction action, {
      Color color = AppColors.textPrimary,
    }) => ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: AppTypography.titleMedium.copyWith(color: color),
      ),
      onTap: () => Navigator.of(context).pop(action),
    );

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          option(
            Icons.photo_library_outlined,
            AppStrings.chooseFromGallery,
            PhotoAction.gallery,
          ),
          option(
            Icons.photo_camera_outlined,
            AppStrings.takePhoto,
            PhotoAction.camera,
          ),
          if (canRemove)
            option(
              Icons.delete_outline,
              AppStrings.removeProfilePhoto,
              PhotoAction.remove,
              color: AppColors.error,
            ),
        ],
      ),
    );
  }
}
