import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../controllers/auth_controller.dart';
import '../shared/app_bar.dart';
import '../shared/buttons.dart';
import '../../widgets/card_item.dart';

class CertificatesMobile extends StatelessWidget {
  const CertificatesMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Certificates',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Your Achievements',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Certificates you\'ve earned by completing courses',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            // Certificates List
            ...List.generate(3, (index) {
              final isCompleted = index < 2; // First 2 certificates are completed
              return CertificateCard(
                isCompleted: isCompleted,
                courseTitle: [
                  'Flutter Development Masterclass',
                  'Web Development with React',
                  'Python for Data Science'
                ][index],
                completionDate: isCompleted
                    ? [
                  'January 15, 2024',
                  'December 20, 2023',
                  null
                ][index]
                    : null,
                onView: isCompleted
                    ? () {
                  // View certificate
                }
                    : null,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class CertificateCard extends StatelessWidget {
  final bool isCompleted;
  final String courseTitle;
  final String? completionDate;
  final VoidCallback? onView;

  const CertificateCard({
    super.key,
    required this.isCompleted,
    required this.courseTitle,
    this.completionDate,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return CardItem(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCompleted
                        ? AppColors.success.withOpacity(0.3)
                        : AppColors.textLight.withOpacity(0.3),
                  ),
                ),
                child: isCompleted
                    ? Icon(
                  Icons.emoji_events,
                  size: 40,
                  color: AppColors.success,
                )
                    : Icon(
                  Icons.lock,
                  size: 40,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courseTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (isCompleted && completionDate != null)
                      Text(
                        'Completed on $completionDate',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      )
                    else
                      Text(
                        'Complete the course to earn this certificate',
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
          const SizedBox(height: 16),
          if (isCompleted)
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: 'View Certificate',
                    onPressed: onView,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SecondaryButton(
                    text: 'Share',
                    onPressed: () {
                      // Share certificate
                    },
                  ),
                ),
              ],
            )
          else
            PrimaryButton(
              text: 'Continue Course',
              onPressed: () {
                // Navigate to course
              },
            ),
        ],
      ),
    );
  }
}

class CertificatesWeb extends StatelessWidget {
  const CertificatesWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Certificates',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Certificates you\'ve earned by completing courses',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 32),

            // Certificates Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1.2,
                ),
                itemCount: 3,
                itemBuilder: (context, index) {
                  final isCompleted = index < 2; // First 2 certificates are completed
                  return CertificateCardWeb(
                    isCompleted: isCompleted,
                    courseTitle: [
                      'Flutter Development Masterclass',
                      'Web Development with React',
                      'Python for Data Science'
                    ][index],
                    completionDate: isCompleted
                        ? [
                      'January 15, 2024',
                      'December 20, 2023',
                      null
                    ][index]
                        : null,
                    onView: isCompleted
                        ? () {
                      // View certificate
                    }
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CertificateCardWeb extends StatelessWidget {
  final bool isCompleted;
  final String courseTitle;
  final String? completionDate;
  final VoidCallback? onView;

  const CertificateCardWeb({
    super.key,
    required this.isCompleted,
    required this.courseTitle,
    this.completionDate,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return CardItem(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Certificate Preview
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isCompleted
                      ? AppColors.success.withOpacity(0.3)
                      : AppColors.textLight.withOpacity(0.3),
                ),
              ),
              child: isCompleted
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: 60,
                    color: AppColors.success,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Certificate of Completion',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    courseTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (completionDate != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Completed on $completionDate',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock,
                    size: 60,
                    color: AppColors.textLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Certificate Locked',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    courseTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete the course to earn this certificate',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Actions
          if (isCompleted)
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: 'View Certificate',
                    onPressed: onView,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SecondaryButton(
                    text: 'Share',
                    onPressed: () {
                      // Share certificate
                    },
                  ),
                ),
              ],
            )
          else
            PrimaryButton(
              text: 'Continue Course',
              onPressed: () {
                // Navigate to course
              },
            ),
        ],
      ),
    );
  }
}