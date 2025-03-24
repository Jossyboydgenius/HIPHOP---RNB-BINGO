import 'package:flutter/material.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_images.dart';
import '../widgets/app_text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameDetailsContainer extends StatelessWidget {
  final String host;
  final String dj;
  final String rounds;
  final String musicTheme;
  final String gameType;
  final String? gameFee;
  final List<String> gameStyles;
  final String timeRemaining;
  final String? cardAmount;
  final bool showMoneyIcon;
  final bool showCardIcon;

  const GameDetailsContainer({
    super.key,
    required this.host,
    required this.dj,
    required this.rounds,
    required this.musicTheme,
    required this.gameType,
    required this.gameStyles,
    required this.timeRemaining,
    this.gameFee,
    this.cardAmount,
    this.showMoneyIcon = false,
    this.showCardIcon = false,
  });

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: AppTextStyle.mochiyPopOne(
                fontSize: 8.sp,
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyle.mochiyPopOne(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameFeeRow() {
    if (gameFee == null) return const SizedBox.shrink();
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              'Game Fee',
              style: AppTextStyle.mochiyPopOne(
                fontSize: 8.sp,
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Row(
            children: [
              if (showMoneyIcon) ...[
                AppImages(
                  imagePath: AppImageData.money,
                  height: 16.h,
                ),
                SizedBox(width: 4.w),
              ],
              Text(
                '\$$gameFee',
                style: AppTextStyle.mochiyPopOne(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              if (showCardIcon && cardAmount != null) ...[
                SizedBox(width: 8.w),
                AppImages(
                  imagePath: AppImageData.card,
                  height: 16.h,
                ),
                SizedBox(width: 4.w),
                Text(
                  cardAmount!,
                  style: AppTextStyle.mochiyPopOne(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameStylesRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              'Game Style',
              style: AppTextStyle.mochiyPopOne(
                fontSize: 8.sp,
                color: Colors.grey[500],
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: gameStyles.map((style) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.greenBright,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      style,
                      style: AppTextStyle.mochiyPopOne(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 4.w),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: AppColors.backgroundLight,
              width: 3.w,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      AppImages(
                        imagePath: AppImageData.info,
                        width: 20.w,
                        height: 20.h,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Game Details',
                        style: AppTextStyle.mochiyPopOne(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.pinkDark,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.yellowPrimary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          timeRemaining,
                          style: AppTextStyle.poppins(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Positioned(
                        left: -10,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: AppImages(
                            imagePath: AppImageData.clock,
                            height: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              _buildDetailRow('Host Name', host),
              _buildDetailRow('DJ Name', dj),
              _buildDetailRow('Rounds', rounds),
              _buildDetailRow('Music Theme', musicTheme),
              _buildDetailRow('Music Genre', gameType),
              _buildGameFeeRow(),
              _buildGameStylesRow(),
            ],
          ),
        ),
      ],
    );
  }
} 