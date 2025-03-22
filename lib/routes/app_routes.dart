import 'package:flutter/material.dart';
import '../views/splash_screen.dart';
import '../views/onboarding_screen.dart';
import '../views/home_screen.dart';
import '../views/qr_code_scanner_screen.dart';
import '../views/game_details_screen.dart';
import '../views/input_code_screen.dart';
import '../views/remote_game_details_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String qrCodeScanner = '/qrCodeScanner';
  static const String gameDetails = '/gameDetails';
  static const String inputCode = '/inputCode';
  static const String remoteGameDetails = '/remoteGameDetails';

  static const String initialRoute = splash;

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    home: (context) => const HomeScreen(),
    qrCodeScanner: (context) => const QRCodeScannerScreen(isInPerson: false), // Default to remote
    gameDetails: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as String?;
      return GameDetailsScreen(code: args);
    },
    inputCode: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as bool?;
      return InputCodeScreen(isInPerson: args ?? false);
    },
    remoteGameDetails: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as String?;
      return RemoteGameDetailsScreen(code: args);
    },
  };
} 