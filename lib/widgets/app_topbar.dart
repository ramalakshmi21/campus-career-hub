import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/portal_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';

class AppTopbar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuPressed;

  const AppTopbar({super.key, this.onMenuPressed});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final portal = context.watch<PortalProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final isMobile = Responsive.isMobile(context);

    String getTitle(int index) {
      switch (index) {
        case 0:
          return 'Dashboard Overview';
        case 1:
          return 'Training & Skill Development';
        case 2:
          return 'Placement Drives';
        case 3:
          return 'Internships';
        case 4:
          return 'My Applications';
        case 5:
          return 'Interview Preparation Hub';
        case 6:
          return 'Notifications Center';
        case 7:
          return 'Student Profile';
        case 8:
          return 'Settings & Support';
        default:
          return 'Campus Career Hub';
      }
    }

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (isMobile && onMenuPressed != null) ...[
            IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: onMenuPressed,
              tooltip: 'Navigation Menu',
            ),
            const SizedBox(width: 8),
          ],

          // Title & Active Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  getTitle(portal.selectedTabIndex),
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 19,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!isMobile)
                  Text(
                    'Campus Career Hub • Training & Placement Management',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
              ],
            ),
          ),

          // Search Field on larger screens
          if (!isMobile) ...[
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: SizedBox(
                height: 40,
                child: TextField(
                  onChanged: (val) => portal.setSearchQuery(val),
                  decoration: InputDecoration(
                    hintText: 'Search roles, skills, topics...',
                    hintStyle: const TextStyle(fontSize: 12),
                    prefixIcon: const Icon(Icons.search_rounded, size: 18),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    filled: true,
                    fillColor: isDark ? AppColors.darkCard : AppColors.lightBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
          ],

          // Dark Mode Toggle
          IconButton(
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? Colors.amber : AppColors.lightTextSecondary,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),

          const SizedBox(width: 6),

          // Notification Icon with Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                tooltip: 'Notifications',
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () => portal.setTabIndex(6),
              ),
              if (portal.unreadNotificationsCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${portal.unreadNotificationsCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 8),

          // Student CGPA pill
          if (!isMobile) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primarySubtle,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    '${portal.student.cgpa} CGPA',
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],

          // Quick profile avatar button
          InkWell(
            onTap: () => portal.setTabIndex(7),
            borderRadius: BorderRadius.circular(20),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary,
              child: Text(
                portal.student.fullName.isNotEmpty
                    ? portal.student.fullName.substring(0, 1).toUpperCase()
                    : 'A',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
