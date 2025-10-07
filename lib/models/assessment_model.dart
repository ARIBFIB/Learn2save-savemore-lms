class Quiz {
  final String id;
  final String title;
  final String courseId;
  final int duration; // in minutes
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.courseId,
    required this.duration,
    required this.questions,
  });
}

class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctAnswer;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswer,
  });
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String type;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
    required this.type,
  });
}