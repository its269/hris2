import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  final bool showAppBar;

  const NotificationsPage({super.key, this.showAppBar = true});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<NotificationItem> allNotifications = [];
  List<NotificationItem> unreadNotifications = [];
  List<NotificationItem> readNotifications = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeNotifications() {
    allNotifications = [
      NotificationItem(
        id: '1',
        title: 'System Update',
        message: 'HRIS system will be updated tonight at 11:00 PM',
        icon: Icons.system_update,
        color: Colors.blue,
        time: '2 hours ago',
        type: NotificationType.system,
        isRead: false,
        priority: NotificationPriority.high,
      ),
      NotificationItem(
        id: '2',
        title: 'Attendance Reminder',
        message: 'Don\'t forget to check in when you arrive at work',
        icon: Icons.access_time,
        color: Colors.orange,
        time: '1 day ago',
        type: NotificationType.reminder,
        isRead: false,
        priority: NotificationPriority.medium,
      ),
      NotificationItem(
        id: '3',
        title: 'Policy Update',
        message: 'New remote work policy has been published',
        icon: Icons.policy,
        color: Colors.green,
        time: '3 days ago',
        type: NotificationType.policy,
        isRead: true,
        priority: NotificationPriority.medium,
      ),
      NotificationItem(
        id: '4',
        title: 'Training Reminder',
        message: 'Complete your mandatory safety training by Friday',
        icon: Icons.school,
        color: Colors.purple,
        time: '5 days ago',
        type: NotificationType.training,
        isRead: false,
        priority: NotificationPriority.high,
      ),
      NotificationItem(
        id: '5',
        title: 'Team Birthday',
        message: 'It\'s Sarah\'s birthday today! Wish her well.',
        icon: Icons.cake,
        color: Colors.pink,
        time: '1 week ago',
        type: NotificationType.social,
        isRead: true,
        priority: NotificationPriority.low,
      ),
      NotificationItem(
        id: '6',
        title: 'IT Support',
        message: 'Password reset link has been sent to your email',
        icon: Icons.support,
        color: Colors.teal,
        time: '1 week ago',
        type: NotificationType.support,
        isRead: true,
        priority: NotificationPriority.medium,
      ),
    ];

    _updateNotificationLists();
  }

  void _updateNotificationLists() {
    unreadNotifications = allNotifications.where((n) => !n.isRead).toList();
    readNotifications = allNotifications.where((n) => n.isRead).toList();
  }

  void _markAsRead(String notificationId) {
    setState(() {
      final notification = allNotifications.firstWhere(
        (n) => n.id == notificationId,
      );
      notification.isRead = true;
      _updateNotificationLists();
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in allNotifications) {
        notification.isRead = true;
      }
      _updateNotificationLists();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget body = Column(
      children: [
        // Header with actions
        Container(
          color: colorScheme.surface,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!widget.showAppBar) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.notifications,
                            color: colorScheme.primary,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Notifications',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    Text(
                      '${unreadNotifications.length} unread notification${unreadNotifications.length != 1 ? 's' : ''}',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (unreadNotifications.isNotEmpty)
                TextButton.icon(
                  onPressed: _markAllAsRead,
                  icon: Icon(
                    Icons.done_all,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  label: Text(
                    'Mark all read',
                    style: TextStyle(color: colorScheme.primary),
                  ),
                ),
            ],
          ),
        ),

        // Tab bar
        Container(
          color: colorScheme.surface,
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('All'),
                    if (allNotifications.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${allNotifications.length}',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Unread'),
                    if (unreadNotifications.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${unreadNotifications.length}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Read'),
                    if (readNotifications.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${readNotifications.length}',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            indicatorColor: colorScheme.primary,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurfaceVariant,
          ),
        ),

        // Tab views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildNotificationList(allNotifications),
              _buildNotificationList(unreadNotifications),
              _buildNotificationList(readNotifications),
            ],
          ),
        ),
      ],
    );

    if (widget.showAppBar) {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(
                Icons.notifications,
                color: colorScheme.onPrimaryContainer,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text('Notifications'),
            ],
          ),
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          actions: [
            if (unreadNotifications.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Badge(
                  label: Text('${unreadNotifications.length}'),
                  child: Icon(
                    Icons.notifications_active,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset(
                'assets/kelin.png',
                height: 32,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ],
        ),
        body: body,
      );
    } else {
      return body;
    }
  }

  Widget _buildNotificationList(List<NotificationItem> notifications) {
    final colorScheme = Theme.of(context).colorScheme;

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 64,
              color: colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications here',
              style: TextStyle(
                fontSize: 18,
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re all caught up!',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return _buildNotificationCard(notifications[index]);
      },
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: notification.isRead ? 1 : 3,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:
            notification.priority == NotificationPriority.high &&
                !notification.isRead
            ? BorderSide(color: Colors.red.withOpacity(0.3), width: 1)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () {
          if (!notification.isRead) {
            _markAsRead(notification.id);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opened: ${notification.title}'),
              backgroundColor: notification.color,
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon with priority indicator
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: notification.color.withOpacity(
                        notification.isRead ? 0.1 : 0.2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      notification.icon,
                      color: notification.color,
                      size: 24,
                    ),
                  ),
                  if (notification.priority == NotificationPriority.high &&
                      !notification.isRead)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                              fontSize: 16,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: notification.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification.message,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: notification.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _getTypeLabel(notification.type),
                            style: TextStyle(
                              color: notification.color,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          notification.time,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant.withOpacity(
                              0.7,
                            ),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTypeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.system:
        return 'System';
      case NotificationType.reminder:
        return 'Reminder';
      case NotificationType.policy:
        return 'Policy';
      case NotificationType.training:
        return 'Training';
      case NotificationType.social:
        return 'Social';
      case NotificationType.support:
        return 'Support';
    }
  }
}

// Models
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final String time;
  final NotificationType type;
  bool isRead;
  final NotificationPriority priority;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    required this.time,
    required this.type,
    required this.isRead,
    required this.priority,
  });
}

enum NotificationType { system, reminder, policy, training, social, support }

enum NotificationPriority { low, medium, high }
