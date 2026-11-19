// Notification choices saved on the device.
enum NotificationTopic {
  announcements('announcements'),
  marketplace('marketplace'),
  messages('messages');

  const NotificationTopic(this.topic);

  // FCM topic name.
  final String topic;
}

class NotificationPrefs {
  const NotificationPrefs({
    this.topics = const {
      NotificationTopic.announcements,
      NotificationTopic.marketplace,
      NotificationTopic.messages,
    },
    this.inAppAlerts = true,
  });

  final Set<NotificationTopic> topics;

  final bool inAppAlerts;

  bool isOn(NotificationTopic topic) => topics.contains(topic);

  NotificationPrefs withTopic(NotificationTopic topic, bool on) =>
      NotificationPrefs(
        topics: on ? {...topics, topic} : ({...topics}..remove(topic)),
        inAppAlerts: inAppAlerts,
      );

  NotificationPrefs withInAppAlerts(bool on) =>
      NotificationPrefs(topics: topics, inAppAlerts: on);

  @override
  bool operator ==(Object other) =>
      other is NotificationPrefs &&
      other.inAppAlerts == inAppAlerts &&
      other.topics.length == topics.length &&
      other.topics.containsAll(topics);

  @override
  int get hashCode => Object.hash(inAppAlerts, Object.hashAllUnordered(topics));
}
