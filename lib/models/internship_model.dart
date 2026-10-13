class Internship {
  final String id;
  final String company;
  final String logoUrl;
  final String role;
  final String duration;
  final String location;
  final bool isPaid;
  final int stipendMonthly; // 0 if unpaid
  final List<String> requiredSkills;
  final DateTime deadline;
  final DateTime startDate;
  final String description;
  final List<String> perks;
  final bool isApplied;

  Internship({
    required this.id,
    required this.company,
    required this.logoUrl,
    required this.role,
    required this.duration,
    required this.location,
    required this.isPaid,
    required this.stipendMonthly,
    required this.requiredSkills,
    required this.deadline,
    required this.startDate,
    required this.description,
    required this.perks,
    this.isApplied = false,
  });

  Internship copyWith({
    String? id,
    String? company,
    String? logoUrl,
    String? role,
    String? duration,
    String? location,
    bool? isPaid,
    int? stipendMonthly,
    List<String>? requiredSkills,
    DateTime? deadline,
    DateTime? startDate,
    String? description,
    List<String>? perks,
    bool? isApplied,
  }) {
    return Internship(
      id: id ?? this.id,
      company: company ?? this.company,
      logoUrl: logoUrl ?? this.logoUrl,
      role: role ?? this.role,
      duration: duration ?? this.duration,
      location: location ?? this.location,
      isPaid: isPaid ?? this.isPaid,
      stipendMonthly: stipendMonthly ?? this.stipendMonthly,
      requiredSkills: requiredSkills ?? List.from(this.requiredSkills),
      deadline: deadline ?? this.deadline,
      startDate: startDate ?? this.startDate,
      description: description ?? this.description,
      perks: perks ?? List.from(this.perks),
      isApplied: isApplied ?? this.isApplied,
    );
  }
}
