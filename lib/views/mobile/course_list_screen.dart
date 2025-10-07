import 'package:flutter/material.dart';
import 'package:learn2save_lms_flutter_app/views/shared/app_bar.dart';
import 'package:learn2save_lms_flutter_app/views/shared/course_card.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../constants/dummy_data.dart';
import '../../controllers/course_controller.dart';
import '../../widgets/custom_text_field.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseController = context.watch<CourseController>();

    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.courses,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomTextField(
              label: '',
              hint: AppStrings.searchCourses,
              prefixIcon: Icons.search,
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          // Category Filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: DummyData.categories.length,
              itemBuilder: (context, index) {
                final category = DummyData.categories[index];
                final isSelected = _selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                        courseController.filterByCategory(
                          category == 'All' ? null : category,
                        );
                      });
                    },
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),

          // Course List
          Expanded(
            child: courseController.isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : _buildCourseList(courseController),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList(courseController) {
    List courses = courseController.filteredCourses;

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      courses = courseController.searchCourses(_searchController.text);
    }

    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              'No courses found',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh courses
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: CourseCard(
              course: course,
              showProgress: course.enrolled,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/course-detail',
                  arguments: course.id,
                );
              },
            ),
          );
        },
      ),
    );
  }
}