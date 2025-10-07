import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../controllers/course_controller.dart';
import '../shared/app_bar.dart';
import '../shared/buttons.dart';
import '../shared/progress_bar.dart';
import '../../widgets/card_item.dart';

class CourseContentMobile extends StatefulWidget {
  final String courseId;
  final String lessonId;

  const CourseContentMobile({
    super.key,
    required this.courseId,
    required this.lessonId,
  });

  @override
  State<CourseContentMobile> createState() => _CourseContentMobileState();
}

class _CourseContentMobileState extends State<CourseContentMobile> {
  late int _currentLessonIndex;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _currentLessonIndex = int.tryParse(widget.lessonId) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final courseController = context.watch<CourseController>();
    final course = courseController.courses.firstWhere(
          (c) => c.id == widget.courseId,
      orElse: () => courseController.courses.first,
    );

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Course Content',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Video Player Placeholder
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.black,
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.play_circle_filled,
                    size: 64,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      Text(
                        '0:00 / 10:30',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.fullscreen,
                        color: Colors.white.withOpacity(0.7),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Lesson Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lesson ${_currentLessonIndex + 1}: ${course.curriculum[_currentLessonIndex]}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'In this lesson, you will learn the fundamentals of ${course.curriculum[_currentLessonIndex].toLowerCase()} and how to apply them in real-world scenarios.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // Lesson Tabs
          TabBar(
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Transcript'),
              Tab(text: 'Resources'),
              Tab(text: 'Discussion'),
            ],
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              children: [
                // Overview Tab
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'What you\'ll learn',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...['Understanding the basics', 'Implementing best practices', 'Common pitfalls and how to avoid them']
                          .map((point) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                point,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),

                // Transcript Tab
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Transcript would be displayed here...',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                // Resources Tab
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Lesson Resources',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...['Slide Deck', 'Code Examples', 'Additional Reading']
                          .map((resource) => CardItem(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.description,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                resource,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.download,
                              color: AppColors.textLight,
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),

                // Discussion Tab
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Discussion forum would be displayed here...',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Navigation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentLessonIndex > 0)
                  Expanded(
                    child: SecondaryButton(
                      text: 'Previous Lesson',
                      onPressed: () {
                        setState(() {
                          _currentLessonIndex--;
                        });
                      },
                    ),
                  ),
                if (_currentLessonIndex > 0) const SizedBox(width: 16),
                Expanded(
                  child: PrimaryButton(
                    text: _isCompleted ? 'Next Lesson' : 'Mark as Complete',
                    onPressed: () {
                      if (_isCompleted) {
                        if (_currentLessonIndex < course.curriculum.length - 1) {
                          setState(() {
                            _currentLessonIndex++;
                            _isCompleted = false;
                          });
                        }
                      } else {
                        setState(() {
                          _isCompleted = true;
                        });
                        // Update course progress
                        final newProgress = (_currentLessonIndex + 1) / course.curriculum.length;
                        courseController.updateProgress(course.id, newProgress);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CourseContentWeb extends StatefulWidget {
  final String courseId;
  final String lessonId;

  const CourseContentWeb({
    super.key,
    required this.courseId,
    required this.lessonId,
  });

  @override
  State<CourseContentWeb> createState() => _CourseContentWebState();
}

class _CourseContentWebState extends State<CourseContentWeb> with TickerProviderStateMixin {
  late TabController _tabController;
  late int _currentLessonIndex;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _currentLessonIndex = int.tryParse(widget.lessonId) ?? 0;
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseController = context.watch<CourseController>();
    final course = courseController.courses.firstWhere(
          (c) => c.id == widget.courseId,
      orElse: () => courseController.courses.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Sidebar with Course Content
          SizedBox(
            width: 300,
            child: CardItem(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Progress: ${((course.progress) * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ProgressBar(
                          progress: course.progress,
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: course.curriculum.length,
                      itemBuilder: (context, index) {
                        final isCurrentLesson = index == _currentLessonIndex;
                        final isCompleted = index < _currentLessonIndex;

                        return ListTile(
                          leading: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? AppColors.success
                                  : isCurrentLesson
                                  ? AppColors.primary
                                  : AppColors.background,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: isCompleted
                                  ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              )
                                  : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isCurrentLesson ? Colors.white : AppColors.textSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            course.curriculum[index],
                            style: TextStyle(
                              fontWeight: isCurrentLesson ? FontWeight.bold : FontWeight.normal,
                              color: isCurrentLesson ? AppColors.primary : AppColors.textPrimary,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _currentLessonIndex = index;
                              _isCompleted = false;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Video Player Placeholder
                Container(
                  height: 400,
                  width: double.infinity,
                  color: Colors.black,
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.play_circle_filled,
                          size: 80,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Row(
                          children: [
                            Text(
                              '0:00 / 10:30',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Icon(
                                  Icons.volume_up,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.settings,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.fullscreen,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Lesson Info and Tabs
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lesson ${_currentLessonIndex + 1}: ${course.curriculum[_currentLessonIndex]}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'In this lesson, you will learn the fundamentals of ${course.curriculum[_currentLessonIndex].toLowerCase()} and how to apply them in real-world scenarios.',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Tabs
                        TabBar(
                          controller: _tabController,
                          tabs: const [
                            Tab(text: 'Overview'),
                            Tab(text: 'Transcript'),
                            Tab(text: 'Resources'),
                            Tab(text: 'Discussion'),
                          ],
                          labelColor: AppColors.primary,
                          unselectedLabelColor: AppColors.textSecondary,
                          indicatorColor: AppColors.primary,
                        ),

                        // Tab Content
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // Overview Tab
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'What you\'ll learn',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ...[
                                      'Understanding the basics of ${course.curriculum[_currentLessonIndex].toLowerCase()}',
                                      'Implementing best practices in real-world scenarios',
                                      'Common pitfalls and how to avoid them',
                                      'Advanced techniques for experienced developers'
                                    ].map((point) => Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            size: 20,
                                            color: AppColors.success,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              point,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              ),

                              // Transcript Tab
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Text(
                                  'Transcript would be displayed here...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),

                              // Resources Tab
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Lesson Resources',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ...[
                                      {'name': 'Slide Deck', 'type': 'PDF', 'size': '2.3 MB'},
                                      {'name': 'Code Examples', 'type': 'ZIP', 'size': '1.5 MB'},
                                      {'name': 'Additional Reading', 'type': 'PDF', 'size': '5.7 MB'},
                                    ].map((resource) => CardItem(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.description,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  resource['name']!,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.textPrimary,
                                                  ),
                                                ),
                                                Text(
                                                  '${resource['type']} • ${resource['size']}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.textSecondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              // Download resource
                                            },
                                            icon: const Icon(Icons.download),
                                          ),
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              ),

                              // Discussion Tab
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Text(
                                  'Discussion forum would be displayed here...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Bottom Navigation
                        Row(
                          children: [
                            if (_currentLessonIndex > 0)
                              Expanded(
                                child: SecondaryButton(
                                  text: 'Previous Lesson',
                                  onPressed: () {
                                    setState(() {
                                      _currentLessonIndex--;
                                      _isCompleted = false;
                                    });
                                  },
                                ),
                              ),
                            if (_currentLessonIndex > 0) const SizedBox(width: 16),
                            Expanded(
                              child: PrimaryButton(
                                text: _isCompleted ? 'Next Lesson' : 'Mark as Complete',
                                onPressed: () {
                                  if (_isCompleted) {
                                    if (_currentLessonIndex < course.curriculum.length - 1) {
                                      setState(() {
                                        _currentLessonIndex++;
                                        _isCompleted = false;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      _isCompleted = true;
                                    });
                                    // Update course progress
                                    final newProgress = (_currentLessonIndex + 1) / course.curriculum.length;
                                    courseController.updateProgress(course.id, newProgress);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}