import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../controller/notification_controller.dart';
import '../../models/models.dart';

/// Notifications page with recent and last week tabs
class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
            size: AppResponsive.icon(context, 24),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Notifications',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: AppResponsive.fontSize(context, 18)),
        ),
        actions: [
          if (notificationState.hasUnread)
            IconButton(
              icon: Icon(
                Icons.done_all,
                color: AppColors.primary,
                size: AppResponsive.icon(context, 24),
              ),
              onPressed: () {
                ref
                    .read(notificationControllerProvider.notifier)
                    .markAllAsRead();
              },
              tooltip: 'Mark all as read',
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Header with profile and total count
            Container(
              color: AppColors.white,
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.p(context, 16),
                vertical: AppResponsive.p(context, 20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notifications',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  fontSize:
                                      AppResponsive.fontSize(context, 24)),
                        ),
                        SizedBox(height: AppResponsive.p(context, 4)),
                        Text(
                          _getSubtitleText(notificationState),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontSize:
                                      AppResponsive.fontSize(context, 14)),
                        ),
                      ],
                    ),
                  ),
                  // Unread badge
                  if (notificationState.unreadCount > 0)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppResponsive.p(context, 12),
                        vertical: AppResponsive.p(context, 6),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(
                          AppResponsive.radius(context, 16),
                        ),
                      ),
                      child: Text(
                        '${notificationState.unreadCount} unread',
                        style: TextStyle(
                          fontSize: AppResponsive.fontSize(context, 12),
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Tab bar
            Container(
              color: AppColors.white,
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.notificationTabIndicator,
                indicatorWeight: AppResponsive.thickness(context, 3),
                labelColor: AppColors.notificationTabTextActive,
                unselectedLabelColor: AppColors.notificationTabText,
                labelStyle: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontSize: AppResponsive.fontSize(context, 16)),
                unselectedLabelStyle: TextStyle(
                  fontSize: AppResponsive.fontSize(context, 16),
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(text: 'Recent'),
                  Tab(text: 'Last Week'),
                ],
              ),
            ),

            // Tab views
            Expanded(
              child: _buildContent(notificationState),
            ),
          ],
        ),
      ),
    );
  }

  String _getSubtitleText(NotificationState state) {
    if (state.isLoading) {
      return 'Loading notifications...';
    }
    if (state.error != null) {
      return 'Error loading notifications';
    }
    return 'You have ${state.totalCount} Total Notifications.';
  }

  Widget _buildContent(NotificationState state) {
    // Show loading state
    if (state.isLoading && state.notifications.isEmpty) {
      return const Center(child: LoadingIndicator());
    }

    // Show error state
    if (state.error != null && state.notifications.isEmpty) {
      return Center(
        child: ErrorDisplay(
          message: state.error!,
          onRetry: () => ref
              .read(notificationControllerProvider.notifier)
              .loadNotifications(),
        ),
      );
    }

    return TabBarView(
      controller: _tabController,
      children: [
        // Recent tab (today + this week)
        _buildRecentTab(state),
        // Last Week tab (older)
        _buildLastWeekTab(state),
      ],
    );
  }

  Widget _buildRecentTab(NotificationState state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppResponsive.p(context, 16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Today section
          if (state.todayNotifications.isNotEmpty) ...[
            _buildSectionHeader('Today', state.todayNotifications.length),
            SizedBox(height: AppResponsive.p(context, 12)),
            ...state.todayNotifications.map(
              (notification) => _NotificationItemWidget(
                notification: notification,
                onTap: () => _onNotificationTap(notification),
                onDismiss: () => _onNotificationDismiss(notification),
              ),
            ),
          ],

          SizedBox(height: AppResponsive.p(context, 16)),

          // This Week section
          if (state.thisWeekNotifications.isNotEmpty) ...[
            _buildSectionHeader(
                'This Week', state.thisWeekNotifications.length),
            SizedBox(height: AppResponsive.p(context, 12)),
            ...state.thisWeekNotifications.map(
              (notification) => _NotificationItemWidget(
                notification: notification,
                onTap: () => _onNotificationTap(notification),
                onDismiss: () => _onNotificationDismiss(notification),
              ),
            ),
          ],

          // Empty state for recent
          if (state.todayNotifications.isEmpty &&
              state.thisWeekNotifications.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(AppResponsive.p(context, 32)),
                child: const EmptyState(
                  icon: Icons.notifications_none,
                  title: 'No recent notifications',
                  message: 'You\'re all caught up!',
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLastWeekTab(NotificationState state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppResponsive.p(context, 16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.olderNotifications.isNotEmpty)
            ...state.olderNotifications.map(
              (notification) => _NotificationItemWidget(
                notification: notification,
                onTap: () => _onNotificationTap(notification),
                onDismiss: () => _onNotificationDismiss(notification),
              ),
            )
          else
            Center(
              child: Padding(
                padding: EdgeInsets.all(AppResponsive.p(context, 32)),
                child: const EmptyState(
                  icon: Icons.history,
                  title: 'No older notifications',
                  message: 'Notifications older than a week appear here',
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$title ($count)',
          style: TextStyle(
            fontSize: AppResponsive.fontSize(context, 16),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Icon(
          Icons.more_vert,
          size: AppResponsive.icon(context, 20),
          color: AppColors.textSecondary,
        ),
      ],
    );
  }

  void _onNotificationTap(NotificationModel notification) {
    // Mark as read
    if (!notification.isRead) {
      ref
          .read(notificationControllerProvider.notifier)
          .markAsRead(notification.id);
    }

    // Navigate based on notification type/action URL
    if (notification.actionUrl != null) {
      // Handle action URL navigation
      // Navigator.pushNamed(context, notification.actionUrl!);
    }
  }

  void _onNotificationDismiss(NotificationModel notification) {
    ref
        .read(notificationControllerProvider.notifier)
        .deleteNotification(notification.id);
  }
}

/// Notification item widget that displays a single notification
class _NotificationItemWidget extends StatelessWidget {
  const _NotificationItemWidget({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final displayData = _NotificationDisplayData.fromNotification(notification);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: AppResponsive.p(context, 16)),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: AppColors.white,
          size: AppResponsive.icon(context, 24),
        ),
      ),
      onDismissed: (_) => onDismiss(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: AppResponsive.p(context, 12)),
          padding: EdgeInsets.all(AppResponsive.p(context, 16)),
          decoration: BoxDecoration(
            color: notification.isRead
                ? AppColors.white
                : AppColors.notificationUnreadBackground,
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, 12),
            ),
            border: Border.all(
              color: AppColors.notificationBorder,
              width: 1,
            ),
            boxShadow: notification.isRead
                ? null
                : [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon container
              Container(
                width: AppResponsive.s(context, 48),
                height: AppResponsive.s(context, 48),
                decoration: BoxDecoration(
                  color: displayData.iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(
                    AppResponsive.radius(context, 12),
                  ),
                ),
                child: Icon(
                  displayData.icon,
                  color: displayData.iconColor,
                  size: AppResponsive.icon(context, 24),
                ),
              ),
              SizedBox(width: AppResponsive.p(context, 12)),
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
                              fontSize: AppResponsive.fontSize(context, 15),
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: AppResponsive.s(context, 8),
                            height: AppResponsive.s(context, 8),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: AppResponsive.p(context, 4)),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 13),
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppResponsive.p(context, 8)),
                    Text(
                      displayData.timeAgo,
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 12),
                        color: AppColors.textTertiary,
                      ),
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
}

