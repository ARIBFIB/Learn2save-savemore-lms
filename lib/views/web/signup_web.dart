import 'package:flutter/material.dart';
import 'package:learn2save_lms_flutter_app/views/shared/buttons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controllers/auth_controller.dart';
import '../../widgets/custom_text_field.dart';
import '../../utils/validators.dart';
import '../../routes/app_routes.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';

class SignupWebScreen extends StatefulWidget {
  const SignupWebScreen({Key? key}) : super(key: key);

  @override
  State<SignupWebScreen> createState() => _SignupWebScreenState();
}

class _SignupWebScreenState extends State<SignupWebScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      final authController = Provider.of<AuthController>(context, listen: false);
      final success = await authController.signup(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && authController.isAuthenticated) {
        // Navigate to dashboard
        Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
      }
      // Error handling is done in the auth controller and displayed in the UI
    } else if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.pleaseAgreeToTerms),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize screenutil for responsive design
    ScreenUtil.init(context, designSize: const Size(1440, 900));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<AuthController>(
        builder: (context, authController, child) {
          // Show error message if any
          if (authController.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(authController.errorMessage!),
                  backgroundColor: AppColors.error,
                ),
              );
              authController.clearError();
            });
          }

          return Row(
            children: [
              // Left side - Image/Branding
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: AppColors.primaryGradient,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.school,
                          size: 120.w,
                          color: Colors.white,
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'Join Our Learning Community',
                          style: TextStyle(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Create your account and start your learning journey today. Access thousands of courses from expert instructors.',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 40.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildFeatureCard(Icons.video_library, 'Video Lessons'),
                            SizedBox(width: 40.w),
                            _buildFeatureCard(Icons.quiz, 'Interactive Quizzes'),
                            SizedBox(width: 40.w),
                            _buildFeatureCard(Icons.verified, 'Certificates'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Right side - Signup form
              Expanded(
                flex: 1,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 500.w),
                    child: Padding(
                      padding: EdgeInsets.all(40.w),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Logo and app title
                            Center(
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/logo.png',
                                    height: 80.h,
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    AppStrings.appName,
                                    style: TextStyle(
                                      fontSize: 32.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    AppStrings.signupSubtitle,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 40.h),

                            // Name fields
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: _firstNameController,
                                    labelText: AppStrings.firstName,
                                    validator: Validators.validateName,
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: CustomTextField(
                                    controller: _lastNameController,
                                    labelText: AppStrings.lastName,
                                    validator: Validators.validateName,
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20.h),

                            // Email field
                            CustomTextField(
                              controller: _emailController,
                              labelText: AppStrings.email,
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.validateEmail,
                              prefixIcon: Icons.email_outlined,
                              textInputAction: TextInputAction.next,
                            ),

                            SizedBox(height: 20.h),

                            // Password field
                            CustomTextField(
                              controller: _passwordController,
                              labelText: AppStrings.password,
                              obscureText: _obscurePassword,
                              validator: Validators.validatePassword,
                              prefixIcon: Icons.lock_outline,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              textInputAction: TextInputAction.next,
                            ),

                            SizedBox(height: 20.h),

                            // Confirm password field
                            CustomTextField(
                              controller: _confirmPasswordController,
                              labelText: AppStrings.confirmPassword,
                              obscureText: _obscureConfirmPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              prefixIcon: Icons.lock_outline,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _signup(),
                            ),

                            SizedBox(height: 20.h),

                            // Terms and conditions
                            Row(
                              children: [
                                Checkbox(
                                  value: _agreeToTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      _agreeToTerms = value ?? false;
                                    });
                                  },
                                  activeColor: AppColors.primary,
                                ),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      text: 'I agree to the ',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColors.textSecondary,
                                      ),
                                      children: [
                                        WidgetSpan(
                                          child: TextButtonWidget(
                                            text: 'Terms of Service',
                                            onPressed: () {
                                              // Navigate to terms of service
                                            },
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' and ',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        WidgetSpan(
                                          child: TextButtonWidget(
                                            text: 'Privacy Policy',
                                            onPressed: () {
                                              // Navigate to privacy policy
                                            },
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 40.h),

                            // Signup button
                            authController.isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : PrimaryButton(
                              text: AppStrings.signup,
                              onPressed: _signup,
                              height: 56.h,
                              fontSize: 18.sp,
                            ),

                            SizedBox(height: 30.h),

                            // Login link
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppStrings.alreadyHaveAccount,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(AppRoutes.login);
                                    },
                                    child: Text(
                                      AppStrings.login,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String label) {
    return Column(
      children: [
        Icon(
          icon,
          size: 40.w,
          color: Colors.white,
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}