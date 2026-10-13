class Placement {
  final String id;
  final String company;
  final String logoUrl;
  final String jobRole;
  final double packageLPA;
  final String location;
  final double minCgpa;
  final List<String> eligibleBranches;
  final String eligibleBatch;
  final List<String> requiredSkills;
  final DateTime deadline;
  final DateTime driveDate;
  final String jobDescription;
  final List<String> selectionRounds;
  final String bondDetails;
  final int vacancies;
  final bool isApplied;

  Placement({
    required this.id,
    required this.company,
    required this.logoUrl,
    required this.jobRole,
    required this.packageLPA,
    required this.location,
    required this.minCgpa,
    required this.eligibleBranches,
    required this.eligibleBatch,
    required this.requiredSkills,
    required this.deadline,
    required this.driveDate,
    required this.jobDescription,
    required this.selectionRounds,
    required this.bondDetails,
    required this.vacancies,
    this.isApplied = false,
  });

  Placement copyWith({
    String? id,
    String? company,
    String? logoUrl,
    String? jobRole,
    double? packageLPA,
    String? location,
    double? minCgpa,
    List<String>? eligibleBranches,
    String? eligibleBatch,
    List<String>? requiredSkills,
    DateTime? deadline,
    DateTime? driveDate,
    String? jobDescription,
    List<String>? selectionRounds,
    String? bondDetails,
    int? vacancies,
    bool? isApplied,
  }) {
    return Placement(
      id: id ?? this.id,
      company: company ?? this.company,
      logoUrl: logoUrl ?? this.logoUrl,
      jobRole: jobRole ?? this.jobRole,
      packageLPA: packageLPA ?? this.packageLPA,
      location: location ?? this.location,
      minCgpa: minCgpa ?? this.minCgpa,
      eligibleBranches: eligibleBranches ?? List.from(this.eligibleBranches),
      eligibleBatch: eligibleBatch ?? this.eligibleBatch,
      requiredSkills: requiredSkills ?? List.from(this.requiredSkills),
      deadline: deadline ?? this.deadline,
      driveDate: driveDate ?? this.driveDate,
      jobDescription: jobDescription ?? this.jobDescription,
      selectionRounds: selectionRounds ?? List.from(this.selectionRounds),
      bondDetails: bondDetails ?? this.bondDetails,
      vacancies: vacancies ?? this.vacancies,
      isApplied: isApplied ?? this.isApplied,
    );
  }
}
