import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_card.dart';
import '../../utils/app_constants.dart';
import '../../utils/responsive.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _emailAlerts = true;
  bool _interviewReminders = true;
  bool _shareProfileWithRecruiters = true;
  bool _anonymizeSalaryPreferences = false;

  void _showFeedbackDialog() {
    final feedbackCtrl = TextEditingController();
    int rating = 5;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(Icons.feedback_rounded, color: AppColors.primary),
              SizedBox(width: 8),
              Text('Placement Cell Feedback', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How was your campus drive and portal experience? Your rating directly guides our corporate training programs.',
                style: TextStyle(fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star_rounded : Icons.star_border_rounded,
                      color: Colors.amber,
                      size: 28,
                    ),
                    onPressed: () => setDialogState(() => rating = index + 1),
                  );
                }),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: feedbackCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Share your thoughts, suggestions, or interviewer feedback...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thank you! Your feedback has been logged with the Placement Cell.'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final isDesktop = Responsive.isDesktop(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 28 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings & Placement Cell Support',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Customize appearance, manage communications, review FAQs, or contact the Training & Placement Office.',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
          ),
          const SizedBox(height: 24),

          // Settings Grid / Columns
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildAppearanceCard(themeProvider, isDark),
                          const SizedBox(height: 20),
                          _buildNotificationPreferencesCard(isDark),
                          const SizedBox(height: 20),
                          _buildPrivacyCard(isDark),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        children: [
                          _buildContactTpoCard(isDark),
                          const SizedBox(height: 20),
                          _buildFaqCard(isDark),
                          const SizedBox(height: 20),
                          _buildAccountAndLogoutCard(context, isDark),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _buildAppearanceCard(themeProvider, isDark),
                    const SizedBox(height: 20),
                    _buildNotificationPreferencesCard(isDark),
                    const SizedBox(height: 20),
                    _buildPrivacyCard(isDark),
                    const SizedBox(height: 20),
                    _buildContactTpoCard(isDark),
                    const SizedBox(height: 20),
                    _buildFaqCard(isDark),
                    const SizedBox(height: 20),
                    _buildAccountAndLogoutCard(context, isDark),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildAppearanceCard(ThemeProvider themeProvider, bool isDark) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.palette_outlined, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Text(
                'Interface & Appearance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Dark Mode', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            subtitle: const Text('Dark blue slate palette engineered for low eye strain', style: TextStyle(fontSize: 12)),
            value: isDark,
            activeThumbColor: AppColors.primary,
            onChanged: (val) => themeProvider.toggleTheme(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationPreferencesCard(bool isDark) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.notifications_active_outlined, color: AppColors.secondary, size: 22),
              const SizedBox(width: 10),
              Text(
                'Notification Preferences',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Drive & Shortlist Email Alerts', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            subtitle: const Text('Receive instant emails when new tier-1 drives are launched', style: TextStyle(fontSize: 12)),
            value: _emailAlerts,
            activeThumbColor: AppColors.primary,
            onChanged: (val) => setState(() => _emailAlerts = val),
          ),
          const Divider(height: 1),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('SMS / WhatsApp Interview Reminders', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            subtitle: const Text('Automated calendar reminders 24h before interviews', style: TextStyle(fontSize: 12)),
            value: _interviewReminders,
            activeThumbColor: AppColors.primary,
            onChanged: (val) => setState(() => _interviewReminders = val),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyCard(bool isDark) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.security_rounded, color: AppColors.tertiary, size: 22),
              const SizedBox(width: 10),
              Text(
                'Privacy & Data Permissions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Visible to Visiting Corporate Panels', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            subtitle: const Text('Allow recruiters to discover your resume in database scans', style: TextStyle(fontSize: 12)),
            value: _shareProfileWithRecruiters,
            activeThumbColor: AppColors.primary,
            onChanged: (val) => setState(() => _shareProfileWithRecruiters = val),
          ),
          const Divider(height: 1),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Anonymize Profile for Statistical Reports', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            subtitle: const Text('Hide personal name in annual college placement brochures', style: TextStyle(fontSize: 12)),
            value: _anonymizeSalaryPreferences,
            activeThumbColor: AppColors.primary,
            onChanged: (val) => setState(() => _anonymizeSalaryPreferences = val),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTpoCard(bool isDark) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.headset_mic_rounded, color: AppColors.success, size: 22),
              const SizedBox(width: 10),
              Text(
                'Contact Placement Cell',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            AppConstants.tpoName,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          Text(
            AppConstants.tpoRole,
            style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          _buildTpoInfoRow(Icons.email_outlined, AppConstants.tpoEmail, isDark),
          const SizedBox(height: 8),
          _buildTpoInfoRow(Icons.phone_outlined, AppConstants.tpoPhone, isDark),
          const SizedBox(height: 8),
          _buildTpoInfoRow(Icons.location_on_outlined, AppConstants.tpoOffice, isDark),
          const SizedBox(height: 8),
          _buildTpoInfoRow(Icons.access_time_rounded, AppConstants.officeHours, isDark),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _showFeedbackDialog,
                  icon: const Icon(Icons.rate_review_outlined, size: 16),
                  label: const Text('Give Feedback'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTpoInfoRow(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFaqCard(bool isDark) {
    final faqs = [
      {
        'q': 'What is the "One Student, One Job" campus placement policy?',
        'a': 'Once a student secures an offer equal to or above ?6.0 LPA, they are considered placed. However, students may appear for "Dream Drives" (offers > 2x their current CTC) if academic eligibility criteria are met.',
      },
      {
        'q': 'Can backlogs prevent eligibility for placement drives?',
        'a': 'Most tier-1 IT firms (TCS, Infosys, Deloitte) mandate zero active standing arrears at the time of the online assessment and interview.',
      },
      {
        'q': 'How do I download my official Placement NOC for internships?',
        'a': 'Submit your company offer letter to the TPO desk. An automated No-Objection Certificate (NOC) will be issued within 48 hours for 6-month internships.',
      },
    ];

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.help_outline_rounded, color: AppColors.warning, size: 22),
              const SizedBox(width: 10),
              Text(
                'Frequently Asked Questions (FAQs)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: faqs.map((faq) {
              return ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(
                  faq['q']!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      faq['a']!,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.45,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountAndLogoutCard(BuildContext context, bool isDark) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.manage_accounts_rounded, color: AppColors.error, size: 22),
              const SizedBox(width: 10),
              Text(
                'Account Session',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Logged in via College Academic Single Sign-On (SSO). Logging out terminates your session across this browser.',
            style: TextStyle(fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogCtx) => AlertDialog(
                  title: const Text('Confirm Logout'),
                  content: const Text('Are you sure you want to end your session?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogCtx).pop(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                      onPressed: () {
                        Navigator.of(dialogCtx).pop();
                        context.read<AuthProvider>().logout();
                      },
                      child: const Text('Logout', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text('Log Out of Campus Career Hub'),
          ),
        ],
      ),
    );
  }
}
