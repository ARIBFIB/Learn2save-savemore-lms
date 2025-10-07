import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/dummy_data.dart';
import '../../constants/strings.dart';
import '../../controllers/course_controller.dart';
import '../shared/app_bar.dart';
import '../shared/buttons.dart';
import '../../widgets/card_item.dart';

class QuizResultMobile extends StatelessWidget {
  final String quizId;

  const QuizResultMobile({
    super.key,
    required this.quizId,
  });

  @override
  Widget build(BuildContext context) {
    final courseController = context.watch<CourseController>();
    final quiz = DummyData.quizzes.firstWhere(
          (q) => q.id == quizId,
      orElse: () => DummyData.quizzes.first,
    );

    // Calculate score (dummy logic)
    final score = (quiz.questions.length * 0.7).round(); // 70% correct
    final percentage = ((score / quiz.questions.length) * 100).round();
    final passed = percentage >= 70;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Quiz Result',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Result Card
            CardItem(
              child: Column(
                children: [
                  // Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: passed ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      passed ? Icons.emoji_events : Icons.quiz,
                      size: 50,
                      color: passed ? AppColors.success : AppColors.warning,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    AppStrings.quizCompleted,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Score
                  Text(
                    '${AppStrings.yourScore}: $score/${quiz.questions.length}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Percentage
                  Text(
                    '$percentage%',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: passed ? AppColors.success : AppColors.warning,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Message
                  Text(
                    passed
                        ? 'Excellent work! You passed the quiz.'
                        : 'Good effort! Review the material and try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Answers Review
            CardItem(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Answers Review',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Questions and Answers
                  ...quiz.questions.asMap().entries.map(
                        (entry) {
                      final index = entry.key;
                      final question = entry.value;
                      final isCorrect = index < score; // Dummy logic for correct answers

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Question
                            Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: isCorrect ? AppColors.success : AppColors.error,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    question.text,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Options
                            ...question.options.asMap().entries.map(
                                  (optionEntry) {
                                final optionIndex = optionEntry.key;
                                final option = optionEntry.value;
                                final isSelected = optionIndex == 1; // Dummy logic for selected answer
                                final isCorrectAnswer = optionIndex == question.correctAnswer;

                                Color optionColor = AppColors.textSecondary;
                                if (isSelected && isCorrectAnswer) {
                                  optionColor = AppColors.success;
                                } else if (isSelected && !isCorrectAnswer) {
                                  optionColor = AppColors.error;
                                } else if (!isSelected && isCorrectAnswer) {
                                  optionColor = AppColors.success;
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(left: 36, bottom: 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isCorrectAnswer ? Icons.check_circle : Icons.cancel,
                                        size: 16,
                                        color: optionColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          option,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: optionColor,
                                            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            PrimaryButton(
              text: 'Back to Course',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              text: 'Retake Quiz',
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to quiz again
              },
            ),
          ],
        ),
      ),
    );
  }
}

class QuizResultWeb extends StatelessWidget {
  final String quizId;

  const QuizResultWeb({
    super.key,
    required this.quizId,
  });

  @override
  Widget build(BuildContext context) {
    final courseController = context.watch<CourseController>();
    final quiz = DummyData.quizzes.firstWhere(
          (q) => q.id == quizId,
      orElse: () => DummyData.quizzes.first,
    );

    // Calculate score (dummy logic)
    final score = (quiz.questions.length * 0.7).round(); // 70% correct
    final percentage = ((score / quiz.questions.length) * 100).round();
    final passed = percentage >= 70;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: CardItem(
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: passed ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      passed ? Icons.emoji_events : Icons.quiz,
                      size: 60,
                      color: passed ? AppColors.success : AppColors.warning,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  const Text(
                    AppStrings.quizCompleted,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Score
                  Text(
                    '${AppStrings.yourScore}: $score/${quiz.questions.length}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Percentage
                  Text(
                    '$percentage%',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: passed ? AppColors.success : AppColors.warning,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Message
                  Text(
                    passed
                        ? 'Excellent work! You passed the quiz.'
                        : 'Good effort! Review the material and try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          text: 'Review Answers',
                          onPressed: () {
                            // Navigate to review screen
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: PrimaryButton(
                          text: 'Back to Course',
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}