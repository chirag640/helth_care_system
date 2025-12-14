import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/notification_item_widget.dart';
import '../../controller/notification_controller.dart';

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
                          'You have ${notificationState.totalCount} Total Notifications.',
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
                  // Profile avatar
                  CircleAvatar(
                    radius: AppResponsive.s(context, 32),
                    backgroundImage: const AssetImage(
                      'assets/images/profile_avatar.png',
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
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Recent tab
                  _buildRecentTab(notificationState),
                  // Last Week tab
                  _buildLastWeekTab(notificationState),
                ],
              ),
            ),
          ],
        ),
      ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today (${state.todayNotifications.length})',
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
            ),
            SizedBox(height: AppResponsive.p(context, 12)),
            ...state.todayNotifications.map(
              (notification) => NotificationItemWidget(
                icon: notification.icon,
                iconColor: notification.iconColor,
                title: notification.title,
                message: notification.message,
                time: notification.time,
                onTap: () {},
              ),
            ),
          ],

          SizedBox(height: AppResponsive.p(context, 16)),

          // Past section
          if (state.pastNotifications.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Past (${state.pastNotifications.length})',
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
            ),
            SizedBox(height: AppResponsive.p(context, 12)),
            ...state.pastNotifications.map(
              (notification) => NotificationItemWidget(
                icon: notification.icon,
                iconColor: notification.iconColor,
                title: notification.title,
                message: notification.message,
                time: notification.time,
                onTap: () {},
              ),
            ),
          ],
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
          if (state.lastWeekNotifications.isNotEmpty)
            ...state.lastWeekNotifications.map(
              (notification) => NotificationItemWidget(
                icon: notification.icon,
                iconColor: notification.iconColor,
                title: notification.title,
                message: notification.message,
                time: notification.time,
                onTap: () {},
              ),
            )
          else
            Center(
              child: Padding(
                padding: EdgeInsets.all(AppResponsive.p(context, 32)),
                child: Text(
                  'No notifications from last week',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: AppResponsive.fontSize(context, 14)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
