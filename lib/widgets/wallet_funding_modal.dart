import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hiphop_rnb_bingo/widgets/app_banner.dart';
import 'package:hiphop_rnb_bingo/widgets/app_button.dart';
import 'package:hiphop_rnb_bingo/widgets/app_colors.dart';
import 'package:hiphop_rnb_bingo/widgets/app_icons.dart';
import 'package:hiphop_rnb_bingo/widgets/app_images.dart';
import 'package:hiphop_rnb_bingo/widgets/app_in_app_purchase_card.dart';
import 'package:hiphop_rnb_bingo/widgets/app_modal_container.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'package:hiphop_rnb_bingo/widgets/payment_options_modal.dart';
import 'package:hiphop_rnb_bingo/widgets/bingo_boards_store_modal.dart';

class WalletFundingModal extends StatelessWidget {
  final VoidCallback onClose;
  final String gemAmount;

  const WalletFundingModal({
    super.key,
    required this.onClose,
    required this.gemAmount,
  });

  @override
  Widget build(BuildContext context) {
    final purchaseOptions = [
      {'amount': '20', 'price': '10', 'plus': ''},
      {'amount': '40', 'price': '20', 'plus': '1'},
      {'amount': '50', 'price': '30', 'plus': '2'},
      {'amount': '80', 'price': '45', 'plus': '4'},
      {'amount': '100', 'price': '60', 'plus': '6'},
      {'amount': '150', 'price': '120', 'plus': '8'},
    ];

    return Container(
      color: Colors.black54,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header section with back button
              Padding(
                padding: const EdgeInsets.only(bottom: 32, top: 0),
                child: Row(
                  children: [
                    AppImages(
                      imagePath: AppImageData.back,
                      height: 42,
                      width: 42,
                      onPressed: onClose,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Wallet',
                          style: AppTextStyle.mochiyPopOne(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 42), // Balance the back button
                  ],
                ),
              ),
              // Banner
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: AppBanner(
                  text: 'Gems',
                  fillColor: AppColors.purplePrimary,
                  borderColor: AppColors.purpleDark,
                  textStyle: AppTextStyle.textWithStroke(
                    fontSize: 16,
                    textColor: Colors.white,
                    strokeColor: AppColors.purpleDark,
                    strokeWidth: 3,
                  ),
                ),
              ),
              // const SizedBox(height: 6),
              // Modal container with purchase cards
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AppModalContainer(
                    width: 380,
                    height: 370,
                    fillColor: Colors.white,
                    borderColor: AppColors.purplePrimary,
                    layerColor: AppColors.purpleDark,
                    layerTopPosition: -4,
                    borderRadius: 24,
                    showCloseButton: false,
                    onClose: () {},
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                      childAspectRatio: 0.65,
                      children: purchaseOptions.map((option) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AppInAppPurchaseCard(
                              amount: option['amount']!,
                              price: option['price']!,
                              plusValue: option['plus']!,
                              iconPath: AppImageData.gem,
                              onGetPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => PaymentOptionsModal(
                                    isInAppPurchase: true,
                                    onClose: () => Navigator.pop(context),
                                    onPaymentSelected: (platform) {
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              top: -4,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                decoration: const BoxDecoration(
                                  color: AppColors.pinkPrimary,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(0),
                                  ),
                                ),
                                child: Text(
                                  '${option['amount']} Gems',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.mochiyPopOne(
                                    fontSize: 8,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              // Gem amount
              Padding(
                padding: const EdgeInsets.only(top: 36),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.purplePrimary,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          gemAmount,
                          style: AppTextStyle.poppins(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      left: -12,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: AppIcons(
                          icon: AppIconData.gem,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Store button
              Padding(
                padding: const EdgeInsets.only(top: 36),
                child: SizedBox(
                  width: 200,
                  child: AppButton(
                    text: 'Store',
                    fillColor: AppColors.pinkDark,
                    layerColor: AppColors.pinkPrimary,
                    height: 56,
                    layerHeight: 44,
                    layerTopPosition: -2,
                    hasBorder: true,
                    borderColor: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) => BingoBoardsStoreModal(
                          onClose: () => Navigator.pop(context),
                          boardsAmount: '0',
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
} 