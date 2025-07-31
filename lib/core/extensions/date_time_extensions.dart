extension DateTimeExtensions on DateTime {
  bool get isToday => isSameDate(DateTime.now());
  bool get isYesterday => isSameDate(DateTime.now().subtract(Duration(days: 1)));

  bool isSameDate(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  String toReadableDate() => '$day/$month/$year';
  String toTimeOnly() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  String timeAgo() {
    final diff = DateTime.now().difference(this);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
