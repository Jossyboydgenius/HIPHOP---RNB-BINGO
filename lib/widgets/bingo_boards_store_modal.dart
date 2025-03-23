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
import 'package:hiphop_rnb_bingo/widgets/board_purchase_success_modal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/balance/balance_bloc.dart';
import 'package:hiphop_rnb_bingo/blocs/balance/balance_event.dart';
import 'package:hiphop_rnb_bingo/blocs/balance/balance_state.dart';
import 'package:hiphop_rnb_bingo/widgets/wallet_funding_modal.dart';
import 'package:hiphop_rnb_bingo/widgets/app_toast.dart';

class BingoBoardsStoreModal extends StatelessWidget {
  final VoidCallback onClose;

  const BingoBoardsStoreModal({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BalanceBloc, BalanceState>(
      builder: (context, state) {
        final purchaseOptions = [
          {'amount': '1', 'price': '15', 'title': 'Solo Board'},
          {'amount': '3', 'price': '40', 'title': 'Triple Board'},
          {'amount': '7', 'price': '100', 'title': 'Pro Board'},
          {'amount': '10', 'price': '140', 'title': 'Ultimate Board'},
        ];

        void handlePurchase(Map<String, String> option) {
          final currentGems = state.gemBalance;
          final requiredGems = int.parse(option['price']!);
          final boardsToAdd = int.parse(option['amount']!);
          final boardTitle = option['title']!;
          
          if (currentGems >= requiredGems) {
            context.read<BalanceBloc>().add(
              UpdateGemBalance(currentGems - requiredGems)
            );
            context.read<BalanceBloc>().add(
              UpdateBoardBalance(state.boardBalance + boardsToAdd)
            );
            
            // Show both success toast and modal
            AppToast.show(
              context,
              'You have successfully purchased $boardTitle using $requiredGems Diamonds!',
              showCloseIcon: false,
              showInfoIcon: true,
              textColor: AppColors.greenDark,
              backgroundColor: AppColors.greenLight,
              borderColor: AppColors.greenDark,
              infoIcon: AppImageData.info3,
            );
            
            Navigator.pop(context);
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => BoardPurchaseSuccessModal(
                amount: option['amount']!,
                onClose: () => Navigator.pop(context),
              ),
            );
          } else {
            // Error toast
            AppToast.show(
              context,
              'You don\'t have enough Diamonds to complete this purchase.',
              showCloseIcon: false,
              showInfoIcon: true,
              textColor: AppColors.pinkDark,
              backgroundColor: AppColors.redLight,
              borderColor: AppColors.pinkDark,
              infoIcon: AppImageData.info,
            );
          }
        }

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
                          height: 38,
                          width: 38,
                          onPressed: onClose,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Store',
                              style: AppTextStyle.mochiyPopOne(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 42),
                      ],
                    ),
                  ),
                  // Banner
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: AppBanner(
                      text: 'Bingo Boards',
                      fillColor: AppColors.blueLight3,
                      borderColor: AppColors.deepBlue,
                      textStyle: AppTextStyle.textWithStroke(
                        fontSize: 16,
                        textColor: Colors.white,
                        strokeColor: AppColors.deepBlue,
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                  // Modal container with purchase cards
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AppModalContainer(
                        width: 380,
                        height: 410,
                        fillColor: Colors.white,
                        borderColor: AppColors.purplePrimary,
                        layerColor: AppColors.purpleDark,
                        layerTopPosition: -4,
                        borderRadius: 24,
                        showCloseButton: false,
                        onClose: () {},
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 24,
                          crossAxisSpacing: 24,
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          childAspectRatio: 0.9,
                          children: purchaseOptions.map((option) {
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                AppInAppPurchaseCard(
                                  amount: option['amount']!,
                                  price: option['price']!,
                                  plusValue: '',
                                  iconPath: AppImageData.card,
                                  bannerColor: AppColors.pinkLight2,
                                  isGemCard: false,
                                  onGetPressed: () => handlePurchase(option),
                                ),
                                Positioned(
                                  top: -4,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    decoration: const BoxDecoration(
                                      color: AppColors.pinkLight2,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      option['title']!,
                                      textAlign: TextAlign.center,
                                      style: AppTextStyle.mochiyPopOne(
                                        fontSize: 12,
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
                  // Boards amount
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
                              state.gemBalance.toString(),
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
                  // Diamond button
                  Padding(
                    padding: const EdgeInsets.only(top: 36),
                    child: SizedBox(
                      width: 200,
                      child: AppButton(
                        text: 'Diamond',
                        textStyle: AppTextStyle.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                        fillColor: AppColors.pinkDark2,
                        layerColor: AppColors.pinkLight,
                        height: 60,
                        layerHeight: 50,
                        layerTopPosition: -2,
                        hasBorder: true,
                        borderColor: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => WalletFundingModal(
                              onClose: () => Navigator.pop(context),
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
      },
    );
  }
} 