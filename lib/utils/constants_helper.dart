import 'package:flutter/material.dart';

class ConstantsHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1024;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1024;
  }

  static double getResponsiveCardWidth(BuildContext context) {
    if (isMobile(context)) {
      return MediaQuery.of(context).size.width * 0.9;
    } else if (isTablet(context)) {
      return 500;
    } else {
      return 400;
    }
  }

  static double getResponsiveCardHeight(BuildContext context) {
    if (isMobile(context)) {
      return MediaQuery.of(context).size.height * 0.7;
    } else if (isTablet(context)) {
      return 700;
    } else {
      return 600;
    }
  }
}
