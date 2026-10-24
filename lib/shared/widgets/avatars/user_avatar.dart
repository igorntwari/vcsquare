// Circular user profile image.
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

// Shows [imagePath] in a circle, or a person icon when there is no image yet.
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.size, this.imagePath});

  final double size;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final placeholder = Icon(
      Icons.person,
      size: size * 0.6,
      color: AppColors.iconMuted,
    );

    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: AppColors.blueSurface,
        child: imagePath == null
            ? placeholder
            : Image.asset(
                imagePath!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => placeholder,
              ),
      ),
    );
  }
}
