// lib/screens/notification_screen.dart

import 'package:flutter/material.dart';
import '../models/notification_item.dart';
import '../data/mock_data.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationItem> _notifications = List.from(mockNotifications);

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
      for (final n in mockNotifications) {
        n.isRead = true;
      }
    });
  }

  void _markRead(NotificationItem item) {
    setState(() {
      item.isRead = true;
      final index = mockNotifications.indexWhere((n) => n.id == item.id);
      if (index != -1) mockNotifications[index].isRead = true;
    });
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined,
                      size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  Text('No notifications yet',
                      style: TextStyle(color: Colors.grey[400])),
                ],
              ),
            )
          : Column(
              children: [
                if (unreadCount > 0)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    color: theme.colorScheme.primaryContainer.withOpacity(0.4),
                    child: Text(
                      '$unreadCount unread notification${unreadCount > 1 ? 's' : ''}',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.separated(
                    itemCount: _notifications.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 72),
                    itemBuilder: (context, index) {
                      final notif = _notifications[index];
                      return Dismissible(
                        key: Key(notif.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          setState(() => _notifications.removeAt(index));
                        },
                        child: ListTile(
                          onTap: () => _markRead(notif),
                          tileColor: notif.isRead
                              ? null
                              : theme.colorScheme.primaryContainer
                                  .withOpacity(0.15),
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                child: Text(
                                  notif.title.characters.first,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                              if (!notif.isRead)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          title: Text(
                            notif.title,
                            style: TextStyle(
                              fontWeight: notif.isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(notif.body,
                                  style: const TextStyle(fontSize: 13)),
                              const SizedBox(height: 2),
                              Text(
                                _timeAgo(notif.receivedAt),
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 11),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}