import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/student_model.dart';
import '../../providers/portal_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/readiness_gauge.dart';
import '../../utils/responsive.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  late TextEditingController _nameCtrl;
  late TextEditingController _idCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _deptCtrl;
  late TextEditingController _yearCtrl;
  late TextEditingController _cgpaCtrl;
  final TextEditingController _skillInputCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final student = context.read<PortalProvider>().student;
    _nameCtrl = TextEditingController(text: student.fullName);
    _idCtrl = TextEditingController(text: student.studentId);
    _emailCtrl = TextEditingController(text: student.email);
    _phoneCtrl = TextEditingController(text: student.phone);
    _deptCtrl = TextEditingController(text: student.department);
    _yearCtrl = TextEditingController(text: student.year);
    _cgpaCtrl = TextEditingController(text: student.cgpa.toString());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _idCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _deptCtrl.dispose();
    _yearCtrl.dispose();
    _cgpaCtrl.dispose();
    _skillInputCtrl.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final portal = context.read<PortalProvider>();
    final parsedCgpa = double.tryParse(_cgpaCtrl.text.trim()) ?? portal.student.cgpa;

    final updated = portal.student.copyWith(
      fullName: _nameCtrl.text.trim(),
      studentId: _idCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      department: _deptCtrl.text.trim(),
      year: _yearCtrl.text.trim(),
      cgpa: parsedCgpa,
    );

    portal.updateStudentProfile(updated);
    setState(() => _isEditing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile information updated successfully!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final portal = context.watch<PortalProvider>();
    final student = portal.student;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = Responsive.isDesktop(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 28 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Save / Edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Student Profile & Career Dossier',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage your academic credentials, technical skills, projects, and corporate preferences.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isEditing ? AppColors.success : AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                onPressed: () {
                  if (_isEditing) {
                    _saveProfile();
                  } else {
                    setState(() => _isEditing = true);
                  }
                },
                icon: Icon(_isEditing ? Icons.save_rounded : Icons.edit_rounded, size: 18),
                label: Text(_isEditing ? 'Save Changes' : 'Edit Profile'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Main Profile Details Layout
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          _buildProfileOverviewCard(student, isDark),
                          const SizedBox(height: 20),
                          ReadinessGauge(score: portal.careerReadinessScore),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          _buildAcademicFormCard(isDark),
                          const SizedBox(height: 20),
                          _buildSkillsCard(portal, isDark),
                          const SizedBox(height: 20),
                          _buildProjectsCard(student, isDark),
                          const SizedBox(height: 20),
                          _buildCertificationsCard(student, isDark),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _buildProfileOverviewCard(student, isDark),
                    const SizedBox(height: 20),
                    ReadinessGauge(score: portal.careerReadinessScore),
                    const SizedBox(height: 20),
                    _buildAcademicFormCard(isDark),
                    const SizedBox(height: 20),
                    _buildSkillsCard(portal, isDark),
                    const SizedBox(height: 20),
                    _buildProjectsCard(student, isDark),
                    const SizedBox(height: 20),
                    _buildCertificationsCard(student, isDark),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildProfileOverviewCard(Student student, bool isDark) {
    return CustomCard(
      child: Column(
        children: [
          CircleAvatar(
            radius: 46,
            backgroundColor: AppColors.primarySubtle,
            child: Text(
              student.fullName.isNotEmpty ? student.fullName.substring(0, 2).toUpperCase() : 'AS',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            student.fullName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${student.department} ? ${student.year}',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primarySubtle,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.3)),
            ),
            child: Text(
              'Official Student ID: ${student.studentId}',
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Resume status card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardSubtle : AppColors.lightBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.picture_as_pdf_rounded, color: AppColors.error, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.resumeName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Verified for Campus Drives',
                        style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Resume re-upload simulated: Profile updated with latest timestamp.'),
                        backgroundColor: AppColors.info,
                      ),
                    );
                  },
                  child: const Text('Update', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicFormCard(bool isDark) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Academic & Contact Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFormField('Full Name', _nameCtrl, isDark),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFormField('College Email', _emailCtrl, isDark),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFormField('Phone Number', _phoneCtrl, isDark),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFormField('Cumulative CGPA', _cgpaCtrl, isDark),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFormField('Department', _deptCtrl, isDark),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFormField('Year & Batch', _yearCtrl, isDark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController ctrl, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          enabled: _isEditing,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            filled: true,
            fillColor: _isEditing
                ? (isDark ? AppColors.darkCardSubtle : Colors.white)
                : (isDark ? AppColors.darkCard : AppColors.lightBg),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsCard(PortalProvider portal, bool isDark) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Technical Skills Stack',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                '${portal.student.skills.length} skills listed',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Add skill input
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _skillInputCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Add new skill (e.g. Next.js, Kubernetes, Swift)...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                    ),
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        portal.addSkill(val);
                        _skillInputCtrl.clear();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  if (_skillInputCtrl.text.trim().isNotEmpty) {
                    portal.addSkill(_skillInputCtrl.text);
                    _skillInputCtrl.clear();
                  }
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Skill Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: portal.student.skills.map((skill) {
              return Chip(
                label: Text(skill, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                deleteIcon: const Icon(Icons.close_rounded, size: 14),
                onDeleted: () => portal.removeSkill(skill),
                backgroundColor: isDark ? AppColors.darkCardSubtle : AppColors.primarySubtle,
                side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsCard(Student student, bool isDark) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Featured Projects Portfolio',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 14),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: student.projects.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final project = student.projects[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardSubtle : AppColors.lightBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          project.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primarySubtle,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            project.techStack,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      project.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        height: 1.4,
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

  Widget _buildCertificationsCard(Student student, bool isDark) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verified Industry Certifications',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Column(
            children: student.certifications.map((cert) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.verified_rounded, color: AppColors.success, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        cert,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
