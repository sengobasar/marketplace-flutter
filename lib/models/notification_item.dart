// lib/models/notification_item.dart

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime receivedAt;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
    this.isRead = false,
  });
}