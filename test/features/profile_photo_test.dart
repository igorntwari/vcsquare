// Changing and removing the profile photo on Edit profile.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vsquare/core/constants/app_strings.dart';
import 'package:vsquare/data/models/profile_edit_model.dart';
import 'package:vsquare/data/repositories/profile/sample_profile_repository.dart';
import 'package:vsquare/data/repositories/repository_providers.dart';
import 'package:vsquare/features/profile/screens/edit_profile_screen.dart';
import 'package:vsquare/shared/services/cloudinary_upload_service.dart';
import 'package:vsquare/shared/services/media_providers.dart';

import '../helpers/test_app.dart';

// A 1x1 transparent PNG.
final _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);

class _FakePicker extends ImagePicker {
  _FakePicker(this.file);

  final XFile? file;

  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async => file;
}

class _FakeUploader extends CloudinaryUploadService {
  _FakeUploader({this.error});

  final Object? error;
  final List<String> uploaded = [];

  @override
  Future<String> upload(XFile file) async {
    if (error != null) throw error!;
    uploaded.add(file.path);
    return 'https://res.cloudinary.com/demo/image/upload/new.jpg';
  }
}

void main() {
  setUpAll(loadAppFonts);

  late File photo;
  late SampleProfileRepository profiles;

  setUp(() {
    photo = File('${Directory.systemTemp.createTempSync().path}/me.png')
      ..writeAsBytesSync(_png);
    profiles = SampleProfileRepository();
  });

  Future<void> pump(
    WidgetTester tester, {
    required _FakeUploader uploader,
    required VoidCallback onDone,
  }) async {
    await pumpScreen(
      tester,
      EditProfileScreen(onDone: onDone),
      overrides: [
        profileRepositoryProvider.overrideWithValue(profiles),
        imagePickerProvider.overrideWithValue(_FakePicker(XFile(photo.path))),
        imageUploadServiceProvider.overrideWithValue(uploader),
      ],
    );
    await tester.pumpAndSettle();
  }

  Future<void> choose(WidgetTester tester, String option) async {
    await tester.tap(find.text(AppStrings.changePhoto));
    await tester.pumpAndSettle();
    await tester.tap(find.text(option));
    await tester.pumpAndSettle();
  }

  testWidgets('a picked photo is uploaded and saved', (tester) async {
    final uploader = _FakeUploader();
    var closed = false;
    await pump(tester, uploader: uploader, onDone: () => closed = true);

    await choose(tester, AppStrings.chooseFromGallery);
    expect(find.byType(Image), findsWidgets);

    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();

    expect(uploader.uploaded, [photo.path]);
    expect(closed, isTrue);
    expect(
      (await profiles.fetchProfile('any')).user.avatarPath,
      'https://res.cloudinary.com/demo/image/upload/new.jpg',
    );
  });

  testWidgets('removing the photo saves no photo', (tester) async {
    final current = await profiles.fetchProfile('any');
    await profiles.updateProfile(
      'any',
      ProfileEdit.fromProfile(current)
          .withAvatar('https://example.com/old.jpg'),
    );
    final uploader = _FakeUploader();
    await pump(tester, uploader: uploader, onDone: () {});

    await choose(tester, AppStrings.removeProfilePhoto);
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();

    expect(uploader.uploaded, isEmpty);
    expect((await profiles.fetchProfile('any')).user.avatarPath, isNull);
  });

  testWidgets('an upload error is shown and nothing is saved', (tester) async {
    final uploader = _FakeUploader(error: StateError(AppStrings.imageTooLarge));
    var closed = false;
    await pump(tester, uploader: uploader, onDone: () => closed = true);

    await choose(tester, AppStrings.chooseFromGallery);
    await tester.tap(find.text(AppStrings.save));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.imageTooLarge), findsOneWidget);
    expect(closed, isFalse);
  });
}
