// Image from a bundled asset path or a web URL (e.g. Cloudinary).
import 'dart:io';

import 'package:flutter/material.dart';

// Sample data uses "assets/..." paths; real data uses Cloudinary https URLs.
// Both go through here so screens work with either.
class AppImage extends StatelessWidget {
  const AppImage(
    this.path, {
    super.key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.errorBuilder,
  });

  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;
  final ImageErrorWidgetBuilder? errorBuilder;

  static bool isNetwork(String path) =>
      path.startsWith('http://') || path.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (isNetwork(path)) {
      return Image.network(
        path,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: errorBuilder,
      );
    }
    if (!path.startsWith('assets/')) {
      return Image.file(
        File(path),
        fit: fit,
        width: width,
        height: height,
        errorBuilder: errorBuilder,
      );
    }
    return Image.asset(
      path,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: errorBuilder,
    );
  }
}
