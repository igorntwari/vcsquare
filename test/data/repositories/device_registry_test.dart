// Device tokens stored under the signed-in user.
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsquare/data/repositories/notifications/device_registry.dart';
import 'package:vsquare/data/repositories/notifications/push_messaging.dart';

void main() {
  group('device registry', () {
    test('stores and removes this device under the user', () async {
      final db = FakeFirebaseFirestore();
      final registry = FirebaseDeviceRegistry(
        db,
        SamplePushMessaging(deviceToken: 'token-1'),
      );
      final devices = db.collection('users').doc('u1').collection('devices');

      await registry.register('u1');
      final doc = await devices.doc('token-1').get();
      expect(doc.exists, isTrue);
      expect(doc['platform'], isA<String>());

      await registry.unregister('u1');
      expect((await devices.doc('token-1').get()).exists, isFalse);
    });

    test('does nothing without a token', () async {
      final db = FakeFirebaseFirestore();
      await FirebaseDeviceRegistry(
        db,
        SamplePushMessaging(deviceToken: ''),
      ).register('u1');
      final devices = await db
          .collection('users')
          .doc('u1')
          .collection('devices')
          .get();
      expect(devices.docs, isEmpty);
    });
  });
}
