// Photo picking and uploading as providers, so tests can swap them.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'cloudinary_upload_service.dart';

final imagePickerProvider = Provider<ImagePicker>((ref) => ImagePicker());

final imageUploadServiceProvider = Provider<CloudinaryUploadService>((ref) {
  final service = CloudinaryUploadService();
  ref.onDispose(service.close);
  return service;
});
