import 'package:flutter/material.dart';
import 'package:hiphop_rnb_bingo/services/game_sound_service.dart';

/// App sound paths used throughout the application
class AppSoundData {
  // Default sound paths
  static const String alertPopups = 'assets/sounds/Alert-popups.mp3';
  static const String appLaunch = 'assets/sounds/App-launch.mp3';
  static const String boardTap = 'assets/sounds/Board-tap.mp3';
  static const String buttonClicks = 'assets/sounds/Button-clicks.mp3';
  static const String correctBingo = 'assets/sounds/Correct-Bingo.mp3';
  static const String newRound = 'assets/sounds/New-round.mp3';
  static const String prizeWin = 'assets/sounds/Prize-win.mp3';
  static const String wrongBingo = 'assets/sounds/Wrong-Bingo.mp3';
}

/// Widget to expose sound functionality with optional callback for widget interaction
class AppSounds extends StatefulWidget {
  final Widget child;
  final Function()? onTap;
  final String? soundPath;
  final bool playOnLoad;

  const AppSounds({
    super.key,
    required this.child,
    this.onTap,
    this.soundPath,
    this.playOnLoad = false,
  });

  @override
  State<AppSounds> createState() => _AppSoundsState();
}

class _AppSoundsState extends State<AppSounds> {
  final _soundService = GameSoundService();

  @override
  void initState() {
    super.initState();
    if (widget.playOnLoad && widget.soundPath != null) {
      // Play sound when widget loads
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _soundService.playSound(widget.soundPath!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap != null && widget.soundPath != null) {
      return GestureDetector(
        onTap: () {
          // Play sound with haptic feedback and execute callback
          _soundService.playSound(widget.soundPath!);
          _soundService.vibrate(); // Add haptic feedback
          widget.onTap!();
        },
        child: widget.child,
      );
    }

    return widget.child;
  }
}
