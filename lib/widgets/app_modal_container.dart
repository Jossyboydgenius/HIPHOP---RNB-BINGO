import 'package:flutter/material.dart';
import 'app_button.dart';
import 'app_icons.dart';
import 'app_text_style.dart';
import 'app_colors.dart';

enum ModalType {
  signIn,
  signUp,
}

class _ContainerColors {
  final Color fillColor;
  final Color borderColor;
  final Color layerColor;

  const _ContainerColors({
    required this.fillColor,
    required this.borderColor,
    required this.layerColor,
  });

  static _ContainerColors signIn() => const _ContainerColors(
        fillColor: AppColors.yellowPrimary,
        borderColor: AppColors.yellowLight,
        layerColor: AppColors.yellowDark,
      );

  static _ContainerColors signUp() => const _ContainerColors(
        fillColor: AppColors.purplePrimary,
        borderColor: AppColors.purpleLight,
        layerColor: AppColors.purpleDark,
      );
}

class _SocialButton extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback? onPressed;

  const _SocialButton({
    required this.icon,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              AppButton(
                text: '',
                fillColor: Colors.white,
                layerColor: AppColors.purpleOverlay,
                height: 56,
                borderRadius: 16,
                hasBorder: true,
                borderColor: Colors.white,
                textColor: Colors.black,
                fontFamily: AppTextStyle.poppinsFont,
                onPressed: onPressed,
              ),
              Positioned.fill(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppIcons(
                        icon: icon,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        text,
                        style: AppTextStyle.poppins(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AppModalContainer extends StatefulWidget {
  final ModalType type;
  final VoidCallback onClose;
  final VoidCallback? onGooglePressed;
  final VoidCallback? onFacebookPressed;
  final VoidCallback? onApplePressed;

  const AppModalContainer({
    super.key,
    required this.type,
    required this.onClose,
    this.onGooglePressed,
    this.onFacebookPressed,
    this.onApplePressed,
  });

  @override
  State<AppModalContainer> createState() => _AppModalContainerState();
}

class _AppModalContainerState extends State<AppModalContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClose() async {
    await _controller.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final containerColors = widget.type == ModalType.signIn
        ? _ContainerColors.signIn()
        : _ContainerColors.signUp();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Stack(
              children: [
                // Background layer
                Positioned(
                  left: 4,
                  right: 4,
                  top: 4,
                  child: Container(
                    height: 480,
                    decoration: BoxDecoration(
                      color: containerColors.layerColor,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                // Main container
                Container(
                  width: double.infinity,
                  height: 480,
                  decoration: BoxDecoration(
                    color: containerColors.fillColor,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: containerColors.borderColor,
                      width: 5,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Close button and title
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 40),
                            Text(
                              widget.type == ModalType.signIn ? 'Sign In' : 'Sign Up',
                              style: AppTextStyle.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            AppIcons(
                              icon: AppIconData.close,
                              size: 40,
                              onPressed: _handleClose,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Social buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            _SocialButton(
                              icon: AppIconData.google,
                              text: '${widget.type == ModalType.signIn ? "Sign in" : "Sign up"} with Google',
                              onPressed: widget.onGooglePressed,
                            ),
                            const SizedBox(height: 16),
                            _SocialButton(
                              icon: AppIconData.facebook,
                              text: '${widget.type == ModalType.signIn ? "Sign in" : "Sign up"} with Facebook',
                              onPressed: widget.onFacebookPressed,
                            ),
                            const SizedBox(height: 16),
                            _SocialButton(
                              icon: AppIconData.apple,
                              text: '${widget.type == ModalType.signIn ? "Sign in" : "Sign up"} with Apple',
                              onPressed: widget.onApplePressed,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Terms text
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 32,
                          left: 24,
                          right: 24,
                        ),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: AppTextStyle.dmSans(
                              fontSize: 14,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                            children: [
                              const TextSpan(
                                text: 'By continuing, you agree to our ',
                              ),
                              TextSpan(
                                text: 'Terms of Services',
                                style: AppTextStyle.dmSans(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(text: ' & '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: AppTextStyle.dmSans(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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