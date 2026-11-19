// Device push tokens, stored at users/{uid}/devices/{token}.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../firebase/firestore_collections.dart';
import 'push_messaging.dart';

abstract interface class DeviceRegistry {
  Future<void> register(String userId);

  Future<void> unregister(String userId);
}

class FirebaseDeviceRegistry implements DeviceRegistry {
  FirebaseDeviceRegistry(this._db, this._push);

  final FirebaseFirestore _db;
  final PushMessaging _push;

  Future<DocumentReference<Map<String, dynamic>>?> _deviceDoc(
    String userId,
  ) async {
    final token = await _push.token();
    if (token == null || token.isEmpty) return null;
    return _db
        .collection(FirestoreCollections.users)
        .doc(userId)
        .collection(FirestoreCollections.devices)
        .doc(token);
  }

  @override
  Future<void> register(String userId) async {
    await (await _deviceDoc(userId))?.set({
      'platform': defaultTargetPlatform.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> unregister(String userId) async {
    await (await _deviceDoc(userId))?.delete();
  }
}

class SampleDeviceRegistry implements DeviceRegistry {
  final Set<String> registered = {};

  @override
  Future<void> register(String userId) async => registered.add(userId);

  @override
  Future<void> unregister(String userId) async => registered.remove(userId);
}
