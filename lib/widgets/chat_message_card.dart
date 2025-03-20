import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_style.dart';
import 'app_images.dart';

class ChatMessageCard extends StatelessWidget {
  final String message;
  final String senderName;
  final String senderInitials;
  final String time;
  final bool isMe;
  final VoidCallback? onProfileTap;

  const ChatMessageCard({
    super.key,
    required this.message,
    required this.senderName,
    required this.senderInitials,
    required this.time,
    this.isMe = false,
    this.onProfileTap,
  });

  Widget _buildAvatar(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        if (onProfileTap != null && !isMe) {
          _showProfileMenu(context, details.globalPosition);
        }
      },
      child: Stack(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.purplePrimary,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                senderInitials,
                style: AppTextStyle.dmSans(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (isMe)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.greenBright,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showProfileMenu(BuildContext context, Offset position) {
    final items = [
      PopupMenuItem(
        child: Row(
          children: [
            const AppImages(imagePath: AppImageData.ban),
            const SizedBox(width: 8),
            Text(
              'Report',
              style: AppTextStyle.dmSans(fontSize: 14),
            ),
          ],
        ),
        onTap: () {
          // Handle report
        },
      ),
      PopupMenuItem(
        child: Row(
          children: [
            const AppImages(imagePath: AppImageData.mute),
            const SizedBox(width: 8),
            Text(
              'Mute',
              style: AppTextStyle.dmSans(fontSize: 14),
            ),
          ],
        ),
        onTap: () {
          // Handle mute
        },
      ),
    ];

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      items: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            _buildAvatar(context),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isMe ? 'Me' : senderName,
                      style: AppTextStyle.dmSans(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      time,
                      style: AppTextStyle.dmSans(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.purplePrimary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message,
                    style: AppTextStyle.dmSans(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            _buildAvatar(context),
          ],
        ],
      ),
    );
  }
} 