class InterviewQuestion {
  final String id;
  final String category; // Aptitude, Logical reasoning, Verbal ability, Programming, Data Structures, DBMS, Operating Systems, Computer Networks, HR questions, Resume tips
  final String question;
  final String answer;
  final String difficulty; // Easy, Medium, Hard
  final List<String> tags;
  final String tip;
  final bool isBookmarked;

  InterviewQuestion({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
    required this.difficulty,
    required this.tags,
    required this.tip,
    this.isBookmarked = false,
  });

  InterviewQuestion copyWith({
    String? id,
    String? category,
    String? question,
    String? answer,
    String? difficulty,
    List<String>? tags,
    String? tip,
    bool? isBookmarked,
  }) {
    return InterviewQuestion(
      id: id ?? this.id,
      category: category ?? this.category,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? List.from(this.tags),
      tip: tip ?? this.tip,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
