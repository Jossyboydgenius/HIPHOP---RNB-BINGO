import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../routes/app_routes.dart';
import '../widgets/app_background.dart';
import '../widgets/app_button.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_modal_container.dart';
import '../widgets/app_text_style.dart';
import '../widgets/app_top_bar.dart';

class InputCodeScreen extends StatefulWidget {
  final bool isInPerson;

  const InputCodeScreen({
    super.key,
    required this.isInPerson,
  });

  @override
  State<InputCodeScreen> createState() => _InputCodeScreenState();
}

class _InputCodeScreenState extends State<InputCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Focus the text field when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    
    // Add listener to update button state
    _codeController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _codeController.removeListener(() {});
    _codeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleCodeSubmission() {
    if (_codeController.text.length == 4) {
      final code = _codeController.text;
      if (widget.isInPerson) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.gameDetails,
          arguments: code,
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.remoteGameDetails,
          arguments: code,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        return false;
      },
      child: Scaffold(
        body: AppBackground(
          child: SafeArea(
            child: Column(
              children: [
                const AppTopBar(
                  initials: 'JD',
                  notificationCount: 1,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppModalContainer(
                          width: double.infinity,
                          height: 180.h,
                          fillColor: AppColors.purplePrimary,
                          borderColor: AppColors.purpleLight,
                          layerColor: AppColors.purpleDark,
                          title: 'Input Code',
                          titleStyle: AppTextStyle.poppins(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          handleBackNavigation: true,
                          onClose: () {
                            Navigator.pushReplacementNamed(context, AppRoutes.home);
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 26.h),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Container(
                                height: 56.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: AppColors.purpleLight,
                                    width: 3.w,
                                  ),
                                ),
                                child: TextField(
                                  controller: _codeController,
                                  focusNode: _focusNode,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.poppins(
                                    fontSize: 40.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ).copyWith(letterSpacing: 36.w),
                                  obscureText: true,
                                  obscuringCharacter: '●',
                                  cursorColor: Colors.black,
                                  cursorWidth: 2.w,
                                  cursorHeight: 32.h,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(4),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onSubmitted: (_) => _handleCodeSubmission(),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: -1.w,
                                      vertical: -10.h,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50.h),
                        Text(
                          widget.isInPerson 
                              ? 'Enter PIN code for the game'
                              : 'Enter PIN code provided by the host',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        AppButton(
                          text: 'Enter',
                          textStyle: AppTextStyle.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          fillColor: _codeController.text.length < 4
                            ? AppColors.grayDark 
                            : AppColors.greenDark,
                          layerColor: _codeController.text.length < 4
                            ? AppColors.grayLight 
                            : AppColors.greenBright,
                          borderColor: Colors.white,
                          hasBorder: true,
                          height: 50.h,
                          width: 180.w,
                          layerHeight: 42.h,
                          layerTopPosition: -2.h,
                          borderRadius: 16.r,
                          nullTextColor: Colors.black,
                          onPressed: _codeController.text.length == 4 ? _handleCodeSubmission : null,
                        ),
                        SizedBox(height: 110.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 