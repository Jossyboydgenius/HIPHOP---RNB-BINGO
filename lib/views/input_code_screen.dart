import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  }

  @override
  void dispose() {
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppModalContainer(
                          width: 340,
                          height: 180,
                          fillColor: AppColors.purplePrimary,
                          borderColor: AppColors.purpleLight,
                          layerColor: AppColors.purpleDark,
                          title: 'Input Code',
                          titleStyle: AppTextStyle.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          handleBackNavigation: true,
                          onClose: () {
                            Navigator.pushReplacementNamed(context, AppRoutes.home);
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.purpleLight,
                                    width: 3,
                                  ),
                                ),
                                child: TextField(
                                  controller: _codeController,
                                  focusNode: _focusNode,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.poppins(
                                    fontSize: 44,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ).copyWith(letterSpacing: 38),
                                  obscureText: true,
                                  obscuringCharacter: '●',
                                  cursorColor: Colors.black,
                                  cursorWidth: 1,
                                  cursorHeight: 30,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(4),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onSubmitted: (_) => _handleCodeSubmission(),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: -1,
                                      vertical: -16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Text(
                          widget.isInPerson 
                              ? 'Enter PIN code for the game'
                              : 'Enter PIN code provided by the host',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        AppButton(
                          text: 'Enter',
                          textStyle: AppTextStyle.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          fillColor: AppColors.greenDark,
                          layerColor: AppColors.greenBright,
                          borderColor: Colors.white,
                          hasBorder: true,
                          height: 56,
                          width: 220,
                          layerHeight: 44,
                          layerTopPosition: -2,
                          borderRadius: 16,
                          onPressed: _handleCodeSubmission,
                        ),
                        const SizedBox(height: 110),
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