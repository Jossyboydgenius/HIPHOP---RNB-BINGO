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
          {'amount': '2', 'price': '10', 'plus': ''},
          {'amount': '4', 'price': '20', 'plus': ''},
          {'amount': '8', 'price': '40', 'plus': ''},
          {'amount': '12', 'price': '50', 'plus': ''},
          {'amount': '16', 'price': '70', 'plus': ''},
          {'amount': '20', 'price': '80', 'plus': ''},
        ];

        void handlePurchase(Map<String, String> option) {
          final currentGems = state.gemBalance;
          final requiredGems = int.parse(option['price']!);
          final boardsToAdd = int.parse(option['amount']!);
          
          if (currentGems >= requiredGems) {
            context.read<BalanceBloc>().add(
              UpdateGemBalance(currentGems - requiredGems)
            );
            context.read<BalanceBloc>().add(
              UpdateBoardBalance(state.boardBalance + boardsToAdd)
            );
            
            Navigator.pop(context);
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => BoardPurchaseSuccessModal(
                onClose: () => Navigator.pop(context),
                amount: option['amount']!,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Insufficient gems balance'),
              ),
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
                          height: 42,
                          width: 42,
                          onPressed: onClose,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Store',
                              style: AppTextStyle.mochiyPopOne(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
                                      '${option['amount']} Boards',
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
                              state.boardBalance.toString(),
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
                              icon: AppIconData.card,
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
                        fillColor: AppColors.pinkDark2,
                        layerColor: AppColors.pinkLight,
                        height: 56,
                        layerHeight: 44,
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