// Formatting helpers for prices, dates and counts.
abstract final class Formatters {
  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  // "Just now", "45m ago", "3h ago", "2d ago", then "12 Oct".
  static String timeAgo(DateTime time, {DateTime? now}) {
    final diff = (now ?? DateTime.now()).difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.day} ${monthShort(time)}';
  }

  // 184 -> "184", 1250 -> "1.3k", 12000 -> "12k".
  static String compactCount(int count) {
    if (count < 1000) return '$count';
    final thousands = count / 1000;
    final text = thousands.toStringAsFixed(thousands >= 10 ? 0 : 1);
    return '${text.endsWith('.0') ? text.substring(0, text.length - 2) : text}k';
  }

  static const List<String> _weekdays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  // Inbox timestamps: "16:30" today, "Yesterday", "Tue" this week, then "12 Oct".
  static String chatTimestamp(DateTime time, {DateTime? now}) {
    final today = now ?? DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    final startOfDay = DateTime(time.year, time.month, time.day);
    final daysAgo = startOfToday.difference(startOfDay).inDays;
    if (daysAgo <= 0) return time24(time);
    if (daysAgo == 1) return 'Yesterday';
    if (daysAgo < 7) return _weekdays[time.weekday - 1];
    return '${time.day} ${monthShort(time)}';
  }

  // "Oct"
  static String monthShort(DateTime date) => _months[date.month - 1];

  // "16:30"
  static String time24(DateTime date) =>
      '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';

  // "RWF 3,000"
  static String priceRwf(int amount) => 'RWF ${_thousandsSeparated(amount)}';

  static String _twoDigits(int value) => value.toString().padLeft(2, '0');

  static String _thousandsSeparated(int value) => value
      .toString()
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
}
