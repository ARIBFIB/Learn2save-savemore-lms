import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../constants/dummy_data.dart';
import '../../controllers/course_controller.dart';
import 'package:learn2save_lms_flutter_app/views/shared/course_card.dart';
import '../../widgets/custom_text_field.dart';

class CourseListWeb extends StatefulWidget {
  const CourseListWeb({super.key});

  @override
  State<CourseListWeb> createState() => _CourseListWebState();
}

class _CourseListWebState extends State<CourseListWeb> {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AppStrings.courses,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Explore our wide range of courses',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Search Bar
                    SizedBox(
                      width: 300,
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
                    const SizedBox(width: 16),
                    // Filter Button
                    ElevatedButton.icon(
                      onPressed: () {
                        // Show filter dialog
                      },
                      icon: const Icon(Icons.filter_list),
                      label: const Text('Filter'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surface,
                        foregroundColor: AppColors.textPrimary,
                        elevation: 0,
                        side: BorderSide(
                          color: AppColors.textLight.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Category Filter
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: DummyData.categories.length,
                itemBuilder: (context, index) {
                  final category = DummyData.categories[index];
                  final isSelected = _selectedCategory == category;

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
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

            const SizedBox(height: 32),

            // Course Grid
            Expanded(
              child: courseController.isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : _buildCourseGrid(courseController),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseGrid(courseController) {
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

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 0.8,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return CourseCard(
          course: course,
          showProgress: course.enrolled,
          onTap: () {
            // Navigate to course detail
          },
        );
      },
    );
  }
}