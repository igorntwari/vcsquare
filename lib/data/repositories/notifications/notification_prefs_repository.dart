// Notification preferences in SharedPreferences.
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/notification_prefs_model.dart';

class NotificationPrefsRepository {
  NotificationPrefsRepository([SharedPreferencesAsync? prefs])
    : _prefs = prefs ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _prefs;

  static String _topicKey(NotificationTopic topic) => 'notify_${topic.topic}';
  static const String _inAppAlertsKey = 'notify_in_app_alerts';

  Future<NotificationPrefs> load() async {
    const defaults = NotificationPrefs();
    final topics = <NotificationTopic>{};
    for (final topic in NotificationTopic.values) {
      final on = await _prefs.getBool(_topicKey(topic));
      if (on ?? defaults.isOn(topic)) topics.add(topic);
    }
    return NotificationPrefs(
      topics: topics,
      inAppAlerts:
          await _prefs.getBool(_inAppAlertsKey) ?? defaults.inAppAlerts,
    );
  }

  Future<void> save(NotificationPrefs prefs) async {
    for (final topic in NotificationTopic.values) {
      await _prefs.setBool(_topicKey(topic), prefs.isOn(topic));
    }
    await _prefs.setBool(_inAppAlertsKey, prefs.inAppAlerts);
  }
}
