import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';

class NotificationBanner extends StatefulWidget {
  final String title;
  final String message;
  final NotificationType type;
  final bool showIcon;
  final VoidCallback? onTap;
  final VoidCallback? onClose;
  final Duration duration;

  const NotificationBanner({
    Key? key,
    required this.title,
    required this.message,
    this.type = NotificationType.info,
    this.showIcon = true,
    this.onTap,
    this.onClose,
    this.duration = const Duration(seconds: 5),
  }) : super(key: key);

  @override
  State<NotificationBanner> createState() => _NotificationBannerState();
}

class _NotificationBannerState extends State<NotificationBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();

    // Auto dismiss after duration
    if (widget.duration != Duration.zero) {
      Future.delayed(widget.duration, () {
        if (mounted) {
          _dismiss();
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() {
    _animationController.reverse().then((_) {
      if (mounted) {
        widget.onClose?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
              if (widget.showIcon) ...[
                Icon(
                  _getIcon(),
                  color: _getIconColor(),
                  size: 24.w,
                ),
                SizedBox(width: 12.w),
              ],

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: _getTextColor(),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      widget.message,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: _getTextColor(),
                      ),
                    ),
                  ],
                ),
              ),

              // Close button
              if (widget.onClose != null) ...[
                SizedBox(width: 12.w),
                GestureDetector(
                  onTap: _dismiss,
                  child: Icon(
                    Icons.close,
                    color: _getTextColor(),
                    size: 20.w,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case NotificationType.success:
        return AppColors.success.withOpacity(0.1);
      case NotificationType.error:
        return AppColors.error.withOpacity(0.1);
      case NotificationType.warning:
        return AppColors.warning.withOpacity(0.1);
      case NotificationType.info:
      default:
        return AppColors.info.withOpacity(0.1);
    }
  }

  Color _getIconColor() {
    switch (widget.type) {
      case NotificationType.success:
        return AppColors.success;
      case NotificationType.error:
        return AppColors.error;
      case NotificationType.warning:
        return AppColors.warning;
      case NotificationType.info:
      default:
        return AppColors.info;
    }
  }

  Color _getTextColor() {
    switch (widget.type) {
      case NotificationType.success:
        return AppColors.success;
      case NotificationType.error:
        return AppColors.error;
      case NotificationType.warning:
        return AppColors.warning;
      case NotificationType.info:
      default:
        return AppColors.info;
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case NotificationType.success:
        return Icons.check_circle_outline;
      case NotificationType.error:
        return Icons.error_outline;
      case NotificationType.warning:
        return Icons.warning_amber_outlined;
      case NotificationType.info:
      default:
        return Icons.info_outline;
    }
  }
}

enum NotificationType {
  success,
  error,
  warning,
  info,
}

class NotificationService {
  static OverlayEntry? _overlayEntry;

  static void show(
      BuildContext context, {
        required String title,
        required String message,
        NotificationType type = NotificationType.info,
        bool showIcon = true,
        VoidCallback? onTap,
        VoidCallback? onClose,
        Duration duration = const Duration(seconds: 5),
      }) {
    // Remove existing notification if any
    dismiss();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: NotificationBanner(
          title: title,
          message: message,
          type: type,
          showIcon: showIcon,
          onTap: onTap,
          onClose: () {
            dismiss();
            onClose?.call();
          },
          duration: duration,
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void dismiss() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  static void showSuccess(
      BuildContext context, {
        required String title,
        required String message,
        VoidCallback? onTap,
        VoidCallback? onClose,
        Duration duration = const Duration(seconds: 3),
      }) {
    show(
      context,
      title: title,
      message: message,
      type: NotificationType.success,
      onTap: onTap,
      onClose: onClose,
      duration: duration,
    );
  }

  static void showError(
      BuildContext context, {
        required String title,
        required String message,
        VoidCallback? onTap,
        VoidCallback? onClose,
        Duration duration = const Duration(seconds: 5),
      }) {
    show(
      context,
      title: title,
      message: message,
      type: NotificationType.error,
      onTap: onTap,
      onClose: onClose,
      duration: duration,
    );
  }

  static void showWarning(
      BuildContext context, {
        required String title,
        required String message,
        VoidCallback? onTap,
        VoidCallback? onClose,
        Duration duration = const Duration(seconds: 4),
      }) {
    show(
      context,
      title: title,
      message: message,
      type: NotificationType.warning,
      onTap: onTap,
      onClose: onClose,
      duration: duration,
    );
  }

  static void showInfo(
      BuildContext context, {
        required String title,
        required String message,
        VoidCallback? onTap,
        VoidCallback? onClose,
        Duration duration = const Duration(seconds: 4),
      }) {
    show(
      context,
      title: title,
      message: message,
      type: NotificationType.info,
      onTap: onTap,
      onClose: onClose,
      duration: duration,
    );
  }
}