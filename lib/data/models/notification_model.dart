// Model representing a push notification saved to the in-app inbox.
class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
    this.isRead = false,
    this.data = const {},
  });

  // FCM message id, used to avoid saving the same push twice.
  final String id;
  final String title;
  final String body;
  final DateTime receivedAt;
  final bool isRead;

  // Custom key/value pairs sent with the push (Firebase Console:
  // "Additional options" -> "Custom data").
  final Map<String, String> data;

  NotificationModel copyWith({bool? isRead}) => NotificationModel(
    id: id,
    title: title,
    body: body,
    receivedAt: receivedAt,
    isRead: isRead ?? this.isRead,
    data: data,
  );

  Map<String, Object> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'receivedAt': receivedAt.toIso8601String(),
    'isRead': isRead,
    'data': data,
  };

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        body: json['body'] as String? ?? '',
        receivedAt:
            DateTime.tryParse(json['receivedAt'] as String? ?? '') ??
            DateTime.now(),
        isRead: json['isRead'] as bool? ?? false,
        data: (json['data'] as Map<String, dynamic>? ?? const {}).map(
          (key, value) => MapEntry(key, '$value'),
        ),
      );
}
