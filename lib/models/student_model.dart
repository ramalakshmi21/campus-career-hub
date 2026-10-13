class Student {
  final String id;
  final String studentId;
  final String fullName;
  final String email;
  final String phone;
  final String department;
  final String year;
  final double cgpa;
  final List<String> skills;
  final List<String> certifications;
  final List<ProjectItem> projects;
  final List<String> careerInterests;
  final String resumeName;
  final String avatarUrl;

  Student({
    required this.id,
    required this.studentId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.department,
    required this.year,
    required this.cgpa,
    required this.skills,
    required this.certifications,
    required this.projects,
    required this.careerInterests,
    this.resumeName = 'Alex_Sharma_Resume.pdf',
    this.avatarUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=250',
  });

  Student copyWith({
    String? id,
    String? studentId,
    String? fullName,
    String? email,
    String? phone,
    String? department,
    String? year,
    double? cgpa,
    List<String>? skills,
    List<String>? certifications,
    List<ProjectItem>? projects,
    List<String>? careerInterests,
    String? resumeName,
    String? avatarUrl,
  }) {
    return Student(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      year: year ?? this.year,
      cgpa: cgpa ?? this.cgpa,
      skills: skills ?? List.from(this.skills),
      certifications: certifications ?? List.from(this.certifications),
      projects: projects ?? List.from(this.projects),
      careerInterests: careerInterests ?? List.from(this.careerInterests),
      resumeName: resumeName ?? this.resumeName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'studentId': studentId,
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'department': department,
    'year': year,
    'cgpa': cgpa,
    'skills': skills,
    'certifications': certifications,
    'projects': projects.map((p) => p.toJson()).toList(),
    'careerInterests': careerInterests,
    'resumeName': resumeName,
    'avatarUrl': avatarUrl,
  };

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    id: json['id'] as String,
    studentId: json['studentId'] as String,
    fullName: json['fullName'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    department: json['department'] as String,
    year: json['year'] as String,
    cgpa: (json['cgpa'] as num).toDouble(),
    skills: List<String>.from(json['skills'] as List),
    certifications: List<String>.from(json['certifications'] as List),
    projects: (json['projects'] as List)
        .map((p) => ProjectItem.fromJson(p as Map<String, dynamic>))
        .toList(),
    careerInterests: List<String>.from(json['careerInterests'] as List),
    resumeName: json['resumeName'] as String? ?? 'Alex_Sharma_Resume.pdf',
    avatarUrl: json['avatarUrl'] as String? ?? '',
  );
}

class ProjectItem {
  final String title;
  final String description;
  final String techStack;
  final String link;

  ProjectItem({
    required this.title,
    required this.description,
    required this.techStack,
    required this.link,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'techStack': techStack,
    'link': link,
  };

  factory ProjectItem.fromJson(Map<String, dynamic> json) => ProjectItem(
    title: json['title'] as String,
    description: json['description'] as String,
    techStack: json['techStack'] as String,
    link: json['link'] as String,
  );
}
