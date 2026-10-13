class Training {
  final String id;
  final String title;
  final String category; // Aptitude, Coding, Communication, Soft skills, Interview preparation, Resume building
  final String description;
  final String trainerName;
  final String trainerDesignation;
  final DateTime startDate;
  final DateTime endDate;
  final String duration;
  final String mode; // Online (Zoom) / Offline (Lab 302)
  final int totalSeats;
  final int registeredCount;
  final List<String> syllabus;
  final List<String> prerequisites;
  final bool isRegistered;

  Training({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.trainerName,
    required this.trainerDesignation,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.mode,
    required this.totalSeats,
    required this.registeredCount,
    required this.syllabus,
    required this.prerequisites,
    this.isRegistered = false,
  });

  Training copyWith({
    String? id,
    String? title,
    String? category,
    String? description,
    String? trainerName,
    String? trainerDesignation,
    DateTime? startDate,
    DateTime? endDate,
    String? duration,
    String? mode,
    int? totalSeats,
    int? registeredCount,
    List<String>? syllabus,
    List<String>? prerequisites,
    bool? isRegistered,
  }) {
    return Training(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      trainerName: trainerName ?? this.trainerName,
      trainerDesignation: trainerDesignation ?? this.trainerDesignation,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      duration: duration ?? this.duration,
      mode: mode ?? this.mode,
      totalSeats: totalSeats ?? this.totalSeats,
      registeredCount: registeredCount ?? this.registeredCount,
      syllabus: syllabus ?? List.from(this.syllabus),
      prerequisites: prerequisites ?? List.from(this.prerequisites),
      isRegistered: isRegistered ?? this.isRegistered,
    );
  }
}
