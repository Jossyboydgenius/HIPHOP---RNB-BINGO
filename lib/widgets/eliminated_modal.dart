import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/widgets/app_button.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/app_gif.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'package:hiphop_rnb_bingo/widgets/app_modal_container.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';
import 'package:hiphop_rnb_bingo/services/game_sound_service.dart';

class EliminatedModal extends StatefulWidget {
  final VoidCallback onTryAgain;

  const EliminatedModal({
    super.key,
    required this.onTryAgain,
  });

  @override
  State<EliminatedModal> createState() => _EliminatedModalState();
}

class _EliminatedModalState extends State<EliminatedModal>
    with SingleTickerProviderStateMixin {
  final _soundService = GameSoundService();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Main modal container
          AppModalContainer(
            width: AppDimension.isSmall ? 320.w : 280.w,
            height: AppDimension.isSmall ? 380.h : 300.h,
            fillColor: Colors.white,
            borderColor: Colors.white,
            layerColor: AppColors.purpleOverlay,
            showCloseButton: false,
            handleBackNavigation: true,
            onClose: () {
              // Empty function - we'll handle close via button
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 20.h,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Crying emoji GIF
                  AppGif(
                    gifPath: AppGifData.cryingEmoji,
                    width: 120.w,
                    height: 120.h,
                  ),

                  SizedBox(height: 40.h),

                  // Try Again button
                  SizedBox(
                    width: AppDimension.isSmall ? 180.w : 180.w,
                    child: AppButton(
                      text: 'Try Again',
                      textStyle: AppTextStyle.poppins(
                        fontSize: AppDimension.isSmall ? 16.sp : 16.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      fillColor: AppColors.darkPurple,
                      layerColor: AppColors.darkPurple2,
                      extraLayerColor: AppColors.purpleOverlay,
                      extraLayerHeight: AppDimension.isSmall ? 70.h : 50.h,
                      extraLayerTopPosition: 4.h,
                      extraLayerOffset: 1,
                      height: AppDimension.isSmall ? 70.h : 50.h,
                      layerHeight: AppDimension.isSmall ? 57.h : 44.h,
                      layerTopPosition: -1.5.h,
                      hasBorder: true,
                      borderColor: Colors.white,
                      onPressed: () {
                        _soundService.playButtonClick();
                        // First close the modal
                        Navigator.of(context).pop();
                        // Then call the onTryAgain callback
                        widget.onTryAgain();
                      },
                      borderRadius: 24.r,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Eliminated banner
          Positioned(
            top: -95.h,
            child: AppImages(
              imagePath: AppImageData.eliminated,
              width: 340.w,
              height: 140.h,
            ),
          ),
        ],
      ),
    );
  }
}
