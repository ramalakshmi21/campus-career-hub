import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/notification_model.dart';
import '../../providers/portal_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/empty_state.dart';
import '../../utils/responsive.dart';
import '../../utils/formatters.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final portal = context.watch<PortalProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = Responsive.isDesktop(context);

    final filtered = portal.notifications.where((n) {
      if (_selectedFilter == 'Unread Only') {
        return !n.isRead;
      }
      return true;
    }).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 28 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Campus Placement Alerts & Notices',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Official broadcasts, drive announcements, interview schedules, and training reminders.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
              if (portal.unreadNotificationsCount > 0)
                ElevatedButton.icon(
                  onPressed: () => portal.markAllNotificationsAsRead(),
                  icon: const Icon(Icons.done_all_rounded, size: 16),
                  label: const Text('Mark All as Read'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Filter bar
          Row(
            children: [
              FilterChip(
                label: const Text('All Notifications'),
                selected: _selectedFilter == 'All',
                onSelected: (_) => setState(() => _selectedFilter = 'All'),
                selectedColor: AppColors.primarySubtle,
                checkmarkColor: AppColors.primary,
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: Text('Unread (${portal.unreadNotificationsCount})'),
                selected: _selectedFilter == 'Unread Only',
                onSelected: (_) => setState(() => _selectedFilter = 'Unread Only'),
                selectedColor: AppColors.primarySubtle,
                checkmarkColor: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Notification List
          if (filtered.isEmpty)
            EmptyState(
              icon: Icons.notifications_none_rounded,
              title: 'No Notifications Found',
              message: _selectedFilter == 'Unread Only'
                  ? 'All notifications have been read. You\'re all caught up!'
                  : 'You have no notices in your inbox.',
              actionLabel: _selectedFilter == 'Unread Only' ? 'View All' : null,
              onAction: () => setState(() => _selectedFilter = 'All'),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final notif = filtered[index];

                IconData icon;
                Color color;
                switch (notif.category) {
                  case NotificationCategory.interview:
                    icon = Icons.event_available_rounded;
                    color = AppColors.primary;
                    break;
                  case NotificationCategory.shortlist:
                    icon = Icons.thumb_up_alt_rounded;
                    color = AppColors.tertiary;
                    break;
                  case NotificationCategory.training:
                    icon = Icons.school_rounded;
                    color = AppColors.secondary;
                    break;
                  case NotificationCategory.placement:
                    icon = Icons.business_center_rounded;
                    color = AppColors.success;
                    break;
                  case NotificationCategory.internship:
                    icon = Icons.work_outline_rounded;
                    color = const Color(0xFF0284C7);
                    break;
                  case NotificationCategory.deadline:
                    icon = Icons.warning_amber_rounded;
                    color = AppColors.error;
                    break;
                }

                return CustomCard(
                  padding: const EdgeInsets.all(16),
                  onTap: () {
                    portal.markNotificationAsRead(notif.id);
                    if (notif.actionRoute != null) {
                      if (notif.actionRoute == 'applications') {
                        portal.setTabIndex(4);
                      } else if (notif.actionRoute == 'training') {
                        portal.setTabIndex(1);
                      } else if (notif.actionRoute == 'placements') {
                        portal.setTabIndex(2);
                      } else if (notif.actionRoute == 'internships') {
                        portal.setTabIndex(3);
                      }
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: isDark ? 0.2 : 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 22),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    notif.title,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.w800,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                ),
                                if (!notif.isRead) ...[
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Text(
                                  Formatters.formatDateTime(notif.timestamp),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              notif.message,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 18),
                        tooltip: 'Dismiss Notice',
                        onPressed: () => portal.deleteNotification(notif.id),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
