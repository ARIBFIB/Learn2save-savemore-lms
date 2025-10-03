class Assessment {
  final String id;
  final String title;
  final String description;
  final String courseId;
  final String courseName;
  final AssessmentType type;
  final int totalQuestions;
  final int durationMinutes;
  final DateTime dueDate;
  final DateTime createdAt;
  final AssessmentStatus status;
  final double? score;
  final int? attempts;
  final List<Question>? questions;

  Assessment({
    required this.id,
    required this.title,
    required this.description,
    required this.courseId,
    required this.courseName,
    required this.type,
    required this.totalQuestions,
    required this.durationMinutes,
    required this.dueDate,
    required this.createdAt,
    required this.status,
    this.score,
    this.attempts,
    this.questions,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      courseId: json['course_id'] ?? '',
      courseName: json['course_name'] ?? '',
      type: AssessmentType.values.firstWhere(
            (type) => type.toString() == 'AssessmentType.${json['type']}',
        orElse: () => AssessmentType.quiz,
      ),
      totalQuestions: json['total_questions'] ?? 0,
      durationMinutes: json['duration_minutes'] ?? 0,
      dueDate: DateTime.parse(json['due_date'] ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      status: AssessmentStatus.values.firstWhere(
            (status) => status.toString() == 'AssessmentStatus.${json['status']}',
        orElse: () => AssessmentStatus.pending,
      ),
      score: json['score']?.toDouble(),
      attempts: json['attempts'],
      questions: (json['questions'] as List<dynamic>?)
          ?.map((question) => Question.fromJson(question))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'course_id': courseId,
      'course_name': courseName,
      'type': type.toString().split('.').last,
      'total_questions': totalQuestions,
      'duration_minutes': durationMinutes,
      'due_date': dueDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'status': status.toString().split('.').last,
      'score': score,
      'attempts': attempts,
      'questions': questions?.map((question) => question.toJson()).toList(),
    };
  }

  Assessment copyWith({
    String? id,
    String? title,
    String? description,
    String? courseId,
    String? courseName,
    AssessmentType? type,
    int? totalQuestions,
    int? durationMinutes,
    DateTime? dueDate,
    DateTime? createdAt,
    AssessmentStatus? status,
    double? score,
    int? attempts,
    List<Question>? questions,
  }) {
    return Assessment(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      type: type ?? this.type,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      score: score ?? this.score,
      attempts: attempts ?? this.attempts,
      questions: questions ?? this.questions,
    );
  }
}

enum AssessmentType {
  quiz,
  assignment,
  exam,
}

enum AssessmentStatus {
  pending,
  inProgress,
  submitted,
  graded,
  expired,
}

class Question {
  final String id;
  final String text;
  final QuestionType type;
  final List<String> options;
  final String? correctAnswer;
  final int points;
  final String? explanation;

  Question({
    required this.id,
    required this.text,
    required this.type,
    this.options = const [],
    this.correctAnswer,
    required this.points,
    this.explanation,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      type: QuestionType.values.firstWhere(
            (type) => type.toString() == 'QuestionType.${json['type']}',
        orElse: () => QuestionType.multipleChoice,
      ),
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correct_answer'],
      points: json['points'] ?? 0,
      explanation: json['explanation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type.toString().split('.').last,
      'options': options,
      'correct_answer': correctAnswer,
      'points': points,
      'explanation': explanation,
    };
  }
}

enum QuestionType {
  multipleChoice,
  trueFalse,
  shortAnswer,
  essay,
}

class Answer {
  final String questionId;
  final String answer;
  final bool isCorrect;
  final int pointsEarned;

  Answer({
    required this.questionId,
    required this.answer,
    required this.isCorrect,
    required this.pointsEarned,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      questionId: json['question_id'] ?? '',
      answer: json['answer'] ?? '',
      isCorrect: json['is_correct'] ?? false,
      pointsEarned: json['points_earned'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'answer': answer,
      'is_correct': isCorrect,
      'points_earned': pointsEarned,
    };
  }
}

class AssessmentResult {
  final String assessmentId;
  final String userId;
  final List<Answer> answers;
  final double totalScore;
  final double maxScore;
  final int correctAnswers;
  final int totalQuestions;
  final DateTime submittedAt;
  final int timeSpentMinutes;

  AssessmentResult({
    required this.assessmentId,
    required this.userId,
    required this.answers,
    required this.totalScore,
    required this.maxScore,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.submittedAt,
    required this.timeSpentMinutes,
  });

  factory AssessmentResult.fromJson(Map<String, dynamic> json) {
    return AssessmentResult(
      assessmentId: json['assessment_id'] ?? '',
      userId: json['user_id'] ?? '',
      answers: (json['answers'] as List<dynamic>?)
          ?.map((answer) => Answer.fromJson(answer))
          .toList() ?? [],
      totalScore: (json['total_score'] ?? 0).toDouble(),
      maxScore: (json['max_score'] ?? 0).toDouble(),
      correctAnswers: json['correct_answers'] ?? 0,
      totalQuestions: json['total_questions'] ?? 0,
      submittedAt: DateTime.parse(json['submitted_at'] ?? DateTime.now().toIso8601String()),
      timeSpentMinutes: json['time_spent_minutes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assessment_id': assessmentId,
      'user_id': userId,
      'answers': answers.map((answer) => answer.toJson()).toList(),
      'total_score': totalScore,
      'max_score': maxScore,
      'correct_answers': correctAnswers,
      'total_questions': totalQuestions,
      'submitted_at': submittedAt.toIso8601String(),
      'time_spent_minutes': timeSpentMinutes,
    };
  }

  double get percentageScore => (totalScore / maxScore) * 100;
}