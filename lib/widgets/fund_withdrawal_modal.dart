import 'package:flutter/material.dart';
import 'package:hiphop_rnb_bingo/widgets/app_icons.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'app_modal_container.dart';
import 'app_colors.dart';
import 'app_text_style.dart';
import 'app_images.dart';
import 'app_button.dart';
import 'app_input.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FundWithdrawalModal extends StatefulWidget {
  final VoidCallback onClose;
  final String amount;

  const FundWithdrawalModal({
    super.key,
    required this.onClose,
    required this.amount,
  });

  @override
  State<FundWithdrawalModal> createState() => _FundWithdrawalModalState();
}

class _FundWithdrawalModalState extends State<FundWithdrawalModal> {
  String? selectedOption;
  bool showSummary = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  final Map<String, Map<String, dynamic>> paymentOptions = {
    'PayPal': {
      'icon': AppImageData.paypal,
      'firstFieldLabel': 'Email',
      'firstFieldHint': 'Enter your Paypal account',
    },
    'CashApp': {
      'icon': AppImageData.cashapp,
      'firstFieldLabel': 'CashApp ID',
      'firstFieldHint': 'Enter your CashApp ID',
    },
    'Zelle': {
      'icon': AppImageData.zelle,
      'firstFieldLabel': 'Zelle ID',
      'firstFieldHint': 'Enter your Zelle account',
    },
  };

  Widget _buildTitle() {
    if (showSummary) {
      return Text(
        'Withdrawal',
        style: AppTextStyle.poppins(
          fontSize: 20.sp,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      );
    }
    return Text(
      selectedOption == null ? 'Withdraw To' : 'Input Detail',
      style: AppTextStyle.poppins(
        fontSize: 20.sp,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
    );
  }

  Widget _buildPaymentOption(String title) {
    final option = paymentOptions[title]!;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            selectedOption = title;
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 52.w,
                    height: 52.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      image: DecorationImage(
                        image: AssetImage(option['icon']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    title,
                    style: AppTextStyle.dmSans(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              AppIcons(
                icon: AppIconData.arrowRight,
                color: Colors.black,
                size: 24.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputDetails() {
    final option = paymentOptions[selectedOption!]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Platform',
          style: AppTextStyle.dmSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    image: DecorationImage(
                      image: AssetImage(option['icon']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Text(
                  selectedOption!,
                  style: AppTextStyle.dmSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 32,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    selectedOption = null;
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.blueLight2,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Text(
                  'Change',
                  style: AppTextStyle.dmSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Text(
          option['firstFieldLabel'],
          style: AppTextStyle.dmSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8.h),
        AppInput(
          label: '',
          controller: _emailController,
          hintText: option['firstFieldHint'],
          showShadow: true,
        ),
        SizedBox(height: 16.h),
        Text(
          'Full Name',
          style: AppTextStyle.dmSans(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        AppInput(
          label: '',
          controller: _fullNameController,
          hintText: 'Input account name',
          showShadow: true,
        ),
      ],
    );
  }

  Widget _buildSummary() {
    final currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    return Column(
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
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
                  '\$${widget.amount}',
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
        SizedBox(height: 24.h),
        _buildDetailRow(
          'Withdrawal',
          selectedOption!,
          icon: paymentOptions[selectedOption!]!['icon'],
        ),
        _buildDetailRow(
          'Account',
          _emailController.text,
        ),
        _buildDetailRow(
          'Account Name',
          _fullNameController.text,
        ),
        _buildDetailRow(
          'Date',
          currentDate,
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {String? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyle.dmSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(icon),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
              ],
              Text(
                value,
                style: AppTextStyle.dmSans(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                height: selectedOption == null
                    ? (AppDimension.isSmall ? 550.h : 300.h)
                    : (AppDimension.isSmall ? 750.h : 400.h),
                fillColor: AppColors.purplePrimary,
                borderColor: AppColors.purpleLight,
                layerColor: AppColors.purpleDark,
                layerTopPosition: -4.h,
                borderRadius: AppDimension.isSmall ? 32.r : 24.r,
                title: '',
                customTitle: _buildTitle(),
                onClose: widget.onClose,
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.all(AppDimension.isSmall ? 24.r : 16.r),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      AppDimension.isSmall ? 20.r : 16.r),
                                ),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        AppDimension.isSmall ? 24.r : 16.r),
                                    child: showSummary
                                        ? _buildSummary()
                                        : selectedOption == null
                                            ? Column(
                                                children: paymentOptions.keys
                                                    .map((title) =>
                                                        _buildPaymentOption(
                                                            title))
                                                    .toList(),
                                              )
                                            : _buildInputDetails(),
                                  ),
                                ),
                              ),
                            ),
                            if (selectedOption != null || showSummary)
                              Padding(
                                padding: EdgeInsets.only(
                                    top: AppDimension.isSmall ? 24.h : 16.h),
                                child: Text(
                                  'Please verify your account carefully to ensure we can transfer money successfully',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.dmSans(
                                    fontSize:
                                        AppDimension.isSmall ? 12.sp : 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (selectedOption != null || showSummary)
                Padding(
                  padding:
                      EdgeInsets.only(top: AppDimension.isSmall ? 46.h : 44.h),
                  child: AppButton(
                    text: 'Confirm',
                    textStyle: AppTextStyle.poppins(
                      fontSize: AppDimension.isSmall ? 22.sp : 18.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    fillColor: AppColors.greenDark,
                    layerColor: AppColors.greenBright,
                    height: AppDimension.isSmall ? 70.h : 56.h,
                    width: AppDimension.isSmall ? 200.w : 200.w,
                    layerHeight: AppDimension.isSmall ? 55.h : 46.h,
                    layerTopPosition: -2.h,
                    hasBorder: true,
                    borderColor: Colors.white,
                    onPressed: () {
                      if (!showSummary) {
                        setState(() {
                          showSummary = true;
                        });
                      } else {
                        widget.onClose();
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }
}
