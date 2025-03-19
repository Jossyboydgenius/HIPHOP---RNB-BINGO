import 'package:flutter/material.dart';
import 'dart:ui';
import 'app_modal_container.dart';
import 'app_colors.dart';
import 'notification_card.dart';

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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: AppModalContainer(
                  width: 500,
                  height: 750,
                  fillColor: AppColors.purplePrimary,
                  borderColor: AppColors.purpleLight,
                  layerColor: AppColors.purpleDark,
                  layerTopPosition: -4,
                  borderRadius: 32,
                  onClose: onClose,
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
          ],
        ),
      ),
    );
  }
} 