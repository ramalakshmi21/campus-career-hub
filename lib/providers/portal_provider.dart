import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../models/training_model.dart';
import '../models/placement_model.dart';
import '../models/internship_model.dart';
import '../models/application_model.dart';
import '../models/notification_model.dart';
import '../models/interview_question_model.dart';
import '../data/demo_data.dart';
import '../utils/formatters.dart';

class PortalProvider extends ChangeNotifier {
  Student _student = DemoData.initialStudent;
  List<Training> _trainings = List.from(DemoData.initialTrainings);
  List<Placement> _placements = List.from(DemoData.initialPlacements);
  List<Internship> _internships = List.from(DemoData.initialInternships);
  List<Application> _applications = List.from(DemoData.initialApplications);
  List<NotificationItem> _notifications = List.from(DemoData.initialNotifications);
  List<InterviewQuestion> _interviewQuestions = List.from(DemoData.initialInterviewQuestions);

  int _selectedTabIndex = 0;
  String _searchQuery = '';
  String _selectedTrainingCategory = 'All';
  String _selectedPrepCategory = 'All';
  String _selectedAppStatus = 'All';
  String _selectedPlacementSort = 'Default';

  Student get student => _student;
  List<Training> get trainings => _trainings;
  List<Placement> get placements => _placements;
  List<Internship> get internships => _internships;
  List<Application> get applications => _applications;
  List<NotificationItem> get notifications => _notifications;
  List<InterviewQuestion> get interviewQuestions => _interviewQuestions;

  int get selectedTabIndex => _selectedTabIndex;
  String get searchQuery => _searchQuery;
  String get selectedTrainingCategory => _selectedTrainingCategory;
  String get selectedPrepCategory => _selectedPrepCategory;
  String get selectedAppStatus => _selectedAppStatus;
  String get selectedPlacementSort => _selectedPlacementSort;

  int get trainingsCount => _trainings.length;
  int get registeredTrainingsCount => _trainings.where((t) => t.isRegistered).length;
  int get placementsCount => _placements.length;
  int get internshipsCount => _internships.length;
  int get applicationsCount => _applications.length;
  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;

  int get careerReadinessScore {
    double score = 0;
    score += (_student.cgpa / 10.0) * 30.0;
    score += (_student.skills.length * 2.5).clamp(0.0, 20.0);
    score += (_student.certifications.length * 5.0).clamp(0.0, 15.0);
    score += (_student.projects.length * 5.0).clamp(0.0, 15.0);
    score += (registeredTrainingsCount * 5.0).clamp(0.0, 20.0);
    return score.round().clamp(0, 100);
  }

