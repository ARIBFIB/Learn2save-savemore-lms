class Course {
  final String id;
  final String title;
  final String description;
  final String instructorId;
  final String instructorName;
  final String? thumbnailUrl;
  final List<String> categories;
  final double price;
  final Duration duration;
  final int enrolledCount;
  final double rating;
  final int reviewCount;
  final List<String> prerequisites;
  final List<String> learningObjectives;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CourseStatus status;
  final List<CourseModule> modules;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructorId,
    required this.instructorName,
    this.thumbnailUrl,
    this.categories = const [],
    required this.price,
    required this.duration,
    this.enrolledCount = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.prerequisites = const [],
    this.learningObjectives = const [],
    required this.createdAt,
    required this.updatedAt,
    this.status = CourseStatus.draft,
    this.modules = const [],
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      instructorId: json['instructor_id'] ?? '',
      instructorName: json['instructor_name'] ?? '',
      thumbnailUrl: json['thumbnail_url'],
      categories: List<String>.from(json['categories'] ?? []),
      price: (json['price'] ?? 0).toDouble(),
      duration: Duration(hours: json['duration_hours'] ?? 0),
      enrolledCount: json['enrolled_count'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      prerequisites: List<String>.from(json['prerequisites'] ?? []),
      learningObjectives: List<String>.from(json['learning_objectives'] ?? []),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      status: CourseStatus.values.firstWhere(
            (status) => status.toString() == 'CourseStatus.${json['status']}',
        orElse: () => CourseStatus.draft,
      ),
      modules: (json['modules'] as List<dynamic>?)
          ?.map((module) => CourseModule.fromJson(module))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructor_id': instructorId,
      'instructor_name': instructorName,
      'thumbnail_url': thumbnailUrl,
      'categories': categories,
      'price': price,
      'duration_hours': duration.inHours,
      'enrolled_count': enrolledCount,
      'rating': rating,
      'review_count': reviewCount,
      'prerequisites': prerequisites,
      'learning_objectives': learningObjectives,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'status': status.toString().split('.').last,
      'modules': modules.map((module) => module.toJson()).toList(),
    };
  }
}

enum CourseStatus {
  draft,
  published,
  archived,
}

class CourseModule {
  final String id;
  final String title;
  final String description;
  final int order;
  final List<CourseLesson> lessons;
  final bool isLocked;

  CourseModule({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    this.lessons = const [],
    this.isLocked = true,
  });

  factory CourseModule.fromJson(Map<String, dynamic> json) {
    return CourseModule(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      order: json['order'] ?? 0,
      lessons: (json['lessons'] as List<dynamic>?)
          ?.map((lesson) => CourseLesson.fromJson(lesson))
          .toList() ?? [],
      isLocked: json['is_locked'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'order': order,
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
      'is_locked': isLocked,
    };
  }
}

class CourseLesson {
  final String id;
  final String title;
  final String description;
  final LessonType type;
  final String? contentUrl;
  final int durationMinutes;
  final bool isCompleted;
  final int order;

  CourseLesson({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.contentUrl,
    required this.durationMinutes,
    this.isCompleted = false,
    required this.order,
  });

  factory CourseLesson.fromJson(Map<String, dynamic> json) {
    return CourseLesson(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: LessonType.values.firstWhere(
            (type) => type.toString() == 'LessonType.${json['type']}',
        orElse: () => LessonType.video,
      ),
      contentUrl: json['content_url'],
      durationMinutes: json['duration_minutes'] ?? 0,
      isCompleted: json['is_completed'] ?? false,
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'content_url': contentUrl,
      'duration_minutes': durationMinutes,
      'is_completed': isCompleted,
      'order': order,
    };
  }
}

enum LessonType {
  video,
  text,
  quiz,
  assignment,
}