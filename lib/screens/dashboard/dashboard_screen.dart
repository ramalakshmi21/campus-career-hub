import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/portal_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/metric_card.dart';
import '../../widgets/readiness_gauge.dart';
import '../../widgets/custom_card.dart';
import '../../utils/formatters.dart';
import '../../utils/responsive.dart';
import '../training/training_detail_dialog.dart';
import '../placements/placement_detail_dialog.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final portal = context.watch<PortalProvider>();
    final student = portal.student;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = Responsive.isDesktop(context);

    final upcomingTrainings = portal.trainings.take(3).toList();
    final latestPlacements = portal.placements.take(4).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 28 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Welcome & Greeting Banner
          Container(
            padding: EdgeInsets.all(isDesktop ? 28 : 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E1B4B), const Color(0xFF312E81)]
                    : [const Color(0xFF4338CA), const Color(0xFF4F46E5), const Color(0xFF6366F1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'CAMPUS PLACEMENT SEASON 2026',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Welcome back, ${student.fullName}!',
                        style: TextStyle(
                          fontSize: isDesktop ? 26 : 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${student.department} ? ${student.year} ? Roll No: ${student.studentId}',
                        style: TextStyle(
                          fontSize: isDesktop ? 14 : 12,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildHeaderBadge(
                            Icons.star_rounded,
                            'CGPA: ${student.cgpa}',
                            Colors.amber.shade300,
                          ),
                          _buildHeaderBadge(
                            Icons.check_circle_outline_rounded,
                            '${portal.registeredTrainingsCount} Registered Trainings',
                            Colors.white,
                          ),
                          _buildHeaderBadge(
                            Icons.description_outlined,
                            student.resumeName,
                            Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isDesktop) ...[
                  const SizedBox(width: 24),
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                    ),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. Metric KPI Cards (4 Cards)
          LayoutBuilder(
            builder: (context, constraints) {
              final double cardWidth = isDesktop
                  ? (constraints.maxWidth - 3 * 16) / 4
                  : (constraints.maxWidth - 16) / 2;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: MetricCard(
                      title: 'Available Trainings',
                      value: '${portal.trainingsCount}',
                      subtitle: '${portal.registeredTrainingsCount} Enrolled',
                      icon: Icons.model_training_rounded,
                      iconColor: AppColors.primary,
                      iconBgColor: AppColors.primarySubtle,
                      onTap: () => portal.setTabIndex(1),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: MetricCard(
                      title: 'Active Placement Drives',
                      value: '${portal.placementsCount}',
                      subtitle: 'Tier-1 & IT Majors',
                      icon: Icons.business_center_rounded,
                      iconColor: AppColors.secondary,
                      iconBgColor: const Color(0xFFE0F2FE),
                      onTap: () => portal.setTabIndex(2),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: MetricCard(
                      title: 'Internship Openings',
                      value: '${portal.internshipsCount}',
                      subtitle: 'Paid & Summer Roles',
                      icon: Icons.school_rounded,
                      iconColor: AppColors.tertiary,
                      iconBgColor: const Color(0xFFEDE9FE),
                      onTap: () => portal.setTabIndex(3),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: MetricCard(
                      title: 'My Applications',
                      value: '${portal.applicationsCount}',
                      subtitle: 'Active Submissions',
                      icon: Icons.assignment_turned_in_rounded,
                      iconColor: AppColors.success,
                      iconBgColor: AppColors.successLight,
                      onTap: () => portal.setTabIndex(4),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 28),

          // 3. Career Readiness Score & Quick Shortcuts Row
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: ReadinessGauge(score: portal.careerReadinessScore),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 5,
                      child: _buildQuickShortcutsCard(context, isDark),
                    ),
                  ],
                )
              : Column(
                  children: [
                    ReadinessGauge(score: portal.careerReadinessScore),
                    const SizedBox(height: 20),
                    _buildQuickShortcutsCard(context, isDark),
                  ],
                ),
          const SizedBox(height: 28),

          // 4. Latest Placement Drives
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest Placement Drives',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: () => portal.setTabIndex(2),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('View All Drives'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final double driveCardWidth = isDesktop
                  ? (constraints.maxWidth - 16) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: latestPlacements.map((drive) {
                  return SizedBox(
                    width: driveCardWidth,
                    child: CustomCard(
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => PlacementDetailDialog(placement: drive),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.primarySubtle,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    drive.company.isNotEmpty ? drive.company.substring(0, 1) : 'C',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      drive.company,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      drive.jobRole,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.successLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  Formatters.formatLPA(drive.packageLPA),
                                  style: const TextStyle(
                                    color: Color(0xFF047857),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: drive.requiredSkills.take(3).map((skill) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkCardSubtle : AppColors.lightBg,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                                  ),
                                ),
                                child: Text(
                                  skill,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 14),
                          const Divider(height: 1),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.timer_outlined, size: 14, color: AppColors.error),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Deadline: ${Formatters.formatDate(drive.deadline)}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.error,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                drive.isApplied ? 'Applied ?' : 'View Details ?',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: drive.isApplied ? AppColors.success : AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 28),

          // 5. Upcoming Trainings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Skill Trainings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: () => portal.setTabIndex(1),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('View All Trainings'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: upcomingTrainings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final training = upcomingTrainings[index];
              return CustomCard(
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => TrainingDetailDialog(training: training),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primarySubtle,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.school_outlined,
                        color: AppColors.primary,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  training.category,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                training.duration,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            training.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Instructor: ${training.trainerName} ? ${training.mode}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: training.isRegistered ? AppColors.success : AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      onPressed: () {
                        portal.toggleTrainingRegistration(training.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              training.isRegistered
                                  ? 'Unregistered from ${training.title}'
                                  : 'Successfully registered for ${training.title}!',
                            ),
                            backgroundColor: training.isRegistered ? AppColors.error : AppColors.success,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Text(
                        training.isRegistered ? 'Enrolled ?' : 'Enroll',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
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

  static Widget _buildHeaderBadge(IconData icon, String text, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildQuickShortcutsCard(BuildContext context, bool isDark) {
    final portal = context.read<PortalProvider>();
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions & Tools',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  Icons.psychology_rounded,
                  'Interview Prep',
                  '10 Modules & Q&A',
                  AppColors.primary,
                  () => portal.setTabIndex(5),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  context,
                  Icons.badge_rounded,
                  'My Profile',
                  'Edit skills & resume',
                  AppColors.secondary,
                  () => portal.setTabIndex(7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  Icons.track_changes_rounded,
                  'Applications',
                  'Stage & interviews',
                  AppColors.tertiary,
                  () => portal.setTabIndex(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  context,
                  Icons.contact_support_rounded,
                  'Placement Cell',
                  'Support & FAQs',
                  AppColors.success,
                  () => portal.setTabIndex(8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
