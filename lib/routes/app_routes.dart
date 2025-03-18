import 'package:flutter/material.dart';
import '../views/splash_screen.dart';
import '../views/onboarding_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';

  static const String initialRoute = splash;

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
  };
} 