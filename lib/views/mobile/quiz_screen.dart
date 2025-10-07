import 'package:flutter/material.dart';
import 'package:learn2save_lms_flutter_app/models/assessment_model.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../constants/dummy_data.dart';
import '../../controllers/course_controller.dart';
import 'package:learn2save_lms_flutter_app/views/shared/app_bar.dart';
import 'package:learn2save_lms_flutter_app/views/shared/buttons.dart';
import '../../widgets/card_item.dart';

class QuizScreen extends StatefulWidget {
  final String quizId;

  const QuizScreen({
    super.key,
    required this.quizId,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Quiz _quiz;
  int _currentQuestionIndex = 0;
  int? _selectedAnswer;
  List<int?> _answers = [];
  bool _isSubmitted = false;
  int _score = 0;
  int _timeRemaining = 1800; // 30 minutes in seconds

  @override
  void initState() {
    super.initState();
    _quiz = DummyData.quizzes.firstWhere(
          (q) => q.id == widget.quizId,
      orElse: () => DummyData.quizzes.first,
    );
    _answers = List.filled(_quiz.questions.length, null);
    _startTimer();
  }

  @override
  void dispose() {
    // Cancel timer if needed
    super.dispose();
  }

  void _startTimer() {
    // Timer implementation would go here
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _quiz.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: CustomAppBar(
        title: _quiz.title,
        showBackButton: !_isSubmitted,
        onBackPressed: () {
          if (_isSubmitted) {
            Navigator.of(context).pop();
          } else {
            _showExitConfirmation();
          }
        },
      ),
      body: _isSubmitted ? _buildResultScreen() : _buildQuizScreen(currentQuestion),
    );
  }

  Widget _buildQuizScreen(Question currentQuestion) {
    return Column(
      children: [
        // Progress Bar
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / _quiz.questions.length,
          backgroundColor: AppColors.background,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),

        // Question Counter and Timer
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1} of ${_quiz.questions.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${(_timeRemaining ~/ 60)}:${(_timeRemaining % 60).toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Question
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentQuestion.text,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 32),

                // Options
                ...currentQuestion.options.asMap().entries.map(
                      (entry) {
                    final index = entry.key;
                    final option = entry.value;
                    final isSelected = _selectedAnswer == index;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CardItem(
                        onTap: () {
                          setState(() {
                            _selectedAnswer = index;
                            _answers[_currentQuestionIndex] = index;
                          });
                        },
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.surface,
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textLight,
                                  width: 2,
                                ),
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index), // A, B, C, D
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                option,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // Navigation Buttons
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (_currentQuestionIndex > 0)
                Expanded(
                  child: SecondaryButton(
                    text: AppStrings.previousQuestion,
                    onPressed: () {
                      setState(() {
                        _currentQuestionIndex--;
                        _selectedAnswer = _answers[_currentQuestionIndex];
                      });
                    },
                  ),
                ),
              if (_currentQuestionIndex > 0) const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  text: _currentQuestionIndex < _quiz.questions.length - 1
                      ? AppStrings.nextQuestion
                      : AppStrings.submitQuiz,
                  onPressed: _selectedAnswer != null
                      ? () {
                    if (_currentQuestionIndex < _quiz.questions.length - 1) {
                      setState(() {
                        _currentQuestionIndex++;
                        _selectedAnswer = _answers[_currentQuestionIndex];
                      });
                    } else {
                      _submitQuiz();
                    }
                  }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultScreen() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Result Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: _score >= _quiz.questions.length * 0.7
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.warning.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _score >= _quiz.questions.length * 0.7
                  ? Icons.emoji_events
                  : Icons.quiz,
              size: 60,
              color: _score >= _quiz.questions.length * 0.7
                  ? AppColors.success
                  : AppColors.warning,
            ),
          ),

          const SizedBox(height: 24),

          // Result Title
          Text(
            AppStrings.quizCompleted,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 16),

          // Score
          Text(
            '${AppStrings.yourScore}: $_score/${_quiz.questions.length}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          // Percentage
          Text(
            '${((_score / _quiz.questions.length) * 100).toInt()}%',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: _score >= _quiz.questions.length * 0.7
                  ? AppColors.success
                  : AppColors.warning,
            ),
          ),

          const SizedBox(height: 32),

          // Message
          Text(
            _score >= _quiz.questions.length * 0.7
                ? 'Excellent work! You passed the quiz.'
                : 'Good effort! Review the material and try again.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 32),

          // Action Buttons
          PrimaryButton(
            text: 'Review Answers',
            onPressed: () {
              // Navigate to review screen
            },
          ),

          const SizedBox(height: 12),

          SecondaryButton(
            text: 'Back to Course',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _submitQuiz() {
    // Calculate score
    _score = 0;
    for (int i = 0; i < _quiz.questions.length; i++) {
      if (_answers[i] == _quiz.questions[i].correctAnswer) {
        _score++;
      }
    }

    setState(() {
      _isSubmitted = true;
    });
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Quiz?'),
        content: const Text(
          'Your progress will be lost. Are you sure you want to exit?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}