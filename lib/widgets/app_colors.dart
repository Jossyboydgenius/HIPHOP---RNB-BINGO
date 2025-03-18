import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6267E7);
  static const Color secondary = Color(0xFF8B60EF);
  static const Color accent = Color(0xFFE9515E);

  // Yellow shades
  static const Color yellowPrimary = Color(0xFFFFD217);
  static const Color yellowLight = Color(0xFFFFEE37);
  static const Color yellowDark = Color(0xFFFFAE02);

  // Purple shades
  static const Color purplePrimary = Color(0xFFB26BFB);
  static const Color purpleLight = Color(0xFFB57BFE);
  static const Color purpleDark = Color(0xFF8B60EF);
  static const Color deepPurple = Color(0xFF5B15FF);
  static const Color purpleOverlay = Color(0xFFD3D8FF);
  static const Color purpleTransparent = Color(0x26D3D8FF);

  // Green shades
  static const Color greenBright = Color(0xFF67EB00);
  static const Color greenDark = Color(0xFF4EC307);
  static const Color teal = Color(0xFF3FD6B3);

  // Background colors
  static const Color backgroundDark = Color(0x66101010);
  static const Color backgroundLight = Color(0xFFF0F0F0);
  static const Color backgroundGrey = Color(0xFFD9D9D9);

  // Pink/Red shades
  static const Color pinkPrimary = Color(0xFFFF4672);
  static const Color pinkDark = Color(0xFFE90038);

  // Blue shades
  static const Color bluePrimary = Color(0xFF39C7FF);
  static const Color blueLight = Color(0xFF4CDAFE);
  static const Color blueDark = Color(0xFF08B9FF);

  // Pink/Purple gradient colors
  static const Color gradientPink = Color(0xFFFDA5FF);
  static const Color gradientPinkDark = Color(0xFFFC8AFF);
  static const Color gradientPurple = Color(0xFFDA57F0);

  // Loading bar colors
  static const Color loadingBarStart = Color(0xFF8B60EF);
  static const Color loadingBarEnd = Color(0xFF2A0C32);

  static const LinearGradient loadingBarGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [loadingBarStart, loadingBarEnd],
  );
} 