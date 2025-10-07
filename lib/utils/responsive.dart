import 'package:flutter/material.dart';

class Responsive {
  // Breakpoints
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;

  // Check if mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobile;
  }

  // Check if tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < tablet;
  }

  // Check if desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tablet;
  }

  // Get screen width
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // Get screen height
  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Get responsive value
  static T getValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    }
    return mobile;
  }

  // Get responsive padding
  static EdgeInsets getPadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.all(32);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24);
    }
    return const EdgeInsets.all(16);
  }

  // Get responsive margin
  static EdgeInsets getMargin(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.all(24);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(16);
    }
    return const EdgeInsets.all(12);
  }

  // Get responsive columns
  static int getColumns(BuildContext context) {
    if (isDesktop(context)) {
      return 3;
    } else if (isTablet(context)) {
      return 2;
    }
    return 1;
  }

  // Get responsive font size
  static double getFontSize(BuildContext context, double mobileSize) {
    if (isDesktop(context)) {
      return mobileSize * 1.2;
    } else if (isTablet(context)) {
      return mobileSize * 1.1;
    }
    return mobileSize;
  }
}