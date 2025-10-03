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

class LoginWebScreen extends StatefulWidget {
  const LoginWebScreen({Key? key}) : super(key: key);

  @override
  State<LoginWebScreen> createState() => _LoginWebScreenState();
}

class _LoginWebScreenState extends State<LoginWebScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final authController = Provider.of<AuthController>(context, listen: false);
      final success = await authController.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && authController.isAuthenticated) {
        // Navigate to dashboard
        Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
      }
      // Error handling is done in the auth controller and displayed in the UI
    }
    Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
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
              // Left side - Login form
              Expanded(
                flex: 1,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 450.w),
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
                                    AppStrings.loginSubtitle,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 60.h),

                            // Email field
                            CustomTextField(
                              controller: _emailController,
                              labelText: AppStrings.email,
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.validateEmail,
                              prefixIcon: Icons.email_outlined,
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
                            ),

                            SizedBox(height: 20.h),

                            // Remember me and forgot password
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      },
                                      activeColor: AppColors.primary,
                                    ),
                                    Text(
                                      AppStrings.rememberMe,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Navigate to forgot password screen
                                    Navigator.of(context).pushNamed(AppRoutes.forgotPassword);
                                  },
                                  child: Text(
                                    AppStrings.forgotPassword,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 40.h),

                            // Login button
                            authController.isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : PrimaryButton(
                              text: AppStrings.login,
                              onPressed: _login,
                              height: 56.h,
                              fontSize: 18.sp,
                            ),

                            SizedBox(height: 30.h),

                            // Sign up link
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppStrings.dontHaveAccount,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(AppRoutes.signup);
                                    },
                                    child: Text(
                                      AppStrings.signup,
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

              // Right side - Image/Branding
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
                          'Learn Without Limits',
                          style: TextStyle(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Start, switch, or advance your career with more than 5,000 courses, Professional Certificates, and degrees from world-class universities and companies.',
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
                            _buildStatCard('5000+', 'Courses'),
                            SizedBox(width: 40.w),
                            _buildStatCard('1000+', 'Instructors'),
                            SizedBox(width: 40.w),
                            _buildStatCard('100K+', 'Students'),
                          ],
                        ),
                      ],
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

  Widget _buildStatCard(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}