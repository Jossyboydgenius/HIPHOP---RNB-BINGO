import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_style.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final bool isRead;

  const NotificationCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onButtonPressed,
    this.isRead = false,
  });

  Widget _buildGameNotification() {
    final lines = subtitle.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lines[0], // Game: Hip-Hop Fire Round
          style: AppTextStyle.dmSans(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        const SizedBox(height: 2),
        Text(
          lines[1], // Game Code: 9823
          style: AppTextStyle.dmSans(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        // const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lines[2], // Starts in 10 minutes!
              style: AppTextStyle.dmSans(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black),
            ),
            if (buttonText != null)
              SizedBox(
                height: 24,
                child: MaterialButton(
                  onPressed: isRead ? null : () {
                    onButtonPressed?.call();
                  },
                  color: isRead ? AppColors.grayDark : AppColors.purpleLight,
                  disabledColor: AppColors.grayDark,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    buttonText!,
                    style: AppTextStyle.dmSans(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegularNotification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: AppTextStyle.dmSans(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        if (buttonText != null) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 24,
              child: MaterialButton(
                onPressed: isRead ? null : () {
                  onButtonPressed?.call();
                },
                color: isRead ? AppColors.grayTransparent : AppColors.purpleLight,
                disabledColor: AppColors.grayTransparent,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  buttonText!,
                  style: AppTextStyle.dmSans(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isGameNotification = subtitle.contains('Game:') && subtitle.contains('Game Code:');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRead ? AppColors.grayLight : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRead ? Colors.transparent : AppColors.purpleLight,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyle.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          isGameNotification ? _buildGameNotification() : _buildRegularNotification(),
        ],
      ),
    );
  }
} 