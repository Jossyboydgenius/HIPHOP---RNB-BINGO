import 'package:flutter/material.dart';
import 'package:hiphop_rnb_bingo/widgets/app_text_style.dart';
import 'dart:ui';
import 'app_modal_container.dart';
import 'app_colors.dart';
import 'notification_card.dart';
import 'app_banner.dart';

class NotificationModal extends StatelessWidget {
  final VoidCallback onClose;
  final List<Map<String, dynamic>> notifications;

  const NotificationModal({
    super.key,
    required this.onClose,
    required this.notifications,
  });

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
              width: 500,
              height: 650,
              fillColor: AppColors.purplePrimary,
              borderColor: AppColors.purpleLight,
              layerColor: AppColors.purpleDark,
              layerTopPosition: -4,
              borderRadius: 32,
              onClose: onClose,
              banner: AppBanner(
                text: 'Notification',
                fillColor: AppColors.yellowLight,
                borderColor: AppColors.yellowDark,
                textStyle: AppTextStyle.mochiyPopOne(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                width: 200,
                height: 40,
                hasShadow: true,
                shadowColor: Colors.black,
                shadowBlurRadius: 15,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: 380,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      children: notifications.map((notification) {
                        return NotificationCard(
                          title: notification['title'],
                          subtitle: notification['subtitle'],
                          buttonText: notification['buttonText'],
                          onButtonPressed: notification['onButtonPressed'],
                          isRead: notification['isRead'] ?? false,
                        );
                      }).toList(),
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