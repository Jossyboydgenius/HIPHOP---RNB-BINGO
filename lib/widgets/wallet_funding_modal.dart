import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/blocs/balance/balance_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/balance/balance_event.dart';
import 'package:hiphop_rnb_bingo/blocs/balance/balance_state.dart';
import 'package:hiphop_rnb_bingo/widgets/app_banner.dart';
import 'package:hiphop_rnb_bingo/widgets/app_button.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/app_icons.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'package:hiphop_rnb_bingo/widgets/app_in_app_purchase_card.dart';
import 'package:hiphop_rnb_bingo/widgets/app_modal_container.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'package:hiphop_rnb_bingo/widgets/payment_options_modal.dart';
import 'package:hiphop_rnb_bingo/widgets/bingo_boards_store_modal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';

class WalletFundingModal extends StatelessWidget {
  final VoidCallback onClose;

  const WalletFundingModal({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final purchaseOptions = [
      {'amount': '25', 'price': '25', 'title': 'Silver'},
      {'amount': '50', 'price': '48', 'title': 'Silver'},
      {'amount': '100', 'price': '75', 'title': 'Platinum'},
      {'amount': '500', 'price': '460', 'title': 'Cave of Diamonds'},
    ];

    return BlocBuilder<BalanceBloc, BalanceState>(
      builder: (context, state) {
        return Container(
          color: Colors.black54,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header section with back button
                  Padding(
                    padding: EdgeInsets.only(bottom: AppDimension.isSmall ? 42.h : 32.h),
                    child: Row(
                      children: [
                        AppImages(
                          imagePath: AppImageData.back,
                          height: AppDimension.isSmall ? 45.h : 38.h,
                          width: AppDimension.isSmall ? 45.w : 38.w,
                          onPressed: onClose,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Wallet',
                              style: AppTextStyle.mochiyPopOne(
                                fontSize: AppDimension.isSmall ? 24.sp : 20.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppDimension.isSmall ? 45.w : 42.w),
                      ],
                    ),
                  ),
                  // Banner
                  Padding(
                    padding: EdgeInsets.only(bottom: AppDimension.isSmall ? 42.h : 32.h),
                    child: AppBanner(
                      text: 'Gems',
                      fillColor: AppColors.purplePrimary,
                      borderColor: AppColors.purpleDark,
                      textStyle: AppTextStyle.textWithStroke(
                        fontSize: AppDimension.isSmall ? 20.sp : 16.sp,
                        textColor: Colors.white,
                        strokeColor: AppColors.purpleDark,
                        strokeWidth: AppDimension.isSmall ? 4.w : 3.w,
                      ),
                      width: AppDimension.isSmall ? 180.w : 180.w,
                      // height: AppDimension.isSmall ? 45.h : 38.h,
                    ),
                  ),
                  // const SizedBox(height: 6),
                  // Modal container with purchase cards
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AppModalContainer(
                        width: double.infinity,
                        height: AppDimension.isSmall ? 600.h : 305.h,
                        fillColor: Colors.white,
                        borderColor: AppColors.purplePrimary,
                        layerColor: AppColors.purpleDark,
                        layerTopPosition: -4.h,
                        borderRadius: AppDimension.isSmall ? 32.r : 24.r,
                        showCloseButton: false,
                        onClose: () {},
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: AppDimension.isSmall ? 32.h : 24.h,
                          crossAxisSpacing: AppDimension.isSmall ? 32.w : 24.w,
                          padding: EdgeInsets.fromLTRB(
                            AppDimension.isSmall ? 26.w : 26.w,
                            AppDimension.isSmall ? 32.h : 26.h,
                            AppDimension.isSmall ? 26.w : 26.w,
                            AppDimension.isSmall ? 32.h : 26.h,
                          ),
                          childAspectRatio: AppDimension.isSmall ? 0.85 : 0.9,
                          children: purchaseOptions.map((option) {
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                AppInAppPurchaseCard(
                                  amount: option['amount']!,
                                  price: option['price']!,
                                  plusValue: '',
                                  iconPath: AppImageData.gem,
                                  bannerColor: AppColors.pinkPrimary,
                                  isGemCard: true,
                                  onGetPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => PaymentOptionsModal(
                                        isInAppPurchase: true,
                                        onClose: () => Navigator.pop(context),
                                        onPaymentSelected: (platform) {
                                          final currentGems = state.gemBalance;
                                          final gemsToAdd = int.parse(option['amount']!);
                                          
                                          context.read<BalanceBloc>().add(
                                            UpdateGemBalance(currentGems + gemsToAdd)
                                          );
                                          
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  top: -4.h,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: AppDimension.isSmall ? 12.w : 8.w,
                                      vertical: AppDimension.isSmall ? 8.h : 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.pinkPrimary,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(AppDimension.isSmall ? 12.r : 8.r),
                                        topRight: Radius.circular(AppDimension.isSmall ? 12.r : 8.r),
                                      ),
                                    ),
                                    child: Text(
                                      option['title']!,
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.mochiyPopOne(
                                        fontSize: AppDimension.isSmall ? 8.sp : 8.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: AppDimension.isSmall ? 50.h : 20.h),
                  // Gem amount
                  Padding(
                    padding: EdgeInsets.only(top: AppDimension.isSmall ? 26.h : 36.h),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimension.isSmall ? 12.w : 16.w,
                            vertical: AppDimension.isSmall ? 6.h : 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.purplePrimary,
                            borderRadius: BorderRadius.circular(100.r),
                            border: Border.all(
                              color: Colors.white,
                              width: AppDimension.isSmall ? 2.w : 1.w,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: AppDimension.isSmall ? 14.w : 10.w),
                            child: Text(
                              state.gemBalance.toString(),
                              style: AppTextStyle.poppins(
                                fontSize: AppDimension.isSmall ? 14.sp : 14.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: AppDimension.isSmall ? -16.w : -12.w,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: AppIcons(
                              icon: AppIconData.gem,
                              size: AppDimension.isSmall ? 38.w : 32.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Store button
                  Padding(
                    padding: EdgeInsets.only(top: AppDimension.isSmall ? 26.h : 30.h),
                    child: SizedBox(
                      width: AppDimension.isSmall ? 180.w : 180.w,
                      child: AppButton(
                        text: 'Store',
                        textStyle: AppTextStyle.poppins(
                          fontSize: AppDimension.isSmall ? 22.sp : 18.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                        fillColor: AppColors.pinkDark,
                        layerColor: AppColors.pinkPrimary,
                        height: AppDimension.isSmall ? 70.h : 50.h,
                        layerHeight: AppDimension.isSmall ? 55.h : 42.h,
                        layerTopPosition: -2.h,
                        hasBorder: true,
                        borderColor: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) => BingoBoardsStoreModal(
                              onClose: () => Navigator.pop(context),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: AppDimension.isSmall ? 60.w : 70.w),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 