import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  bool _isSoundOn = false;
  bool _isVibrateOn = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16.w,
      top: widget.topPosition.h, // Use the customizable position
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // TODO: Handle sound toggle
              setState(() {
                _isSoundOn = !_isSoundOn;
              });
            },
            child: AppImages(
              imagePath:
                  _isSoundOn ? AppImageData.soundOn : AppImageData.soundOff,
              width: 32.w,
              height: 32.h,
            ),
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: () {
              // TODO: Handle vibration toggle
              setState(() {
                _isVibrateOn = !_isVibrateOn;
              });
            },
            child: AppImages(
              imagePath: _isVibrateOn
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
