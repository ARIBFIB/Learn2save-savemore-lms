class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? profileImageUrl;
  final UserRole role;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final List<String> enrolledCourseIds;
  final Map<String, dynamic> preferences;
  final String? token;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profileImageUrl,
    required this.role,
    required this.createdAt,
    required this.lastLoginAt,
    this.enrolledCourseIds = const [],
    this.preferences = const {},
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profile_image_url'],
      role: UserRole.values.firstWhere(
            (role) => role.toString() == 'UserRole.${json['role']}',
        orElse: () => UserRole.student,
      ),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      lastLoginAt: DateTime.parse(json['last_login_at'] ?? DateTime.now().toIso8601String()),
      enrolledCourseIds: List<String>.from(json['enrolled_course_ids'] ?? []),
      preferences: json['preferences'] ?? {},
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'profile_image_url': profileImageUrl,
      'role': role.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt.toIso8601String(),
      'enrolled_course_ids': enrolledCourseIds,
      'preferences': preferences,
      'token': token,
    };
  }

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? profileImageUrl,
    UserRole? role,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    List<String>? enrolledCourseIds,
    Map<String, dynamic>? preferences,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      enrolledCourseIds: enrolledCourseIds ?? this.enrolledCourseIds,
      preferences: preferences ?? this.preferences,
    );
  }
}

enum UserRole {
  student,
  instructor,
  admin,
}