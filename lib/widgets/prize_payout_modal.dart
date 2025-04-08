import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/blocs/balance/balance_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/balance/balance_state.dart';
import 'package:hiphop_rnb_bingo/widgets/app_button.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'package:hiphop_rnb_bingo/widgets/app_modal_container.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'package:hiphop_rnb_bingo/widgets/fund_withdrawal_modal.dart';

class PrizePayoutModal extends StatelessWidget {
  final VoidCallback onClose;

  const PrizePayoutModal({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BalanceBloc, BalanceState>(
      builder: (context, state) {
        final balance = state.moneyBalance;

        return Container(
          color: Colors.black54,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppModalContainer(
                    width: double.infinity,
                    height: AppDimension.isSmall ? 320.h : 300.h,
                    fillColor: AppColors.purplePrimary,
                    borderColor: AppColors.purplePrimary,
                    layerColor: AppColors.purpleDark,
                    layerTopPosition: -4.h,
                    borderRadius: AppDimension.isSmall ? 24.r : 20.r,
                    title: 'Prize Payout',
                    onClose: onClose,
                    titleStyle: AppTextStyle.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 24.w),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24.w, vertical: 16.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: AppColors.purplePrimary,
                                  width: 3,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppImages(
                                    imagePath: AppImageData.money,
                                    width: 24.w,
                                    height: 24.h,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    '\$$balance',
                                    style: AppTextStyle.poppins(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 8.h),

                        // Bottom text
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 0),
                          child: Text(
                            'Click of payout when you are ready to\nwithdraw your prize won',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.dmSans(
                              fontSize: AppDimension.isSmall ? 12.sp : 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: AppDimension.isSmall ? 46.h : 44.h),
                    child: AppButton(
                      text: 'Withdraw',
                      textStyle: AppTextStyle.poppins(
                        fontSize: AppDimension.isSmall ? 22.sp : 18.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      fillColor: balance > 0
                          ? AppColors.greenDark
                          : AppColors.grayDark,
                      layerColor: balance > 0
                          ? AppColors.greenBright
                          : AppColors.grayLight,
                      height: AppDimension.isSmall ? 70.h : 56.h,
                      width: AppDimension.isSmall ? 200.w : 200.w,
                      layerHeight: AppDimension.isSmall ? 55.h : 46.h,
                      layerTopPosition: -2.h,
                      hasBorder: true,
                      borderColor: Colors.white,
                      onPressed: balance > 0
                          ? () {
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) =>
                                    FundWithdrawalModal(
                                  onClose: () {
                                    Navigator.of(context).pop();
                                  },
                                  amount: balance.toString(),
                                ),
                              );
                            }
                          : null,
                      disabled: balance <= 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
