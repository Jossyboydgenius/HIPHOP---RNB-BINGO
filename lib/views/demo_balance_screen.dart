import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/blocs/balance/balance_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/balance/balance_event.dart';
import 'package:hiphop_rnb_bingo/blocs/balance/balance_state.dart';
import 'package:hiphop_rnb_bingo/widgets/app_button.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'package:hiphop_rnb_bingo/widgets/app_top_bar.dart';

class DemoBalanceScreen extends StatelessWidget {
  const DemoBalanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BalanceBloc, BalanceState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Column(
              children: [
                // Top Bar
                const AppTopBar(
                  initials: 'JD',
                  notificationCount: 2,
                ),

                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Demo: Add Money to Balance',
                          style: AppTextStyle.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Money balance display
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 16.h),
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            'Current Money: \$${state.moneyBalance}',
                            style: AppTextStyle.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        SizedBox(height: 32.h),

                        // Buttons to add/reset money
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppButton(
                              text: 'Add \$10',
                              textStyle: AppTextStyle.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              fillColor: AppColors.greenDark,
                              layerColor: AppColors.greenBright,
                              layerHeight: 40.h,
                              height: 50.h,
                              width: 120.w,
                              borderRadius: 12.r,
                              hasBorder: true,
                              borderColor: Colors.white,
                              borderWidth: 2,
                              onPressed: () {
                                // Add 10 to money balance
                                final currentBalance = state.moneyBalance;
                                context.read<BalanceBloc>().add(
                                    UpdateMoneyBalance(currentBalance + 10));
                              },
                            ),
                            SizedBox(width: 16.w),
                            AppButton(
                              text: 'Add \$100',
                              textStyle: AppTextStyle.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              fillColor: AppColors.purplePrimary,
                              layerColor: AppColors.purpleDark,
                              layerHeight: 40.h,
                              height: 50.h,
                              width: 120.w,
                              borderRadius: 12.r,
                              hasBorder: true,
                              borderColor: Colors.white,
                              borderWidth: 2,
                              onPressed: () {
                                // Add 100 to money balance
                                final currentBalance = state.moneyBalance;
                                context.read<BalanceBloc>().add(
                                    UpdateMoneyBalance(currentBalance + 100));
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        AppButton(
                          text: 'Reset Balance',
                          textStyle: AppTextStyle.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          fillColor: AppColors.accent,
                          layerColor: AppColors.pinkDark,
                          layerHeight: 42.h,
                          hasBorder: true,
                          borderColor: Colors.white,
                          borderWidth: 2,
                          height: 55.h,
                          width: 256.w,
                          borderRadius: 12.r,
                          onPressed: () {
                            // Reset money balance to 0
                            context
                                .read<BalanceBloc>()
                                .add(UpdateMoneyBalance(0));
                          },
                        ),
                        SizedBox(height: 32.h),
                        Text(
                          'Tap the Money icon in the top bar to see the Prize Payout',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.poppins(
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
