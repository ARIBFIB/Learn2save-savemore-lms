import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../controllers/auth_controller.dart';
import '../shared/app_bar.dart';
import '../shared/buttons.dart';
import '../../widgets/card_item.dart';

class SettingsMobile extends StatefulWidget {
  const SettingsMobile({super.key});

  @override
  State<SettingsMobile> createState() => _SettingsMobileState();
}

class _SettingsMobileState extends State<SettingsMobile> {
  bool _notificationsEnabled = true;
  bool _emailNotificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Settings',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Settings
            const Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            CardItem(
              child: Column(
                children: [
                  _buildSettingItem(
                    'Edit Profile',
                    'Update your personal information',
                    Icons.person,
                        () {
                      // Navigate to edit profile
                    },
                  ),
                  const Divider(),
                  _buildSettingItem(
                    'Change Password',
                    'Update your password',
                    Icons.lock,
                        () {
                      // Navigate to change password
                    },
                  ),
                  const Divider(),
                  _buildSettingItem(
                    'Privacy Settings',
                    'Manage your privacy preferences',
                    Icons.privacy_tip,
                        () {
                      // Navigate to privacy settings
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // App Settings
            const Text(
              'App Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            CardItem(
              child: Column(
                children: [
                  _buildSwitchSettingItem(
                    'Push Notifications',
                    'Receive notifications on your device',
                    _notificationsEnabled,
                        (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                  const Divider(),
                  _buildSwitchSettingItem(
                    'Email Notifications',
                    'Receive notifications via email',
                    _emailNotificationsEnabled,
                        (value) {
                      setState(() {
                        _emailNotificationsEnabled = value;
                      });
                    },
                  ),
                  const Divider(),
                  _buildSwitchSettingItem(
                    'Dark Mode',
                    'Use dark theme',
                    _darkModeEnabled,
                        (value) {
                      setState(() {
                        _darkModeEnabled = value;
                      });
                    },
                  ),
                  const Divider(),
                  _buildDropdownSettingItem(
                    'Language',
                    'Select your preferred language',
                    _selectedLanguage,
                    ['English', 'Spanish', 'French', 'German', 'Chinese'],
                        (value) {
                      setState(() {
                        _selectedLanguage = value!;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Learning Settings
            const Text(
              'Learning Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            CardItem(
              child: Column(
                children: [
                  _buildSettingItem(
                    'Download Quality',
                    'Set video download quality',
                    Icons.hd,
                        () {
                      // Navigate to download quality settings
                    },
                  ),
                  const Divider(),
                  _buildSettingItem(
                    'Autoplay',
                    'Configure video autoplay settings',
                    Icons.play_arrow,
                        () {
                      // Navigate to autoplay settings
                    },
                  ),
                  const Divider(),
                  _buildSettingItem(
                    'Subtitles',
                    'Configure subtitle preferences',
                    Icons.subtitles,
                        () {
                      // Navigate to subtitle settings
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Support
            const Text(
              'Support',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            CardItem(
              child: Column(
                children: [
                  _buildSettingItem(
                    'Help Center',
                    'Get help with common issues',
                    Icons.help,
                        () {
                      // Navigate to help center
                    },
                  ),
                  const Divider(),
                  _buildSettingItem(
                    'Contact Us',
                    'Get in touch with our support team',
                    Icons.contact_support,
                        () {
                      // Navigate to contact us
                    },
                  ),
                  const Divider(),
                  _buildSettingItem(
                    'Terms of Service',
                    'Read our terms of service',
                    Icons.description,
                        () {
                      // Navigate to terms of service
                    },
                  ),
                  const Divider(),
                  _buildSettingItem(
                    'Privacy Policy',
                    'Read our privacy policy',
                    Icons.privacy_tip,
                        () {
                      // Navigate to privacy policy
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Danger Zone
            const Text(
              'Danger Zone',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 16),
            CardItem(
              child: _buildSettingItem(
                'Delete Account',
                'Permanently delete your account',
                Icons.delete_forever,
                    () {
                  _showDeleteAccountDialog(context);
                },
                color: AppColors.error,
              ),
            ),

            const SizedBox(height: 24),

            // App Version
            Center(
              child: Text(
                'Savemore Pro v1.0.0',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textLight,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, String subtitle, IconData icon, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? AppColors.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.textLight,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchSettingItem(String title, String subtitle, bool value, Function(bool) onChanged) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildDropdownSettingItem(String title, String subtitle, String value, List<String> options, Function(String?) onChanged) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Delete account logic
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class SettingsWeb extends StatefulWidget {
  const SettingsWeb({super.key});

  @override
  State<SettingsWeb> createState() => _SettingsWebState();
}

class _SettingsWebState extends State<SettingsWeb> {
  bool _notificationsEnabled = true;
  bool _emailNotificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Settings Menu
            SizedBox(
              width: 250,
              child: CardItem(
                child: Column(
                  children: [
                    _buildMenuItem(
                      'Account Settings',
                      Icons.person,
                      true,
                    ),
                    _buildMenuItem(
                      'App Settings',
                      Icons.settings,
                      false,
                    ),
                    _buildMenuItem(
                      'Learning Settings',
                      Icons.school,
                      false,
                    ),
                    _buildMenuItem(
                      'Support',
                      Icons.help,
                      false,
                    ),
                    _buildMenuItem(
                      'Danger Zone',
                      Icons.warning,
                      false,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 32),

            // Settings Content
            Expanded(
              child: CardItem(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Account Settings',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSettingSection(
                        'Profile Information',
                        [
                          _buildSettingField('Full Name', authController.user?.name ?? 'John Doe'),
                          _buildSettingField('Email', authController.user?.email ?? 'savemore@gmail.com'),
                          _buildSettingField('Bio', authController.user?.bio ?? 'Passionate learner and tech enthusiast'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSettingSection(
                        'Security',
                        [
                          _buildActionSetting(
                            'Change Password',
                            'Update your password',
                                () {
                              // Navigate to change password
                            },
                          ),
                          _buildActionSetting(
                            'Two-Factor Authentication',
                            'Add an extra layer of security',
                                () {
                              // Navigate to 2FA settings
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSettingSection(
                        'Privacy',
                        [
                          _buildActionSetting(
                            'Privacy Settings',
                            'Manage your privacy preferences',
                                () {
                              // Navigate to privacy settings
                            },
                          ),
                          _buildActionSetting(
                            'Data Export',
                            'Download your data',
                                () {
                              // Navigate to data export
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          PrimaryButton(
                            text: 'Save Changes',
                            onPressed: () {
                              // Save changes
                            },
                          ),
                          const SizedBox(width: 16),
                          SecondaryButton(
                            text: 'Cancel',
                            onPressed: () {
                              // Cancel changes
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, bool isSelected) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.primary.withOpacity(0.1),
      onTap: () {
        // Navigate to selected section
      },
    );
  }

  Widget _buildSettingSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildSettingField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: TextEditingController(text: value),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.textLight.withOpacity(0.3)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSetting(String title, String subtitle, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primary),
            ),
            child: Text(
              'Manage',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}