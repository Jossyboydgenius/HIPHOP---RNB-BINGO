import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/widgets/app_banner.dart';
import 'package:hiphop_rnb_bingo/widgets/app_button.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/app_icons.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'package:hiphop_rnb_bingo/widgets/app_in_app_purchase_card.dart';
import 'package:hiphop_rnb_bingo/widgets/app_modal_container.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'package:hiphop_rnb_bingo/widgets/board_purchase_success_modal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/balance/balance_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/balance/balance_event.dart';
import 'package:hiphop_rnb_bingo/blocs/balance/balance_state.dart';
import 'package:hiphop_rnb_bingo/widgets/wallet_funding_modal.dart';
import 'package:hiphop_rnb_bingo/widgets/app_toast.dart';

class BingoBoardsStoreModal extends StatelessWidget {
  final VoidCallback onClose;

  const BingoBoardsStoreModal({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BalanceBloc, BalanceState>(
      builder: (context, state) {
        final purchaseOptions = [
          {'amount': '1', 'price': '15', 'title': 'Solo Board'},
          {'amount': '3', 'price': '40', 'title': 'Triple Board'},
          {'amount': '7', 'price': '100', 'title': 'Pro Board'},
          {'amount': '10', 'price': '140', 'title': 'Ultimate Board'},
        ];

        void handlePurchase(Map<String, String> option) {
          final currentGems = state.gemBalance;
          final requiredGems = int.parse(option['price']!);
          final boardsToAdd = int.parse(option['amount']!);
          final boardTitle = option['title']!;
          
          if (currentGems >= requiredGems) {
            context.read<BalanceBloc>().add(
              UpdateGemBalance(currentGems - requiredGems)
            );
            context.read<BalanceBloc>().add(
              UpdateBoardBalance(state.boardBalance + boardsToAdd)
            );
            
            // Show both success toast and modal
            AppToast.show(
              context,
              'You have successfully purchased $boardTitle using $requiredGems Diamonds!',
              showCloseIcon: false,
              showInfoIcon: true,
              textColor: AppColors.greenDark,
              backgroundColor: AppColors.greenLight,
              borderColor: AppColors.greenDark,
              infoIcon: AppImageData.info3,
            );
            
            Navigator.pop(context);
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => BoardPurchaseSuccessModal(
                amount: option['amount']!,
                onClose: () => Navigator.pop(context),
              ),
            );
          } else {
            // Error toast
            AppToast.show(
              context,
              'You don\'t have enough Diamonds to complete this purchase.',
              showCloseIcon: false,
              showInfoIcon: true,
              textColor: AppColors.pinkDark,
              backgroundColor: AppColors.redLight,
              borderColor: AppColors.pinkDark,
              infoIcon: AppImageData.info,
            );
          }
        }

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
                    padding: EdgeInsets.only(bottom: 32.h, top: 0),
                    child: Row(
                      children: [
                        AppImages(
                          imagePath: AppImageData.back,
                          height: 38.h,
                          width: 38.w,
                          onPressed: onClose,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Store',
                              style: AppTextStyle.mochiyPopOne(
                                fontSize: 20.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 42.w),
                      ],
                    ),
                  ),
                  // Banner
                  Padding(
                    padding: EdgeInsets.only(bottom: 32.h),
                    child: AppBanner(
                      text: 'Bingo Boards',
                      fillColor: AppColors.blueLight3,
                      borderColor: AppColors.deepBlue,
                      textStyle: AppTextStyle.textWithStroke(
                        fontSize: 16.sp,
                        textColor: Colors.white,
                        strokeColor: AppColors.deepBlue,
                        strokeWidth: 3.w,
                      ),
                    ),
                  ),
                  // Modal container with purchase cards
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AppModalContainer(
                        width: double.infinity,
                        height: 305.h,
                        fillColor: Colors.white,
                        borderColor: AppColors.purplePrimary,
                        layerColor: AppColors.purpleDark,
                        layerTopPosition: -4.h,
                        borderRadius: 24.r,
                        showCloseButton: false,
                        onClose: () {},
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 24.h,
                          crossAxisSpacing: 24.w,
                          padding: EdgeInsets.fromLTRB(26.w, 26.h, 26.w, 26.h),
                          childAspectRatio: 0.9,
                          children: purchaseOptions.map((option) {
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                AppInAppPurchaseCard(
                                  amount: option['amount']!,
                                  price: option['price']!,
                                  plusValue: '',
                                  iconPath: AppImageData.card,
                                  bannerColor: AppColors.pinkLight2,
                                  isGemCard: false,
                                  onGetPressed: () => handlePurchase(option),
                                ),
                                Positioned(
                                  top: -4.h,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.pinkLight2,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.r),
                                        topRight: Radius.circular(8.r),
                                      ),
                                    ),
                                    child: Text(
                                      option['title']!,
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.mochiyPopOne(
                                        fontSize: 8.sp,
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
                  // Boards amount
                  Padding(
                    padding: EdgeInsets.only(top: 36.h),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.purplePrimary,
                            borderRadius: BorderRadius.circular(100.r),
                            border: Border.all(color: Colors.white, width: 1.w),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Text(
                              state.gemBalance.toString(),
                              style: AppTextStyle.poppins(
                                fontSize: 14.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: -12.w,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: AppIcons(
                              icon: AppIconData.gem,
                              size: 32.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Diamond button
                  Padding(
                    padding: EdgeInsets.only(top: 36.h),
                    child: SizedBox(
                      width: 180.w,
                      child: AppButton(
                        text: 'Diamond',
                        textStyle: AppTextStyle.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                        fillColor: AppColors.pinkDark2,
                        layerColor: AppColors.pinkLight,
                        height: 50.h,
                        layerHeight: 42.h,
                        layerTopPosition: -2.h,
                        hasBorder: true,
                        borderColor: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => WalletFundingModal(
                              onClose: () => Navigator.pop(context),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 36.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 