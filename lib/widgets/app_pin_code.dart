import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'app_colors.dart';
import 'app_text_style.dart';
import 'app_sizer.dart';

class AppPinCode extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onCompleted;
  final Function(String) onChanged;
  final bool obscureText;
  final int length;

  const AppPinCode({
    super.key,
    required this.controller,
    required this.onCompleted,
    required this.onChanged,
    this.obscureText = true,
    this.length = 4,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: length,
      obscureText: obscureText,
      obscuringCharacter: '•',
      blinkWhenObscuring: true,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12.r),
        fieldHeight: AppDimension.isSmall ? 48.h : 42.h,
        fieldWidth: AppDimension.isSmall ? 42.w : 36.w,
        activeFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        selectedFillColor: Colors.white,
        activeColor: AppColors.purpleLight,
        inactiveColor: AppColors.purpleLight.withOpacity(0.3),
        selectedColor: AppColors.purplePrimary,
        borderWidth: AppDimension.isSmall ? 2.w : 1.5.w,
        errorBorderColor: AppColors.redLight,
      ),
      cursorColor: AppColors.purplePrimary,
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      backgroundColor: Colors.transparent,
      controller: controller,
      onCompleted: onCompleted,
      beforeTextPaste: (text) {
        if (text == null) return false;
        return text.length == length && int.tryParse(text) != null;
      },
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      textStyle: AppTextStyle.poppins(
        fontSize: AppDimension.isSmall ? 20.sp : 18.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }
} 