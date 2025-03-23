import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hiphop_rnb_bingo/widgets/app_button.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'package:hiphop_rnb_bingo/widgets/app_modal_container.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'package:hiphop_rnb_bingo/widgets/app_icons.dart';

class BoardPurchaseSuccessModal extends StatefulWidget {
  final VoidCallback onClose;
  final String amount;

  const BoardPurchaseSuccessModal({
    super.key,
    required this.onClose,
    required this.amount,
  });

  @override
  State<BoardPurchaseSuccessModal> createState() => _BoardPurchaseSuccessModalState();
}

class _BoardPurchaseSuccessModalState extends State<BoardPurchaseSuccessModal> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppModalContainer(
                width: 300,
                height: 300,
                fillColor: AppColors.purplePrimary,
                borderColor: AppColors.purpleLight,
                layerColor: AppColors.purpleDark,
                layerTopPosition: -4,
                borderRadius: 24,
                showCloseButton: false,
                onClose: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        RotationTransition(
                          turns: _controller,
                          child: const AppIcons(
                            icon: AppIconData.glowing,
                            size: 130,
                          ),
                        ),
                        const AppImages(
                          imagePath: AppImageData.card,
                          width: 90,
                          height: 90,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '+${widget.amount}',
                          style: AppTextStyle.textWithStroke(
                            fontSize: 68,
                            textColor: AppColors.deepPurple,
                            strokeColor: Colors.white,
                            strokeWidth: 4,
                            fontFamily: AppTextStyle.poppinsFont,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Added',
                      style: AppTextStyle.textWithStroke(
                        fontSize: 12,
                        textColor: Colors.white,
                        strokeColor: AppColors.darkPurple3,
                        strokeWidth: 5,
                        fontFamily: AppTextStyle.mochiyPopOneFont,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                child: AppButton(
                  text: 'Continue',
                  textStyle: AppTextStyle.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  fillColor: AppColors.darkPurple,
                  layerColor: AppColors.darkPurple2,
                  height: 60,
                  layerHeight: 50,
                  layerTopPosition: -2,
                  hasBorder: true,
                  borderColor: Colors.white,
                  onPressed: widget.onClose,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 