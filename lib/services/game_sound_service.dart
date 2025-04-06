import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:hiphop_rnb_bingo/widgets/app_sounds.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

/// Service to manage all game sounds throughout the application
class GameSoundService {
  // Singleton instance
  static final GameSoundService _instance = GameSoundService._internal();
  factory GameSoundService() => _instance;
  GameSoundService._internal();

  // Audio player instances
  final AudioPlayer _effectsPlayer = AudioPlayer();
  final AudioPlayer _backgroundPlayer = AudioPlayer();

  // Sound state
  bool _isSoundEnabled = true;
  bool _isVibrateEnabled = true;
  bool _canVibrate = false;
  bool _hasAdvancedHaptics = false; // For iOS CoreHaptics

  // Getters for state
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isVibrateEnabled => _isVibrateEnabled;

  // Initialize the service
  Future<void> initialize() async {
    // Set global options
    await _effectsPlayer.setReleaseMode(ReleaseMode.stop);
    await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
    await _backgroundPlayer.setVolume(0.5); // Lower volume for background music

    // Check if device can vibrate and has advanced haptics
    try {
      _canVibrate = await Vibrate.canVibrate;

      // Check for iOS devices with CoreHaptics (iPhone 8 and newer)
      if (Platform.isIOS) {
        // Different versions of flutter_vibrate have different method names
        try {
          _hasAdvancedHaptics = await Vibrate.canVibrate;
          if (kDebugMode) {
            print('iOS device supports haptic feedback: $_hasAdvancedHaptics');
          }
        } catch (e) {
          _hasAdvancedHaptics = false;
          if (kDebugMode) {
            print('Error checking iOS haptics support: $e');
          }
        }
      }

      if (kDebugMode) {
        print('Device can vibrate: $_canVibrate');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking vibration capability: $e');
      }
      _canVibrate = false;
    }
  }

  // Toggle sound on/off
  void toggleSound() {
    _isSoundEnabled = !_isSoundEnabled;

    // Remove automatic vibration since we handle it in the widget

    if (!_isSoundEnabled) {
      _effectsPlayer.stop();
      _backgroundPlayer.stop();
    }
  }

  // Toggle vibration on/off
  void toggleVibrate() {
    _isVibrateEnabled = !_isVibrateEnabled;

    // Remove automatic vibration since we handle it in the widget
  }

  // Check if vibration is available on the device
  Future<bool> checkVibrationAvailability() async {
    bool canVibrate = await Vibrate.canVibrate;

    // Additional check for iOS devices
    if (Platform.isIOS && canVibrate) {
      if (kDebugMode) {
        print('iOS device supports vibration');
      }
    }

    return canVibrate;
  }

  // Perform vibration if enabled - optimized for iOS
  Future<void> vibrate() async {
    if (!_isVibrateEnabled) return;

    try {
      // Use different approaches depending on the platform
      if (Platform.isIOS) {
        // iOS specific haptic feedback
        if (_hasAdvancedHaptics) {
          // Use CoreHaptics-compatible feedback type
          Vibrate.feedback(FeedbackType.selection);
        } else {
          // Fallback for older iOS devices
          HapticFeedback.selectionClick();
        }

        if (kDebugMode) {
          print('iOS haptic feedback triggered');
        }
      } else {
        // Android vibration
        Vibrate.feedback(FeedbackType.light);
        if (kDebugMode) {
          print('Android light vibration triggered');
        }
      }
    } catch (e) {
      // Fallback to built-in haptic feedback if flutter_vibrate fails
      try {
        // Use selection click which works well across platforms
        HapticFeedback.selectionClick();
        if (kDebugMode) {
          print('Fallback haptic feedback triggered');
        }
      } catch (e2) {
        if (kDebugMode) {
          print('Error during vibration: $e\nFallback error: $e2');
        }
      }
    }
  }

  // Perform medium vibration - optimized for iOS
  Future<void> vibrateMedium() async {
    if (!_isVibrateEnabled) return;

    try {
      // Use different approaches depending on the platform
      if (Platform.isIOS) {
        // iOS specific haptic feedback
        if (_hasAdvancedHaptics) {
          // Use CoreHaptics-compatible feedback type
          Vibrate.feedback(FeedbackType.warning);
        } else {
          // Fallback for older iOS devices
          HapticFeedback.mediumImpact();
        }

        if (kDebugMode) {
          print('iOS medium haptic feedback triggered');
        }
      } else {
        // Android vibration
        Vibrate.feedback(FeedbackType.medium);
        if (kDebugMode) {
          print('Android medium vibration triggered');
        }
      }
    } catch (e) {
      // Fallback to built-in haptic feedback if flutter_vibrate fails
      try {
        HapticFeedback.mediumImpact();
        if (kDebugMode) {
          print('Fallback medium haptic feedback triggered');
        }
      } catch (e2) {
        if (kDebugMode) {
          print('Error during medium vibration: $e\nFallback error: $e2');
        }
      }
    }
  }

