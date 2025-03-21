import 'package:flutter/material.dart';
import 'package:hiphop_rnb_bingo/widgets/app_icons.dart';
import 'dart:ui';
import 'app_modal_container.dart';
import 'app_colors.dart';
import 'app_text_style.dart';
import 'app_images.dart';

class PaymentOptionsModal extends StatelessWidget {
  final VoidCallback onClose;
  final Function(String) onPaymentSelected;
  final bool isInAppPurchase;

  const PaymentOptionsModal({
    super.key,
    required this.onClose,
    required this.onPaymentSelected,
    this.isInAppPurchase = false,
  });

  Widget _buildTitle() {
    return Text(
      isInAppPurchase ? 'Fund from' : 'Pay Fees',
      style: AppTextStyle.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildPaymentOption(String icon, String title) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onPaymentSelected(title);
          onClose();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(icon),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: AppTextStyle.dmSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const AppIcons(
                icon: AppIconData.arrowRight,
                color: Colors.black,
                size: 24,
              ),
            ],
          ),
        ),
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: AppModalContainer(
              width: 340,
              height: 350,
              fillColor: AppColors.purplePrimary,
              borderColor: AppColors.purpleLight,
              layerColor: AppColors.purpleDark,
              layerTopPosition: -4,
              borderRadius: 32,
              title: '',
              customTitle: _buildTitle(),
              onClose: onClose,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: 320,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPaymentOption(AppImageData.paypal, 'PayPal'),
                        _buildPaymentOption(AppImageData.cashapp, 'CashApp'),
                        _buildPaymentOption(AppImageData.zelle, 'Zelle'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 