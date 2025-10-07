import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class ProgressBar extends StatelessWidget {
  final double progress;
  final double? height;
  final Color? backgroundColor;
  final Color? progressColor;
  final BorderRadius? borderRadius;

  const ProgressBar({
    super.key,
    required this.progress,
    this.height,
    this.backgroundColor,
    this.progressColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 8,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.background,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: progressColor ?? AppColors.primary,
            borderRadius: borderRadius ?? BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}