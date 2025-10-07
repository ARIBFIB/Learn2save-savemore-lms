import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class SideMenu extends StatelessWidget {
  final bool isAdmin;

  const SideMenu({super.key, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final location = GoRouterState.of(context).matchedLocation;

    return Container(
      width: 250,
      color: AppColors.surface,
      child: Column(
        children: [
          // Logo and Title
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isAdmin ? AppColors.secondary : AppColors.primary,
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.appName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isAdmin ? 'Admin Panel' : AppStrings.tagline,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // User Profile Section
          if (authController.isLoggedIn) ...[
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      authController.user?.avatar ?? 'https://picsum.photos/seed/default/100/100',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authController.user?.name ?? 'User',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          authController.user?.email ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
          ],

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: isAdmin
                  ? [
                _buildMenuItem(
                  context,
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  route: AppRoutes.adminDashboard,
                  currentRoute: location,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.book,
                  title: 'Course Management',
                  route: AppRoutes.adminCourseManagement,
                  currentRoute: location,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.people,
                  title: 'User Management',
                  route: AppRoutes.adminUserManagement,
                  currentRoute: location,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.quiz,
                  title: 'Quiz Management',
                  route: AppRoutes.adminQuizManagement,
                  currentRoute: location,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.analytics,
                  title: 'Analytics',
                  route: AppRoutes.adminAnalytics,
                  currentRoute: location,
                ),
              ]
                  : [
                _buildMenuItem(
                  context,
                  icon: Icons.dashboard,
                  title: AppStrings.dashboard,
                  route: AppRoutes.dashboard,
                  currentRoute: location,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.book,
                  title: AppStrings.courses,
                  route: AppRoutes.courses,
                  currentRoute: location,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.quiz,
                  title: AppStrings.quiz,
                  route: '${AppRoutes.quiz}?id=1',
                  currentRoute: location,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.notifications,
                  title: AppStrings.notifications,
                  route: AppRoutes.notifications,
                  currentRoute: location,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.person,
                  title: AppStrings.profile,
                  route: AppRoutes.profile,
                  currentRoute: location,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.card_membership,
                  title: 'Certificates',
                  route: AppRoutes.certificates,
                  currentRoute: location,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  route: AppRoutes.settings,
                  currentRoute: location,
                ),
              ],
            ),
          ),

          // Logout Button
          if (authController.isLoggedIn)
            Container(
              padding: const EdgeInsets.all(16),
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: AppColors.error,
                ),
                title: Text(
                  AppStrings.logout,
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  authController.logout();
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String route,
        required String currentRoute,
      }) {
    final isActive = currentRoute.startsWith(route.split('?')[0]);

    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? (isAdmin ? AppColors.secondary : AppColors.primary) : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? (isAdmin ? AppColors.secondary : AppColors.primary) : AppColors.textSecondary,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      onTap: () {
        context.go(route);
      },
      selected: isActive,
      selectedTileColor: (isAdmin ? AppColors.secondary : AppColors.primary).withOpacity(0.1),
    );
  }
}