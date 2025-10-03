import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:learn2save_lms_flutter_app/constants/colors.dart';
import 'package:learn2save_lms_flutter_app/models/course_model.dart';
import 'package:learn2save_lms_flutter_app/views/shared/progress_bar.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;
  final bool showProgress;
  final double progress;

  const CourseCard({
    Key? key,
    required this.course,
    required this.onTap,
    this.showProgress = false,
    this.progress = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 120.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Course thumbnail
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
              child: course.thumbnailUrl != null
                  ? CachedNetworkImage(
                imageUrl: course.thumbnailUrl!,
                width: 120.w,
                height: 120.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 120.w,
                  height: 120.h,
                  color: AppColors.primary.withOpacity(0.1),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 120.w,
                  height: 120.h,
                  color: AppColors.primary.withOpacity(0.1),
                  child: Icon(
                    Icons.image_not_supported,
                    size: 32.w,
                    color: AppColors.primary,
                  ),
                ),
              )
                  : Container(
                width: 120.w,
                height: 120.h,
                color: AppColors.primary.withOpacity(0.1),
                child: Icon(
                  Icons.image,
                  size: 32.w,
                  color: AppColors.primary,
                ),
              ),
            ),

            // Course details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course title
                    Text(
                      course.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 4.h),

                    // Instructor name
                    Text(
                      course.instructorName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    // Course metadata
                    Row(
                      children: [
                        // Rating
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 12.w,
                              color: Colors.amber,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              course.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(width: 12.w),

                        // Duration
                        Row(
                          children: [
                            Icon(
                              Icons.schedule_outlined,
                              size: 12.w,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              '${course.duration.inHours}h',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Price
                        Text(
                          '\$${course.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),

                    // Progress bar (if enabled)
                    if (showProgress) ...[
                      SizedBox(height: 8.h),
                      ProgressBar(
                        progress: progress,
                        height: 4.h,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}