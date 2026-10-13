enum ApplicationStatus {
  applied,
  underReview,
  shortlisted,
  interview,
  selected,
  notSelected,
}

extension ApplicationStatusExtension on ApplicationStatus {
  String get label {
    switch (this) {
      case ApplicationStatus.applied:
        return 'Applied';
      case ApplicationStatus.underReview:
        return 'Under Review';
      case ApplicationStatus.shortlisted:
        return 'Shortlisted';
      case ApplicationStatus.interview:
        return 'Interview';
      case ApplicationStatus.selected:
        return 'Selected';
      case ApplicationStatus.notSelected:
        return 'Not Selected';
    }
  }

  int get stageStep {
    switch (this) {
      case ApplicationStatus.applied:
        return 1;
      case ApplicationStatus.underReview:
        return 2;
      case ApplicationStatus.shortlisted:
        return 3;
      case ApplicationStatus.interview:
        return 4;
      case ApplicationStatus.selected:
        return 5;
      case ApplicationStatus.notSelected:
        return -1;
    }
  }
}

class Application {
  final String id;
  final String targetId; // Placement or Internship ID
  final String company;
  final String logoUrl;
  final String role;
  final String type; // 'Placement' or 'Internship'
  final String packageOrStipend;
  final String location;
  final ApplicationStatus status;
  final DateTime appliedDate;
  final DateTime? interviewDate;
  final String? interviewRound;
  final String nextAction;
  final String notes;

  Application({
    required this.id,
    required this.targetId,
    required this.company,
    required this.logoUrl,
    required this.role,
    required this.type,
    required this.packageOrStipend,
    required this.location,
    required this.status,
    required this.appliedDate,
    this.interviewDate,
    this.interviewRound,
    required this.nextAction,
    required this.notes,
  });

  Application copyWith({
    String? id,
    String? targetId,
    String? company,
    String? logoUrl,
    String? role,
    String? type,
    String? packageOrStipend,
    String? location,
    ApplicationStatus? status,
    DateTime? appliedDate,
    DateTime? interviewDate,
    String? interviewRound,
    String? nextAction,
    String? notes,
  }) {
    return Application(
      id: id ?? this.id,
      targetId: targetId ?? this.targetId,
      company: company ?? this.company,
      logoUrl: logoUrl ?? this.logoUrl,
      role: role ?? this.role,
      type: type ?? this.type,
      packageOrStipend: packageOrStipend ?? this.packageOrStipend,
      location: location ?? this.location,
      status: status ?? this.status,
      appliedDate: appliedDate ?? this.appliedDate,
      interviewDate: interviewDate ?? this.interviewDate,
      interviewRound: interviewRound ?? this.interviewRound,
      nextAction: nextAction ?? this.nextAction,
      notes: notes ?? this.notes,
    );
  }
}
