// Image from a bundled asset path or a web URL (e.g. Firebase Storage).
import 'package:flutter/material.dart';

// Sample data uses "assets/..." paths; Firebase data uses https URLs.
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
    return isNetwork(path)
        ? Image.network(
            path,
            fit: fit,
            width: width,
            height: height,
            errorBuilder: errorBuilder,
          )
        : Image.asset(
            path,
            fit: fit,
            width: width,
            height: height,
            errorBuilder: errorBuilder,
          );
  }
}
