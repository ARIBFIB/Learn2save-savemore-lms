class Course {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String instructorAvatar;
  final String thumbnail;
  final String duration;
  final int lessons;
  final int students;
  final double rating;
  final double price;
  final String category;
  final String level;
  final String language;
  final DateTime lastUpdated;
  final List<String> curriculum;
  final bool enrolled;
  final double progress;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.instructorAvatar,
    required this.thumbnail,
    required this.duration,
    required this.lessons,
    required this.students,
    required this.rating,
    required this.price,
    required this.category,
    required this.level,
    required this.language,
    required this.lastUpdated,
    required this.curriculum,
    required this.enrolled,
    required this.progress,
  });
}