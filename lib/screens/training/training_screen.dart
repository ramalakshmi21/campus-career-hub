import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/portal_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/empty_state.dart';
import '../../utils/responsive.dart';
import 'training_detail_dialog.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final portal = context.watch<PortalProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = Responsive.isDesktop(context);

    final categories = [
      'All',
      'Aptitude',
      'Coding',
      'Communication',
      'Soft skills',
      'Interview preparation',
      'Resume building',
    ];

    final filteredTrainings = portal.trainings.where((t) {
      final matchesCategory = portal.selectedTrainingCategory == 'All' ||
          t.category.toLowerCase() == portal.selectedTrainingCategory.toLowerCase();
      final matchesSearch = portal.searchQuery.isEmpty ||
          t.title.toLowerCase().contains(portal.searchQuery.toLowerCase()) ||
          t.description.toLowerCase().contains(portal.searchQuery.toLowerCase()) ||
          t.trainerName.toLowerCase().contains(portal.searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 28 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Info
          Text(
            'Training & Skill Development Modules',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Master quantitative aptitude, algorithmic coding, communication, and interview skills with live campus trainers.',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 20),

          // Category Chips Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((cat) {
                final isSelected = portal.selectedTrainingCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => portal.setTrainingCategory(cat),
                    selectedColor: AppColors.primarySubtle,
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primaryDark
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Training Cards List / Grid
          if (filteredTrainings.isEmpty)
            EmptyState(
              icon: Icons.search_off_rounded,
              title: 'No Trainings Found',
              message: 'Try selecting a different category or clearing the search query.',
              actionLabel: 'Reset Filters',
              onAction: () {
                portal.setTrainingCategory('All');
                portal.setSearchQuery('');
              },
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final double cardWidth = isDesktop
                    ? (constraints.maxWidth - 16) / 2
                    : constraints.maxWidth;

                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: filteredTrainings.map((training) {
                    final progress = training.registeredCount / training.totalSeats;
                    return SizedBox(
                      width: cardWidth,
                      child: CustomCard(
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => TrainingDetailDialog(training: training),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    training.category,
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: training.isRegistered ? AppColors.successLight : AppColors.lightBg,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: training.isRegistered ? AppColors.success : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                    ),
                                  ),
                                  child: Text(
                                    training.isRegistered ? 'Enrolled ?' : training.mode,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: training.isRegistered ? const Color(0xFF047857) : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              training.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              training.description,
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.4,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 14),

                            // Instructor & Dates
                            Row(
                              children: [
                                const Icon(Icons.person_outline_rounded, size: 16, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    training.trainerName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.access_time_rounded, size: 15, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                const SizedBox(width: 4),
                                Text(
                                  training.duration,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Seats filled progress
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Seats Filled: ${training.registeredCount} / ${training.totalSeats}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                      ),
                                    ),
                                    Text(
                                      '${(progress * 100).toInt()}%',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 5,
                                    backgroundColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      progress > 0.9 ? AppColors.error : AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(height: 1),
                            const SizedBox(height: 12),

                            // Action buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (_) => TrainingDetailDialog(training: training),
                                  ),
                                  child: const Text('View Syllabus ?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: training.isRegistered ? AppColors.success : AppColors.primary,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    training.isRegistered ? 'Enrolled ?' : 'Register Now',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
        ],
      ),
    );
  }
}
