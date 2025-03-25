import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hiphop_rnb_bingo/widgets/app_sizer.dart';
import '../routes/app_routes.dart';
import '../widgets/app_background.dart';
import '../widgets/app_button.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_modal_container.dart';
import '../widgets/app_text_style.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/app_pin_code.dart';

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
                          width: AppDimension.isSmall ? 320.w : 260.w,
                          height: AppDimension.isSmall ? 280.h : 160.h,
                          fillColor: AppColors.purplePrimary,
                          borderColor: AppColors.purpleLight,
                          layerColor: AppColors.purpleDark,
                          title: 'Input Code',
                          titleStyle: AppTextStyle.poppins(
                            fontSize: AppDimension.isSmall ? 24.sp : 20.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          handleBackNavigation: true,
                          onClose: () {
                            Navigator.pushReplacementNamed(context, AppRoutes.home);
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
                            child: Container(
                              width: AppDimension.isSmall ? 380.w : 320.w,
                              // height: AppDimension.isSmall ? 160.h : 120.h,
                              padding: EdgeInsets.symmetric(
                                // horizontal: AppDimension.isSmall ? 16.w : 20.w,
                                vertical: AppDimension.isSmall ? 16.h : 12.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Center(
                                child: AppPinCode(
                                  controller: _codeController,
                                  onCompleted: (_) => _handleCodeSubmission(),
                                  onChanged: (value) => setState(() {}),
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
                            fontSize: AppDimension.isSmall ? 12.sp : 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        AppButton(
                          text: 'Enter',
                          textStyle: AppTextStyle.poppins(
                            fontSize: AppDimension.isSmall ? 18.sp : 18.sp,
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
                          height: AppDimension.isSmall ? 65.h : 50.h,
                          width: AppDimension.isSmall ? 140.w : 140.w,
                          layerHeight: AppDimension.isSmall ? 52.h : 42.h,
                          layerTopPosition: -3.h,
                          borderRadius: AppDimension.isSmall ? 26.r : 16.r,
                          borderWidth: AppDimension.isSmall ? 3.w : 3.w,
                          nullTextColor: Colors.black,
                          onPressed: _codeController.text.length == 4 ? _handleCodeSubmission : null,
                        ),
                        SizedBox(height: AppDimension.isSmall ? 140.h : 110.h),
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