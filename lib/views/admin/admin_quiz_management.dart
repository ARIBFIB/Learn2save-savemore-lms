import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/dummy_data.dart';
import '../../controllers/course_controller.dart';
import '../../widgets/card_item.dart';
import '../shared/buttons.dart';

class AdminQuizManagementWeb extends StatefulWidget {
  const AdminQuizManagementWeb({super.key});

  @override
  State<AdminQuizManagementWeb> createState() => _AdminQuizManagementWebState();
}

class _AdminQuizManagementWebState extends State<AdminQuizManagementWeb> {
  final _searchController = TextEditingController();
  String _selectedCourse = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseController = context.watch<CourseController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quiz Management',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    // Search Bar
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search quizzes...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AppColors.surface,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Filter Button
                    OutlinedButton.icon(
                      onPressed: () {
                        // Show filter dialog
                      },
                      icon: const Icon(Icons.filter_list),
                      label: const Text('Filter'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: BorderSide(color: AppColors.textLight.withOpacity(0.3)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Add Quiz Button
                    PrimaryButton(
                      text: 'Add Quiz',
                      onPressed: () {
                        // Add quiz functionality
                      },
                      // icon: Icons.add,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Course Filter
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.textLight.withOpacity(0.3)),
              ),
              child: DropdownButton<String>(
                value: _selectedCourse,
                onChanged: (value) {
                  setState(() {
                    _selectedCourse = value!;
                  });
                },
                items: ['All', ...DummyData.courses.map((course) => course.title)]
                    .map((course) => DropdownMenuItem(
                  value: course,
                  child: Text(course),
                ))
                    .toList(),
              ),
            ),

            const SizedBox(height: 32),

            // Quiz Table
            Expanded(
              child: CardItem(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Table Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      child: const Row(
                        children: [
                          Expanded(flex: 1, child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 3, child: Text('Quiz Title', style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 2, child: Text('Course', style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 1, child: Text('Questions', style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 1, child: Text('Duration', style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 1, child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 2, child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                    // Table Body
                    Expanded(
                      child: ListView.builder(
                        itemCount: DummyData.quizzes.length,
                        itemBuilder: (context, index) {
                          final quiz = DummyData.quizzes[index];
                          final course = DummyData.courses.firstWhere(
                                (c) => c.id == quiz.courseId,
                            orElse: () => DummyData.courses.first,
                          );
                          return _buildQuizTableRow(quiz, course);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizTableRow(quiz, course) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.textLight.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text('#${quiz.id}')),
          Expanded(flex: 3, child: Text(quiz.title)),
          Expanded(flex: 2, child: Text(course.title)),
          Expanded(flex: 1, child: Text('${quiz.questions.length}')),
          Expanded(flex: 1, child: Text('${quiz.duration} min')),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Published',
                style: TextStyle(
                  color: AppColors.success,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    // Edit quiz
                  },
                  icon: const Icon(Icons.edit, color: AppColors.primary),
                ),
                IconButton(
                  onPressed: () {
                    // View quiz
                  },
                  icon: const Icon(Icons.visibility, color: AppColors.info),
                ),
                IconButton(
                  onPressed: () {
                    // Delete quiz
                  },
                  icon: const Icon(Icons.delete, color: AppColors.error),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdminQuizManagementMobile extends StatefulWidget {
  const AdminQuizManagementMobile({super.key});

  @override
  State<AdminQuizManagementMobile> createState() => _AdminQuizManagementMobileState();
}

class _AdminQuizManagementMobileState extends State<AdminQuizManagementMobile> {
  final _searchController = TextEditingController();
  String _selectedCourse = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseController = context.watch<CourseController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Quiz Management'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Add quiz
            },
            icon: const Icon(Icons.add, color: AppColors.primary),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search quizzes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Course Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.textLight.withOpacity(0.3)),
              ),
              child: DropdownButton<String>(
                value: _selectedCourse,
                onChanged: (value) {
                  setState(() {
                    _selectedCourse = value!;
                  });
                },
                isExpanded: true,
                items: ['All', ...DummyData.courses.map((course) => course.title)]
                    .map((course) => DropdownMenuItem(
                  value: course,
                  child: Text(course),
                ))
                    .toList(),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Quiz List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: DummyData.quizzes.length,
              itemBuilder: (context, index) {
                final quiz = DummyData.quizzes[index];
                final course = DummyData.courses.firstWhere(
                      (c) => c.id == quiz.courseId,
                  orElse: () => DummyData.courses.first,
                );
                return _buildQuizCard(quiz, course);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizCard(quiz, course) {
    return CardItem(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.quiz,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.title,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Row(
                children: [
                  Icon(Icons.help_outline, size: 16, color: AppColors.textLight),
                  const SizedBox(width: 4),
                  Text(
                    '${quiz.questions.length} questions',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: AppColors.textLight),
                  const SizedBox(width: 4),
                  Text(
                    '${quiz.duration} min',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  // Edit quiz
                },
                icon: const Icon(Icons.edit, color: AppColors.primary),
              ),
              IconButton(
                onPressed: () {
                  // Delete quiz
                },
                icon: const Icon(Icons.delete, color: AppColors.error),
              ),
            ],
          ),
        ],
      ),
    );
  }
}