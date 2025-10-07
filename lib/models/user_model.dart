class User {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String bio;
  final List<String> enrolledCourses;
  final List<String> completedCourses;
  final List<String> achievements;
  final DateTime joinDate;
  final int totalLearningHours;
  final String role; // 'student' or 'admin'

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.bio,
    required this.enrolledCourses,
    required this.completedCourses,
    required this.achievements,
    required this.joinDate,
    required this.totalLearningHours,
    this.role = 'student',
  });

  // Convert User to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'bio': bio,
      'enrolledCourses': enrolledCourses,
      'completedCourses': completedCourses,
      'achievements': achievements,
      'joinDate': joinDate.toIso8601String(),
      'totalLearningHours': totalLearningHours,
      'role': role,
    };
  }

  // Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      bio: json['bio'],
      enrolledCourses: List<String>.from(json['enrolledCourses']),
      completedCourses: List<String>.from(json['completedCourses']),
      achievements: List<String>.from(json['achievements']),
      joinDate: DateTime.parse(json['joinDate']),
      totalLearningHours: json['totalLearningHours'],
      role: json['role'] ?? 'student',
    );
  }
}