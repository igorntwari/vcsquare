// Inbox and permission state from NotificationService.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/notification_service.dart';
import '../../../data/models/notification_model.dart';

final inboxProvider =
    NotifierProvider<InboxController, List<NotificationModel>>(
      InboxController.new,
    );

class InboxController extends Notifier<List<NotificationModel>> {
  NotificationService get _service => NotificationService.instance;

  @override
  List<NotificationModel> build() {
    final source = _service.notifications;
    void listener() => state = source.value;
    source.addListener(listener);
    ref.onDispose(() => source.removeListener(listener));
    return source.value;
  }

  Future<void> markRead(String id) => _service.markRead(id);

  Future<void> markAllRead() => _service.markAllRead();

  Future<void> remove(String id) => _service.remove(id);
}

final notificationPermissionProvider =
    NotifierProvider<NotificationPermission, bool?>(NotificationPermission.new);

class NotificationPermission extends Notifier<bool?> {
  @override
  bool? build() {
    final source = NotificationService.instance.permissionGranted;
    void listener() => state = source.value;
    source.addListener(listener);
    ref.onDispose(() => source.removeListener(listener));
    return source.value;
  }
}
