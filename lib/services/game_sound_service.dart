import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
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

  // Getters for state
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isVibrateEnabled => _isVibrateEnabled;

  // Initialize the service
  Future<void> initialize() async {
    // Set global options
    await _effectsPlayer.setReleaseMode(ReleaseMode.stop);
    await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
    await _backgroundPlayer.setVolume(0.5); // Lower volume for background music

    // Check if device can vibrate
    _canVibrate = await Vibrate.canVibrate;
  }

  // Toggle sound on/off
  void toggleSound() {
    _isSoundEnabled = !_isSoundEnabled;

    // Vibrate when toggle sound
    if (_isVibrateEnabled) {
      vibrate();
    }

    if (!_isSoundEnabled) {
      _effectsPlayer.stop();
      _backgroundPlayer.stop();
    }
  }

  // Toggle vibration on/off
  void toggleVibrate() {
    _isVibrateEnabled = !_isVibrateEnabled;

    // Vibrate when toggle is turned ON to provide feedback
    if (_isVibrateEnabled) {
      vibrate();
    }
  }

  // Check if vibration is available on the device
  Future<bool> checkVibrationAvailability() async {
    return await Vibrate.canVibrate;
  }

  // Perform vibration if enabled
  Future<void> vibrate() async {
    if (_isVibrateEnabled && _canVibrate) {
      Vibrate.feedback(FeedbackType.light);
    }
  }

  // Perform medium vibration
  Future<void> vibrateMedium() async {
    if (_isVibrateEnabled && _canVibrate) {
      Vibrate.feedback(FeedbackType.medium);
    }
  }

  // Perform heavy vibration for important events
  Future<void> vibrateHeavy() async {
    if (_isVibrateEnabled && _canVibrate) {
      Vibrate.feedback(FeedbackType.heavy);
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

  // Play button click sound
  Future<void> playButtonClick() async {
    await playSound(AppSoundData.buttonClicks);
    await vibrate();
  }

  // Play alert popup sound
  Future<void> playAlertPopup() async {
    await playSound(AppSoundData.alertPopups);
    await vibrateMedium();
  }

  // Play bingo board tap sound
  Future<void> playBoardTap() async {
    await playSound(AppSoundData.boardTap);
    await vibrate();
  }

  // Play correct bingo sound
  Future<void> playCorrectBingo() async {
    await playSound(AppSoundData.correctBingo);
    await vibrateHeavy();
  }

  // Play wrong bingo sound
  Future<void> playWrongBingo() async {
    await playSound(AppSoundData.wrongBingo);
    await vibrateMedium();
  }

  // Play new round sound
  Future<void> playNewRound() async {
    await playSound(AppSoundData.newRound);
    await vibrateMedium();
  }

  // Play prize win sound
  Future<void> playPrizeWin() async {
    await playSound(AppSoundData.prizeWin);
    await vibrateHeavy();
  }

  // Clean up resources
  void dispose() {
    _effectsPlayer.dispose();
    _backgroundPlayer.dispose();
  }
}