/// Helper class to get display data from NotificationModel
class _NotificationDisplayData {
  const _NotificationDisplayData({
    required this.icon,
    required this.iconColor,
    required this.timeAgo,
  });

  factory _NotificationDisplayData.fromNotification(
      NotificationModel notification) {
    return _NotificationDisplayData(
      icon: _getIconForType(notification.type),
      iconColor: _getColorForType(notification.type, notification.priority),
      timeAgo: _formatTimeAgo(notification.createdAt),
    );
  }

  final IconData icon;
  final Color iconColor;
  final String timeAgo;

  static IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.appointmentReminder:
        return Icons.alarm;
      case NotificationType.appointmentConfirmed:
        return Icons.check_circle;
      case NotificationType.appointmentCancelled:
        return Icons.cancel;
      case NotificationType.appointmentRescheduled:
        return Icons.update;
      case NotificationType.prescriptionReady:
        return Icons.medication;
      case NotificationType.labResultReady:
        return Icons.science;
      case NotificationType.paymentReceived:
        return Icons.payment;
      case NotificationType.paymentDue:
        return Icons.attach_money;
      case NotificationType.documentUploaded:
        return Icons.upload_file;
      case NotificationType.messageReceived:
        return Icons.message;
      case NotificationType.telemedicineStart:
        return Icons.video_call;
      case NotificationType.general:
        return Icons.notifications;
      case NotificationType.system:
        return Icons.settings;
    }
  }

  static Color _getColorForType(
      NotificationType type, NotificationPriority priority) {
    // First check priority for urgent notifications
    if (priority == NotificationPriority.urgent) {
      return Colors.red;
    }
    if (priority == NotificationPriority.high) {
      return Colors.orange;
    }

    // Then use type-specific colors
    switch (type) {
      case NotificationType.appointmentReminder:
        return Colors.blue;
      case NotificationType.appointmentConfirmed:
        return Colors.green;
      case NotificationType.appointmentCancelled:
        return Colors.red;
      case NotificationType.appointmentRescheduled:
        return Colors.orange;
      case NotificationType.prescriptionReady:
        return Colors.teal;
      case NotificationType.labResultReady:
        return Colors.purple;
      case NotificationType.paymentReceived:
        return Colors.green;
      case NotificationType.paymentDue:
        return Colors.orange;
      case NotificationType.documentUploaded:
        return Colors.blue;
      case NotificationType.messageReceived:
        return Colors.indigo;
      case NotificationType.telemedicineStart:
        return Colors.cyan;
      case NotificationType.general:
        return Colors.grey;
      case NotificationType.system:
        return Colors.blueGrey;
    }
  }

  static String _formatTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    }
  }
}
