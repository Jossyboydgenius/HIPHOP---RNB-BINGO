import 'package:flutter/material.dart';
import 'package:hiphop_rnb_bingo/widgets/app_icons.dart';
import 'dart:ui';
import 'app_modal_container.dart';
import 'app_colors.dart';
import 'app_text_style.dart';
import 'app_images.dart';
import 'app_input.dart';
import 'app_button.dart';

class WithdrawToModal extends StatefulWidget {
  final VoidCallback onClose;
  final Function(Map<String, String>) onConfirm;

  const WithdrawToModal({
    super.key,
    required this.onClose,
    required this.onConfirm,
  });

  @override
  State<WithdrawToModal> createState() => _WithdrawToModalState();
}

class _WithdrawToModalState extends State<WithdrawToModal> {
  String? selectedOption;
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
    return Text(
      selectedOption == null ? 'Withdraw To' : 'Input Detail',
      style: AppTextStyle.poppins(
        fontSize: 20,
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
          padding: const EdgeInsets.symmetric(vertical: 10),
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
                        image: AssetImage(option['icon']),
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

  Widget _buildInputDetails() {
    final option = paymentOptions[selectedOption!]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Platform',
          style: AppTextStyle.dmSans(
            fontSize: 12,
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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(option['icon']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  selectedOption!,
                  style: AppTextStyle.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Container(
              height: 32,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    selectedOption = null;
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.blueLight2,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Text(
                  'Change',
                  style: AppTextStyle.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          option['firstFieldLabel'],
          style: AppTextStyle.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        AppInput(
          label: '',
          controller: _emailController,
          hintText: option['firstFieldHint'],
          showShadow: true,
        ),
        const SizedBox(height: 16),
        Text(
          'Full Name',
          style: AppTextStyle.dmSans(
            fontSize: 12,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppModalContainer(
                width: 340,
                height: selectedOption == null ? 350 : 470,
                fillColor: AppColors.purplePrimary,
                borderColor: AppColors.purpleLight,
                layerColor: AppColors.purpleDark,
                layerTopPosition: -4,
                borderRadius: 32,
                title: '',
                customTitle: _buildTitle(),
                onClose: widget.onClose,
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: selectedOption == null
                                        ? Column(
                                            children: paymentOptions.keys
                                                .map((title) => _buildPaymentOption(title))
                                                .toList(),
                                          )
                                        : _buildInputDetails(),
                                  ),
                                ),
                              ),
                            ),
                            if (selectedOption != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  'Please verify your account carefully to ensure we can transfer money successfully',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.dmSans(
                                    fontSize: 12,
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
              if (selectedOption != null)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: AppButton(
                    text: 'Confirm',
                    textStyle: AppTextStyle.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    fillColor: AppColors.greenDark,
                    layerColor: AppColors.greenBright,
                    height: 56,
                    width: 200,
                    layerHeight: 46,
                    layerTopPosition: -2,
                    hasBorder: true,
                    borderColor: Colors.white,
                    onPressed: () {
                      widget.onConfirm({
                        'platform': selectedOption!,
                        'email': _emailController.text,
                        'fullName': _fullNameController.text,
                      });
                      widget.onClose();
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