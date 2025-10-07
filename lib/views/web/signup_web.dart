import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/notification_banner.dart';
import '../../utils/validators.dart';
import 'package:learn2save_lms_flutter_app/views/shared/buttons.dart';

class SignupWeb extends StatefulWidget {
  const SignupWeb({super.key});

  @override
  State<SignupWeb> createState() => _SignupWebState();
}

class _SignupWebState extends State<SignupWeb> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Left Side - Branding
          if (screenWidth > 1200)
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.secondaryGradient,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Start Your\nLearning Journey',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Create your account and access\nthousands of courses',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Right Side - Signup Form
          Expanded(
            flex: 1,
            child: Center(
            child: SingleChildScrollView(
            padding: const EdgeInsets.all(48),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo for smaller screens
                        if (screenWidth <= 1200) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Create Account',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 48),
                        ],

                        // Welcome Text
                        const Text(
                          'Join Our Community',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start learning today',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Error Message
                        if (authController.errorMessage != null)
                          NotificationBanner(
                            message: authController.errorMessage!,
                            type: 'error',
                            onClose: () => authController.clearError(),
                          ),

                        // Name Field
                        CustomTextField(
                          label: AppStrings.fullName,
                          hint: 'Enter your full name',
                          prefixIcon: Icons.person_outline,
                          controller: _nameController,
                          validator: Validators.validateName,
                        ),

                        const SizedBox(height: 20),

                        // Email Field
                        CustomTextField(
                          label: AppStrings.email,
                          hint: 'Enter your email',
                          prefixIcon: Icons.email_outlined,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.validateEmail,
                        ),

                        const SizedBox(height: 20),

                        // Password Field
                        CustomTextField(
                          label: AppStrings.password,
                          hint: 'Create a password',
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          obscureText: _obscurePassword,
                          controller: _passwordController,
                          validator: Validators.validatePassword,
                          onSuffixIconTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        // Confirm Password Field
                        CustomTextField(
                          label: AppStrings.confirmPassword,
                          hint: 'Confirm your password',
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: _obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          obscureText: _obscureConfirmPassword,
                          controller: _confirmPasswordController,
                          validator: (value) => Validators.validateConfirmPassword(
                            value,
                            _passwordController.text,
                          ),
                          onSuffixIconTap: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),

                        const SizedBox(height: 32),

                        // Signup Button
                        PrimaryButton(
                          text: AppStrings.signup,
                          onPressed: _handleSignup,
                          isLoading: authController.isLoading,
                          height: 56,
                        ),

                        const SizedBox(height: 32),

                        // Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.alreadyHaveAccount,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.go('/login');
                              },
                              child: Text(
                                AppStrings.login,
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
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
          ),
          ),
        ],
      ),
    );
  }

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      final success = await context.read<AuthController>().signup(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success) {
        if (mounted) {
          context.go('/dashboard');
        }
      }
    }
  }
}