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

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
        // Navigate to dashboard based on user role
        // Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
      }
      // Error handling is done in the auth controller and displayed in the UI
    }
    Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);

  }

  @override
  Widget build(BuildContext context) {
    // Initialize screenutil for responsive design
    ScreenUtil.init(context, designSize: const Size(375, 812));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<AuthController>(
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
                authController.clearError(); // Clear error after showing
              });
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60.h),

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
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          AppStrings.loginSubtitle,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 60.h),

                  // Login form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
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

                        SizedBox(height: 16.h),

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
                                    fontSize: 14.sp,
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
                                  fontSize: 14.sp,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 30.h),

                        // Login button
                        authController.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : PrimaryButton(
                          text: AppStrings.login,
                          onPressed: _login,
                        ),

                        SizedBox(height: 30.h),

                        // Sign up link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.dontHaveAccount,
                              style: TextStyle(
                                fontSize: 14.sp,
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
                                  fontSize: 14.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}