  // Perform heavy vibration - optimized for iOS
  Future<void> vibrateHeavy() async {
    if (!_isVibrateEnabled) return;

    try {
      // Use different approaches depending on the platform
      if (Platform.isIOS) {
        // iOS specific haptic feedback
        if (_hasAdvancedHaptics) {
          // Use CoreHaptics-compatible feedback type
          Vibrate.feedback(FeedbackType.error);
        } else {
          // Fallback for older iOS devices
          HapticFeedback.heavyImpact();
        }

        if (kDebugMode) {
          print('iOS heavy haptic feedback triggered');
        }
      } else {
        // Android vibration
        Vibrate.feedback(FeedbackType.heavy);
        if (kDebugMode) {
          print('Android heavy vibration triggered');
        }
      }
    } catch (e) {
      // Fallback to built-in haptic feedback if flutter_vibrate fails
      try {
        HapticFeedback.heavyImpact();
        if (kDebugMode) {
          print('Fallback heavy haptic feedback triggered');
        }
      } catch (e2) {
        if (kDebugMode) {
          print('Error during heavy vibration: $e\nFallback error: $e2');
        }
      }
    }
  }

  // Play a sound effect
  Future<void> playSound(String soundPath) async {
    if (!_isSoundEnabled) return;

    try {
      await _effectsPlayer.stop(); // Stop previous sound
      await _effectsPlayer
          .play(AssetSource(soundPath.replaceFirst('assets/', '')));
    } catch (e) {
      if (kDebugMode) {
        print('Error playing sound: $e');
      }
    }
  }

  // Play background music
  Future<void> playBackgroundMusic(String soundPath) async {
    if (!_isSoundEnabled) return;

    try {
      await _backgroundPlayer.stop(); // Stop previous music
      await _backgroundPlayer
          .play(AssetSource(soundPath.replaceFirst('assets/', '')));
    } catch (e) {
      if (kDebugMode) {
        print('Error playing background music: $e');
      }
    }
  }

  // Perform iOS-specific haptic feedback
  Future<void> iosHapticFeedback(String type) async {
    if (!_isVibrateEnabled) return;

    try {
      switch (type) {
        case 'light':
          HapticFeedback.selectionClick();
          break;
        case 'medium':
          HapticFeedback.mediumImpact();
          break;
        case 'heavy':
          HapticFeedback.heavyImpact();
          break;
        case 'success':
          // Success pattern - two light taps followed by one medium
          HapticFeedback.selectionClick();
          await Future.delayed(const Duration(milliseconds: 100));
          HapticFeedback.selectionClick();
          await Future.delayed(const Duration(milliseconds: 150));
          HapticFeedback.mediumImpact();
          break;
        case 'error':
          // Error pattern - one medium, short pause, one heavy
          HapticFeedback.mediumImpact();
          await Future.delayed(const Duration(milliseconds: 150));
          HapticFeedback.heavyImpact();
          break;
        case 'warning':
          // Warning pattern - one light, short pause, one medium
          HapticFeedback.selectionClick();
          await Future.delayed(const Duration(milliseconds: 150));
          HapticFeedback.mediumImpact();
          break;
        default:
          HapticFeedback.selectionClick();
      }

      if (kDebugMode) {
        print('iOS specific haptic feedback: $type');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error performing iOS haptic feedback: $e');
      }
    }
  }

  // Play button click sound with optimized haptics for iOS
  Future<void> playButtonClick() async {
    await playSound(AppSoundData.buttonClicks);

    // Use platform-specific vibration for best experience
    if (Platform.isIOS) {
      await iosHapticFeedback('light');
    } else {
      await vibrate();
    }
  }

  // Play alert popup sound
  Future<void> playAlertPopup() async {
    await playSound(AppSoundData.alertPopups);

    // Use platform-specific vibration for best experience
    if (Platform.isIOS) {
      await iosHapticFeedback('warning');
    } else {
      await vibrateMedium();
    }
  }

  // Play bingo board tap sound
  Future<void> playBoardTap() async {
    await playSound(AppSoundData.boardTap);

    // Use platform-specific vibration for best experience
    if (Platform.isIOS) {
      await iosHapticFeedback('light');
    } else {
      await vibrate();
    }
  }

  // Play correct bingo sound
  Future<void> playCorrectBingo() async {
    await playSound(AppSoundData.correctBingo);

    // Use platform-specific vibration for best experience
    if (Platform.isIOS) {
      await iosHapticFeedback('success');
    } else {
      await vibrateHeavy();
    }
  }

  // Play wrong bingo sound
  Future<void> playWrongBingo() async {
    await playSound(AppSoundData.wrongBingo);

    // Use platform-specific vibration for best experience
    if (Platform.isIOS) {
      await iosHapticFeedback('error');
    } else {
      await vibrateMedium();
    }
  }

  // Play new round sound
  Future<void> playNewRound() async {
    await playSound(AppSoundData.newRound);

    // Use platform-specific vibration for best experience
    if (Platform.isIOS) {
      await iosHapticFeedback('medium');
    } else {
      await vibrateMedium();
    }
  }

  // Play prize win sound
  Future<void> playPrizeWin() async {
    await playSound(AppSoundData.prizeWin);

    // Use platform-specific vibration for best experience
    if (Platform.isIOS) {
      await iosHapticFeedback('success');
    } else {
      await vibrateHeavy();
    }
  }

  // Clean up resources
  void dispose() {
    _effectsPlayer.dispose();
    _backgroundPlayer.dispose();
  }
}
