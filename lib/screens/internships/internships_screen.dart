import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/portal_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/empty_state.dart';
import '../../utils/responsive.dart';
import '../../utils/formatters.dart';
import 'internship_detail_dialog.dart';

class InternshipsScreen extends StatefulWidget {
  const InternshipsScreen({super.key});

  @override
  State<InternshipsScreen> createState() => _InternshipsScreenState();
}

class _InternshipsScreenState extends State<InternshipsScreen> {
  String _paidFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final portal = context.watch<PortalProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = Responsive.isDesktop(context);

    final filtered = portal.internships.where((i) {
      final matchesSearch = portal.searchQuery.isEmpty ||
          i.company.toLowerCase().contains(portal.searchQuery.toLowerCase()) ||
          i.role.toLowerCase().contains(portal.searchQuery.toLowerCase()) ||
          i.location.toLowerCase().contains(portal.searchQuery.toLowerCase()) ||
          i.requiredSkills.any((s) => s.toLowerCase().contains(portal.searchQuery.toLowerCase()));

      final matchesPaid = _paidFilter == 'All' ||
          (_paidFilter == 'Paid Only' && i.isPaid) ||
          (_paidFilter == 'Unpaid' && !i.isPaid);

      return matchesSearch && matchesPaid;
    }).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 28 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Internship & Project Opportunities',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Gain hands-on corporate experience, earn competitive monthly stipends, and secure early Pre-Placement Offers (PPOs).',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 20),

          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.filter_alt_outlined, size: 18, color: AppColors.secondary),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _paidFilter,
                      underline: const SizedBox(),
                      dropdownColor: isDark ? AppColors.darkCard : Colors.white,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                      items: const [
                        DropdownMenuItem(value: 'All', child: Text('All Types (Paid & Unpaid)')),
                        DropdownMenuItem(value: 'Paid Only', child: Text('Paid Stipend Roles Only')),
                        DropdownMenuItem(value: 'Unpaid', child: Text('Credit-based / Unpaid')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _paidFilter = val);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Internships Cards
          if (filtered.isEmpty)
            EmptyState(
              icon: Icons.school_outlined,
              title: 'No Internships Found',
              message: 'Try clearing your filter or searching for another keyword.',
              actionLabel: 'Reset Filters',
              onAction: () {
                setState(() => _paidFilter = 'All');
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
                  children: filtered.map((internship) {
                    return SizedBox(
                      width: cardWidth,
                      child: CustomCard(
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => InternshipDetailDialog(internship: internship),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEDE9FE),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      internship.company.isNotEmpty ? internship.company.substring(0, 1) : 'I',
                                      style: const TextStyle(
                                        color: AppColors.tertiary,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20,
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
                                        internship.company,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        internship.role,
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
                                    color: const Color(0xFFEDE9FE),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    Formatters.formatStipend(internship.stipendMonthly),
                                    style: const TextStyle(
                                      color: AppColors.tertiary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                const Icon(Icons.schedule_rounded, size: 15, color: AppColors.secondary),
                                const SizedBox(width: 4),
                                Text(
                                  internship.duration,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(Icons.location_on_outlined, size: 15, color: AppColors.secondary),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    internship.location,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: internship.requiredSkills.map((s) {
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
                                    s,
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
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.timer_outlined, size: 14, color: AppColors.error),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Deadline: ${Formatters.formatDate(internship.deadline)}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.error,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () => showDialog(
                                        context: context,
                                        builder: (_) => InternshipDetailDialog(internship: internship),
                                      ),
                                      child: const Text('Details ?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                    ),
                                    const SizedBox(width: 6),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: internship.isApplied ? AppColors.success : AppColors.secondary,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                      ),
                                      onPressed: internship.isApplied
                                          ? null
                                          : () {
                                              final success = portal.applyForInternship(internship);
                                              if (success) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Applied to ${internship.company}!'),
                                                    backgroundColor: AppColors.success,
                                                    behavior: SnackBarBehavior.floating,
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('You have already applied for this internship.'),
                                                    backgroundColor: AppColors.warning,
                                                    behavior: SnackBarBehavior.floating,
                                                  ),
                                                );
                                              }
                                            },
                                      child: Text(
                                        internship.isApplied ? 'Applied ?' : 'Apply',
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
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