  void setTabIndex(int index) {
    _selectedTabIndex = index;
    _searchQuery = '';
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  void setTrainingCategory(String category) {
    _selectedTrainingCategory = category;
    notifyListeners();
  }

  void setPrepCategory(String category) {
    _selectedPrepCategory = category;
    notifyListeners();
  }

  void setAppStatus(String status) {
    _selectedAppStatus = status;
    notifyListeners();
  }

  void setPlacementSort(String sortOption) {
    _selectedPlacementSort = sortOption;
    notifyListeners();
  }

  void toggleTrainingRegistration(String trainingId) {
    final index = _trainings.indexWhere((t) => t.id == trainingId);
    if (index != -1) {
      final current = _trainings[index];
      final newStatus = !current.isRegistered;
      final newCount = newStatus ? current.registeredCount + 1 : current.registeredCount - 1;

      _trainings[index] = current.copyWith(
        isRegistered: newStatus,
        registeredCount: newCount,
      );

      if (newStatus) {
        _notifications.insert(
          0,
          NotificationItem(
            id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
            title: 'Training Registered',
            message: 'You have enrolled in ${current.title}.',
            category: NotificationCategory.training,
            timestamp: DateTime.now(),
            isRead: false,
            actionRoute: 'training',
          ),
        );
      }
      notifyListeners();
    }
  }

  bool applyForPlacement(Placement placement) {
    final alreadyApplied = _applications.any(
      (a) => a.targetId == placement.id ||
             (a.company.toLowerCase() == placement.company.toLowerCase() &&
              a.role.toLowerCase() == placement.jobRole.toLowerCase()),
    );

    if (alreadyApplied) return false;

    final pIndex = _placements.indexWhere((p) => p.id == placement.id);
    if (pIndex != -1) {
      _placements[pIndex] = _placements[pIndex].copyWith(isApplied: true);
    }

    final newApp = Application(
      id: 'app_${DateTime.now().millisecondsSinceEpoch}',
      targetId: placement.id,
      company: placement.company,
      logoUrl: placement.logoUrl,
      role: placement.jobRole,
      type: 'Placement',
      packageOrStipend: Formatters.formatLPA(placement.packageLPA),
      location: placement.location,
      status: ApplicationStatus.applied,
      appliedDate: DateTime.now(),
      nextAction: 'Recruiter review in progress. Hall ticket will be sent before drive date.',
      notes: 'Applied via Campus Career Hub online drive portal.',
    );
    _applications.insert(0, newApp);

    _notifications.insert(
      0,
      NotificationItem(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Application Submitted: ${placement.company}',
        message: 'Your application for ${placement.jobRole} (${Formatters.formatLPA(placement.packageLPA)}) was submitted.',
        category: NotificationCategory.placement,
        timestamp: DateTime.now(),
        isRead: false,
        actionRoute: 'applications',
      ),
    );

    notifyListeners();
    return true;
  }

  bool applyForInternship(Internship internship) {
    final alreadyApplied = _applications.any(
      (a) => a.targetId == internship.id ||
             (a.company.toLowerCase() == internship.company.toLowerCase() &&
              a.role.toLowerCase() == internship.role.toLowerCase()),
    );

    if (alreadyApplied) return false;

    final iIndex = _internships.indexWhere((i) => i.id == internship.id);
    if (iIndex != -1) {
      _internships[iIndex] = _internships[iIndex].copyWith(isApplied: true);
    }

    final newApp = Application(
      id: 'app_${DateTime.now().millisecondsSinceEpoch}',
      targetId: internship.id,
      company: internship.company,
      logoUrl: internship.logoUrl,
      role: internship.role,
      type: 'Internship',
      packageOrStipend: Formatters.formatStipend(internship.stipendMonthly),
      location: internship.location,
      status: ApplicationStatus.applied,
      appliedDate: DateTime.now(),
      nextAction: 'Profile screening by talent team.',
      notes: 'Applied via Campus Career Hub internship board.',
    );
    _applications.insert(0, newApp);

    _notifications.insert(
      0,
      NotificationItem(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Internship Application: ${internship.company}',
        message: 'Applied for ${internship.role} (${internship.duration}).',
        category: NotificationCategory.internship,
        timestamp: DateTime.now(),
        isRead: false,
        actionRoute: 'applications',
      ),
    );

    notifyListeners();
    return true;
  }

  void withdrawApplication(String appId) {
    final app = _applications.firstWhere((a) => a.id == appId, orElse: () => _applications.first);
    final pIdx = _placements.indexWhere((p) => p.id == app.targetId);
    if (pIdx != -1) {
      _placements[pIdx] = _placements[pIdx].copyWith(isApplied: false);
    }
    final iIdx = _internships.indexWhere((i) => i.id == app.targetId);
    if (iIdx != -1) {
      _internships[iIdx] = _internships[iIdx].copyWith(isApplied: false);
    }

    _applications.removeWhere((a) => a.id == appId);
    notifyListeners();
  }

  void markNotificationAsRead(String notifId) {
    final index = _notifications.indexWhere((n) => n.id == notifId);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  void deleteNotification(String notifId) {
    _notifications.removeWhere((n) => n.id == notifId);
    notifyListeners();
  }

  void toggleBookmarkQuestion(String qId) {
    final index = _interviewQuestions.indexWhere((q) => q.id == qId);
    if (index != -1) {
      final current = _interviewQuestions[index];
      _interviewQuestions[index] = current.copyWith(isBookmarked: !current.isBookmarked);
      notifyListeners();
    }
  }

  void updateStudentProfile(Student updated) {
    _student = updated;
    notifyListeners();
  }

  void addSkill(String skill) {
    final clean = skill.trim();
    if (clean.isNotEmpty && !_student.skills.contains(clean)) {
      _student = _student.copyWith(skills: [..._student.skills, clean]);
      notifyListeners();
    }
  }

  void removeSkill(String skill) {
    _student = _student.copyWith(
      skills: _student.skills.where((s) => s != skill).toList(),
    );
    notifyListeners();
  }
}
