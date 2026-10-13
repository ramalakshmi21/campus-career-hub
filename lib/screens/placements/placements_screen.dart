import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/portal_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/empty_state.dart';
import '../../utils/responsive.dart';
import '../../utils/formatters.dart';
import 'placement_detail_dialog.dart';

class PlacementsScreen extends StatefulWidget {
  const PlacementsScreen({super.key});

  @override
  State<PlacementsScreen> createState() => _PlacementsScreenState();
}

class _PlacementsScreenState extends State<PlacementsScreen> {
  double _minPackageFilter = 0;
  String _selectedLocation = 'All';

  @override
  Widget build(BuildContext context) {
    final portal = context.watch<PortalProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = Responsive.isDesktop(context);

    final locations = ['All', 'Bangalore', 'Hyderabad', 'Pune', 'Mumbai', 'Chennai'];

    final filtered = portal.placements.where((p) {
      final matchesSearch = portal.searchQuery.isEmpty ||
          p.company.toLowerCase().contains(portal.searchQuery.toLowerCase()) ||
          p.jobRole.toLowerCase().contains(portal.searchQuery.toLowerCase()) ||
          p.requiredSkills.any((s) => s.toLowerCase().contains(portal.searchQuery.toLowerCase()));
      final matchesPackage = p.packageLPA >= _minPackageFilter;
      final matchesLocation = _selectedLocation == 'All' ||
          p.location.toLowerCase().contains(_selectedLocation.toLowerCase());
      return matchesSearch && matchesPackage && matchesLocation;
    }).toList();

    if (portal.selectedPlacementSort == 'Package: High to Low') {
      filtered.sort((a, b) => b.packageLPA.compareTo(a.packageLPA));
    } else if (portal.selectedPlacementSort == 'Deadline: Soonest') {
      filtered.sort((a, b) => a.deadline.compareTo(b.deadline));
    } else if (portal.selectedPlacementSort == 'Company: A-Z') {
      filtered.sort((a, b) => a.company.compareTo(b.company));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 28 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Campus Placement Drives 2026',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Explore campus recruitment drives from top technology and consulting firms with one-click applications.',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 20),

          // Filters & Sort Bar
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
              runSpacing: 14,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on_outlined, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _selectedLocation,
                      underline: const SizedBox(),
                      dropdownColor: isDark ? AppColors.darkCard : Colors.white,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                      items: locations.map((loc) {
                        return DropdownMenuItem(value: loc, child: Text('Location: $loc'));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedLocation = val);
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.payments_outlined, size: 18, color: AppColors.success),
                    const SizedBox(width: 8),
                    DropdownButton<double>(
                      value: _minPackageFilter,
                      underline: const SizedBox(),
                      dropdownColor: isDark ? AppColors.darkCard : Colors.white,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                      items: const [
                        DropdownMenuItem(value: 0.0, child: Text('All CTC Packages')),
                        DropdownMenuItem(value: 7.0, child: Text('Min ?7.0 LPA')),
                        DropdownMenuItem(value: 9.0, child: Text('Min ?9.0 LPA')),
                        DropdownMenuItem(value: 15.0, child: Text('Min ?15.0 LPA (Dream)')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _minPackageFilter = val);
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sort_rounded, size: 18, color: AppColors.secondary),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: portal.selectedPlacementSort,
                      underline: const SizedBox(),
                      dropdownColor: isDark ? AppColors.darkCard : Colors.white,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Default', child: Text('Sort: Default')),
                        DropdownMenuItem(value: 'Package: High to Low', child: Text('Sort: Package (High to Low)')),
                        DropdownMenuItem(value: 'Deadline: Soonest', child: Text('Sort: Deadline (Soonest)')),
                        DropdownMenuItem(value: 'Company: A-Z', child: Text('Sort: Company Name')),
                      ],
                      onChanged: (val) {
                        if (val != null) portal.setPlacementSort(val);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          if (filtered.isEmpty)
            EmptyState(
              icon: Icons.business_center_outlined,
              title: 'No Placement Drives Found',
              message: 'Try changing your location filter, decreasing the minimum package, or clearing your search term.',
              actionLabel: 'Reset Filters',
              onAction: () {
                setState(() {
                  _minPackageFilter = 0;
                  _selectedLocation = 'All';
                });
                portal.setPlacementSort('Default');
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
                  children: filtered.map((drive) {
                    final isEligible = portal.student.cgpa >= drive.minCgpa;

                    return SizedBox(
                      width: cardWidth,
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
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.primarySubtle,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      drive.company.isNotEmpty ? drive.company.substring(0, 1) : 'C',
                                      style: const TextStyle(
                                        color: AppColors.primary,
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
                                        drive.company,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
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
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 15, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    drive.location,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  isEligible ? Icons.verified_rounded : Icons.info_outline_rounded,
                                  size: 15,
                                  color: isEligible ? AppColors.success : AppColors.warning,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Min ${drive.minCgpa} CGPA',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isEligible ? AppColors.success : AppColors.warning,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: drive.requiredSkills.map((s) {
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
                                      'Deadline: ${Formatters.formatDate(drive.deadline)}',
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
                                        builder: (_) => PlacementDetailDialog(placement: drive),
                                      ),
                                      child: const Text('Details ?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                    ),
                                    const SizedBox(width: 6),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: drive.isApplied ? AppColors.success : AppColors.primary,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                      ),
                                      onPressed: drive.isApplied
                                          ? null
                                          : () {
                                              final success = portal.applyForPlacement(drive);
                                              if (success) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Applied to ${drive.company}!'),
                                                    backgroundColor: AppColors.success,
                                                    behavior: SnackBarBehavior.floating,
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('You have already applied to this drive.'),
                                                    backgroundColor: AppColors.warning,
                                                    behavior: SnackBarBehavior.floating,
                                                  ),
                                                );
                                              }
                                            },
                                      child: Text(
                                        drive.isApplied ? 'Applied ?' : 'Apply',
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
