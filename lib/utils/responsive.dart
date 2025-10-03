import 'package:flutter/material.dart';

class Responsive {
  // Breakpoints
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;

  // Check if screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobile;
  }

  // Check if screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < tablet;
  }

  // Check if screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktop;
  }

  // Get screen type
  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < mobile) {
      return ScreenType.mobile;
    } else if (width < tablet) {
      return ScreenType.tablet;
    } else {
      return ScreenType.desktop;
    }
  }

  // Get responsive value
  static T getValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final screenType = getScreenType(context);

    switch (screenType) {
      case ScreenType.mobile:
        return mobile;
      case ScreenType.tablet:
        return tablet ?? mobile;
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  // Get responsive margin
  static EdgeInsets getMargin(BuildContext context) {
    return getValue(
      context: context,
      mobile: const EdgeInsets.all(16),
      tablet: const EdgeInsets.all(24),
      desktop: const EdgeInsets.all(32),
    );
  }

  // Get responsive padding
  static EdgeInsets getPadding(BuildContext context) {
    return getValue(
      context: context,
      mobile: const EdgeInsets.all(16),
      tablet: const EdgeInsets.all(24),
      desktop: const EdgeInsets.all(32),
    );
  }

  // Get responsive columns
  static int getColumns(BuildContext context) {
    return getValue(
      context: context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
    );
  }

  // Get responsive font size
  static double getFontSize(BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return getValue(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  // Get responsive spacing
  static double getSpacing(BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return getValue(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  // Get responsive aspect ratio
  static double getAspectRatio(BuildContext context) {
    return getValue(
      context: context,
      mobile: 16 / 9,
      tablet: 16 / 10,
      desktop: 16 / 8,
    );
  }

  // Get responsive max width
  static double getMaxWidth(BuildContext context) {
    return getValue(
      context: context,
      mobile: double.infinity,
      tablet: 800,
      desktop: 1200,
    );
  }

  // Get responsive item count
  static int getItemCount(BuildContext context, {
    required int mobile,
    int? tablet,
    int? desktop,
  }) {
    return getValue(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  // Get responsive cross axis count
  static int getCrossAxisCount(BuildContext context) {
    return getValue(
      context: context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    );
  }

  // Get responsive child aspect ratio
  static double getChildAspectRatio(BuildContext context) {
    return getValue(
      context: context,
      mobile: 0.7,
      tablet: 0.8,
      desktop: 0.9,
    );
  }
}

enum ScreenType {
  mobile,
  tablet,
  desktop,
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Responsive.desktop && desktop != null) {
          return desktop!;
        } else if (constraints.maxWidth >= Responsive.mobile && tablet != null) {
          return tablet!;
        } else {
          return mobile;
        }
      },
    );
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenType screenType) builder;

  const ResponsiveBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        ScreenType screenType;

        if (constraints.maxWidth >= Responsive.desktop) {
          screenType = ScreenType.desktop;
        } else if (constraints.maxWidth >= Responsive.mobile) {
          screenType = ScreenType.tablet;
        } else {
          screenType = ScreenType.mobile;
        }

        return builder(context, screenType);
      },
    );
  }
}