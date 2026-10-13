import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/portal_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/empty_state.dart';
import '../../utils/responsive.dart';

class InterviewPrepScreen extends StatefulWidget {
  const InterviewPrepScreen({super.key});

  @override
  State<InterviewPrepScreen> createState() => _InterviewPrepScreenState();
}

class _InterviewPrepScreenState extends State<InterviewPrepScreen> {
  final Set<String> _expandedQuestionIds = {};
  bool _showOnlyBookmarked = false;

  final List<String> _allCategories = [
    'All',
    'Aptitude',
    'Logical reasoning',
    'Verbal ability',
    'Programming',
    'Data Structures',
    'DBMS',
    'Operating Systems',
    'Computer Networks',
    'HR questions',
    'Resume tips',
  ];

  @override
  Widget build(BuildContext context) {
    final portal = context.watch<PortalProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = Responsive.isDesktop(context);

    final filtered = portal.interviewQuestions.where((q) {
      final matchesCat = portal.selectedPrepCategory == 'All' ||
          q.category.toLowerCase() == portal.selectedPrepCategory.toLowerCase();
      final matchesSearch = portal.searchQuery.isEmpty ||
          q.question.toLowerCase().contains(portal.searchQuery.toLowerCase()) ||
          q.answer.toLowerCase().contains(portal.searchQuery.toLowerCase()) ||
          q.tags.any((t) => t.toLowerCase().contains(portal.searchQuery.toLowerCase()));
      final matchesBookmark = !_showOnlyBookmarked || q.isBookmarked;

      return matchesCat && matchesSearch && matchesBookmark;
    }).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 28 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Interview Preparation Knowledge Base',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Curated questions and deep technical answers across 10 vital topics asked by TCS, Infosys, Deloitte, Accenture, and Microsoft.',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 20),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ..._allCategories.map((cat) {
                  final isSelected = portal.selectedPrepCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) => portal.setPrepCategory(cat),
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
                }),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: FilterChip(
                    avatar: Icon(
                      _showOnlyBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      size: 16,
                      color: _showOnlyBookmarked ? Colors.amber.shade800 : null,
                    ),
                    label: const Text('Saved Only'),
                    selected: _showOnlyBookmarked,
                    onSelected: (val) => setState(() => _showOnlyBookmarked = val),
                    selectedColor: const Color(0xFFFEF3C7),
                    labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Questions List
          if (filtered.isEmpty)
            EmptyState(
              icon: Icons.psychology_outlined,
              title: 'No Questions Found',
              message: 'Try clearing your category filter or search keywords to view all prep questions.',
              actionLabel: 'Reset Filters',
              onAction: () {
                portal.setPrepCategory('All');
                portal.setSearchQuery('');
                setState(() => _showOnlyBookmarked = false);
              },
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final q = filtered[index];
                final isExpanded = _expandedQuestionIds.contains(q.id);

                Color diffColor;
                if (q.difficulty.toLowerCase() == 'easy') {
                  diffColor = AppColors.success;
                } else if (q.difficulty.toLowerCase() == 'medium') {
                  diffColor = AppColors.warning;
                } else {
                  diffColor = AppColors.error;
                }

                return CustomCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              q.category,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: diffColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              q.difficulty,
                              style: TextStyle(
                                color: diffColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              q.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                              color: q.isBookmarked ? Colors.amber : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                              size: 20,
                            ),
                            tooltip: q.isBookmarked ? 'Remove Bookmark' : 'Save Question',
                            onPressed: () => portal.toggleBookmarkQuestion(q.id),
                          ),
                          IconButton(
                            icon: Icon(
                              isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                              size: 24,
                            ),
                            onPressed: () {
                              setState(() {
                                if (isExpanded) {
                                  _expandedQuestionIds.remove(q.id);
                                } else {
                                  _expandedQuestionIds.add(q.id);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Question Title
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (isExpanded) {
                              _expandedQuestionIds.remove(q.id);
                            } else {
                              _expandedQuestionIds.add(q.id);
                            }
                          });
                        },
                        child: Text(
                          q.question,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Tags
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: q.tags.map((t) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkCardSubtle : AppColors.lightBg,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              ),
                            ),
                            child: Text(
                              '#$t',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      // Expanded Answer
                      if (isExpanded) ...[
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 16),
                        Text(
                          'Detailed Solution & Explanation:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCardSubtle : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            ),
                          ),
                          child: SelectableText(
                            q.answer,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.6,
                              fontFamily: 'Segoe UI',
                              color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Interviewer Pro Tip
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFFCD34D)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFB45309), size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Interviewer Takeaway & Pro Tip',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFFB45309),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      q.tip,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF78350F),
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
