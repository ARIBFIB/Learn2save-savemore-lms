import 'package:flutter/material.dart';
import '../constants/colors.dart';

class NotificationBanner extends StatelessWidget {
  final String message;
  final String type; // 'success', 'error', 'warning', 'info'
  final VoidCallback? onClose;

  const NotificationBanner({
    super.key,
    required this.message,
    required this.type,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color iconColor;
    IconData icon;

    switch (type) {
      case 'success':
        backgroundColor = AppColors.success.withOpacity(0.1);
        iconColor = AppColors.success;
        icon = Icons.check_circle;
        break;
      case 'error':
        backgroundColor = AppColors.error.withOpacity(0.1);
        iconColor = AppColors.error;
        icon = Icons.error;
        break;
      case 'warning':
        backgroundColor = AppColors.warning.withOpacity(0.1);
        iconColor = AppColors.warning;
        icon = Icons.warning;
        break;
      default:
        backgroundColor = AppColors.info.withOpacity(0.1);
        iconColor = AppColors.info;
        icon = Icons.info;
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: iconColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: iconColor,
                fontSize: 14,
              ),
            ),
          ),
          if (onClose != null)
            IconButton(
              onPressed: onClose,
              icon: Icon(
                Icons.close,
                color: iconColor,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}