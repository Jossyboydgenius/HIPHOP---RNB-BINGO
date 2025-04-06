import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io' show Platform;
import 'package:hiphop_rnb_bingo/services/game_sound_service.dart';
import 'app_images.dart';
import 'app_sounds.dart';

class SoundVibrateControls extends StatefulWidget {
  final double topPosition;

  const SoundVibrateControls({
    super.key,
    this.topPosition = 80.0, // Default position
  });

  @override
  State<SoundVibrateControls> createState() => _SoundVibrateControlsState();
}

class _SoundVibrateControlsState extends State<SoundVibrateControls> {
  // Use the GameSoundService instance
  final _soundService = GameSoundService();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16.w,
      top: widget.topPosition.h, // Use the customizable position
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // Toggle sound state
              bool wasEnabled = _soundService.isSoundEnabled;
              _soundService.toggleSound();

              // Play sound only if we're enabling sound (not when disabling)
              if (!wasEnabled && _soundService.isSoundEnabled) {
                _soundService.playButtonClick();
              }

              setState(() {});
            },
            child: AppImages(
              imagePath: _soundService.isSoundEnabled
                  ? AppImageData.soundOn
                  : AppImageData.soundOff,
              width: 32.w,
              height: 32.h,
            ),
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: () {
              // For vibration toggle, we want to vibrate BEFORE disabling
              // vibration (so the user gets feedback) or AFTER enabling it
              bool wasEnabled = _soundService.isVibrateEnabled;

              if (!wasEnabled) {
                // We're turning vibration ON - toggle first, then vibrate
                _soundService.toggleVibrate();

                // Use platform-specific feedback
                if (Platform.isIOS) {
                  _soundService.iosHapticFeedback('medium');
                } else {
                  _soundService.vibrate();
                }
              } else {
                // We're turning vibration OFF - vibrate first, then toggle
                if (Platform.isIOS) {
                  _soundService.iosHapticFeedback('medium');
                } else {
                  _soundService.vibrate();
                }
                _soundService.toggleVibrate();
              }

              // Always play a sound for feedback, regardless of vibration state
              if (_soundService.isSoundEnabled) {
                _soundService.playSound(AppSoundData.buttonClicks);
              }

              setState(() {});
            },
            child: AppImages(
              imagePath: _soundService.isVibrateEnabled
                  ? AppImageData.vibrateOn
                  : AppImageData.vibrateOff,
              width: 32.w,
              height: 32.h,
            ),
          ),
        ],
      ),
    );
  }
}
