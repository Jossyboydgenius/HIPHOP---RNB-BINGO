import 'package:flutter/material.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_images.dart';
import '../widgets/app_text_style.dart';

class GameDetailsContainer extends StatelessWidget {
  final String host;
  final String dj;
  final String rounds;
  final String musicTheme;
  final String gameType;
  final String gameFee;
  final List<String> gameStyles;
  final String timeRemaining;
  final String? cardAmount;
  final bool showMoneyIcon;
  final bool showCardIcon;

  const GameDetailsContainer({
    super.key,
    required this.host,
    required this.dj,
    required this.rounds,
    required this.musicTheme,
    required this.gameType,
    required this.gameFee,
    required this.gameStyles,
    required this.timeRemaining,
    this.cardAmount,
    this.showMoneyIcon = true,
    this.showCardIcon = false,
  });

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label:',
            style: AppTextStyle.mochiyPopOne(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: AppTextStyle.mochiyPopOne(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameFeeRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            'Game Fee:',
            style: AppTextStyle.mochiyPopOne(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 8),
          if (showMoneyIcon) ...[
            const AppImages(
              imagePath: AppImageData.money,
              height: 20,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            '\$$gameFee',
            style: AppTextStyle.mochiyPopOne(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          if (showCardIcon && cardAmount != null) ...[
            const SizedBox(width: 8),
            const AppImages(
              imagePath: AppImageData.card,
              height: 20,
            ),
            const SizedBox(width: 4),
            Text(
              cardAmount!,
              style: AppTextStyle.mochiyPopOne(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.backgroundLight,
              width: 3,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Game Details',
                        style: AppTextStyle.mochiyPopOne(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.pinkDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const AppImages(
                        imagePath: AppImageData.info,
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.yellowPrimary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          timeRemaining,
                          style: AppTextStyle.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Positioned(
                        left: -10,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: AppImages(
                            imagePath: AppImageData.clock,
                            height: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Host', host),
              _buildDetailRow('DJ', dj),
              _buildDetailRow('Rounds', rounds),
              _buildDetailRow('Music Theme', musicTheme),
              _buildDetailRow('Game Type', gameType),
              _buildGameFeeRow(),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Game Style:',
                    style: AppTextStyle.mochiyPopOne(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: gameStyles.map((style) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.greenBright,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              style,
                              style: AppTextStyle.mochiyPopOne(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
} 