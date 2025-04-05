import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/services/game_sound_service.dart';
import 'app_images.dart';

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
              setState(() {
                _soundService.toggleSound();
                // Note: vibration feedback is already handled in toggleSound()
              });
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
              setState(() {
                _soundService.toggleVibrate();
                // Note: vibration feedback is already handled in toggleVibrate()
              });
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
