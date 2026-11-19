// Uploads images through Cloudinary's unsigned REST endpoint.
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../core/config/app_config.dart';
import '../../core/constants/app_strings.dart';

class CloudinaryUploadService {
  static const int maxImageBytes = 8 * 1024 * 1024;

  CloudinaryUploadService({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  Future<String> upload(XFile file) async {
    if (await file.length() > maxImageBytes) {
      throw StateError(AppStrings.imageTooLarge);
    }

    final cloudName = AppConfig.cloudinaryCloudName;
    final preset = AppConfig.cloudinaryUploadPreset;
    if (cloudName.isEmpty || preset.isEmpty) {
      throw StateError(
        'Set CLOUDINARY_CLOUD_NAME and CLOUDINARY_UPLOAD_PRESET to upload photos.',
      );
    }

    final request =
        http.MultipartRequest(
            'POST',
            Uri.https('api.cloudinary.com', '/v1_1/$cloudName/image/upload'),
          )
          ..fields['upload_preset'] = preset
          ..files.add(await http.MultipartFile.fromPath('file', file.path));
    final response = await _client.send(request);
    final body = await response.stream.bytesToString();
    final decoded = jsonDecode(body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = decoded is Map ? decoded['error'] : null;
      final message = error is Map ? error['message'] : null;
      throw StateError(message?.toString() ?? 'Cloudinary upload failed.');
    }
    if (decoded is! Map || decoded['secure_url'] is! String) {
      throw const FormatException('Cloudinary did not return an image URL.');
    }
    return decoded['secure_url'] as String;
  }

  void close() => _client.close();
}
