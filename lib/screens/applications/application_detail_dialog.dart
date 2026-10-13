import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/application_model.dart';
import '../../providers/portal_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/status_badge.dart';
import '../../utils/formatters.dart';

class ApplicationDetailDialog extends StatelessWidget {
  final Application application;

  const ApplicationDetailDialog({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    final portal = context.watch<PortalProvider>();
    final current = portal.applications.firstWhere(
      (a) => a.id == application.id,
      orElse: () => application,
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 720),
        child: Column(
          children: [
            // Top Header
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1B4B) : AppColors.primarySubtle,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        current.company.isNotEmpty ? current.company.substring(0, 1) : 'A',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          current.company,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${current.role} ? ${current.type}',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(status: current.status),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stage Progress Stepper
                    Text(
                      'Recruitment Stage Progression',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildStageStepper(current.status, isDark),
                    const SizedBox(height: 24),

                    // Next Action Callout Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCardSubtle : AppColors.primarySubtle,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.tips_and_updates_rounded, color: AppColors.primary, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Next Action & Candidate Recommendation',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.primaryDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  current.nextAction,
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.4,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Application Metadata
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCardSubtle : AppColors.lightBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            Icons.calendar_today_rounded,
                            'Submission Date',
                            Formatters.formatDate(current.appliedDate),
                            isDark,
                          ),
                          const Divider(height: 16),
                          _buildDetailRow(
                            Icons.monetization_on_outlined,
                            'Package / Stipend',
                            current.packageOrStipend,
                            isDark,
                          ),
                          const Divider(height: 16),
                          _buildDetailRow(
                            Icons.location_on_outlined,
                            'Work Location',
                            current.location,
                            isDark,
                          ),
                          if (current.interviewDate != null) ...[
                            const Divider(height: 16),
                            _buildDetailRow(
                              Icons.event_available_rounded,
                              'Interview Date',
                              Formatters.formatDateTime(current.interviewDate!),
                              isDark,
                            ),
                          ],
                          if (current.interviewRound != null) ...[
                            const Divider(height: 16),
                            _buildDetailRow(
                              Icons.psychology_outlined,
                              'Interview Round',
                              current.interviewRound!,
                              isDark,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // T&P Officer Notes
                    Text(
                      'Placement Cell Logs & Verified Notes',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      current.notes,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Application ID: ${current.id.toUpperCase()}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                    onPressed: () {
                      portal.withdrawApplication(current.id);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Application for ${current.company} has been withdrawn.'),
                          backgroundColor: AppColors.error,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete_outline_rounded, size: 16),
                    label: const Text('Withdraw Application'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageStepper(ApplicationStatus status, bool isDark) {
    if (status == ApplicationStatus.notSelected) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.errorLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          children: [
            Icon(Icons.cancel_rounded, color: AppColors.error, size: 20),
            SizedBox(width: 8),
            Text(
              'Status: Not Selected in Current Hiring Drive',
              style: TextStyle(
                color: Color(0xFFB91C1C),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    final stages = [
      'Applied',
      'Under Review',
      'Shortlisted',
      'Interview',
      'Selected',
    ];

    final currentStep = status.stageStep;

    return Row(
      children: List.generate(stages.length * 2 - 1, (index) {
        if (index.isOdd) {
          final stepIndex = (index ~/ 2) + 1;
          final isCompleted = currentStep > stepIndex;
          return Expanded(
            child: Container(
              height: 3,
              color: isCompleted
                  ? AppColors.primary
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
          );
        } else {
          final stepIndex = (index ~/ 2) + 1;
          final isReached = currentStep >= stepIndex;
          final isCurrent = currentStep == stepIndex;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isReached
                      ? AppColors.primary
                      : (isDark ? AppColors.darkCardSubtle : AppColors.lightBg),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isReached
                        ? AppColors.primary
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    width: isCurrent ? 3 : 1.5,
                  ),
                ),
                child: Center(
                  child: isReached && !isCurrent
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : Text(
                          '$stepIndex',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isReached ? Colors.white : AppColors.lightTextMuted,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                stages[stepIndex - 1],
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isReached ? FontWeight.w700 : FontWeight.w500,
                  color: isReached
                      ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                      : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
