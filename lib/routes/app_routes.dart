import 'package:flutter/material.dart';
import '../views/splash_screen.dart';
import '../views/onboarding_screen.dart';
import '../views/home_screen.dart';
import '../views/qr_code_scanner_screen.dart';
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String qrCodeScanner = '/qrCodeScanner';

  static const String initialRoute = qrCodeScanner;

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    home: (context) => const HomeScreen(),
    qrCodeScanner: (context) => const QRCodeScannerScreen(),
  };
} 