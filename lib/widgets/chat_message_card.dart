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
              color: AppColors.primary,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                senderInitials,
                style: AppTextStyle.poppins(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.teal,
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
        height: 40,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppImages(
              imagePath: AppImageData.ban,
              width: 16,
              height: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'Report',
              style: AppTextStyle.dmSans(
                fontSize: 11,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        onTap: () {
          // Handle report
        },
      ),
      PopupMenuItem(
        height: 40,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppImages(
              imagePath: AppImageData.mute,
              width: 16,
              height: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'Mute',
              style: AppTextStyle.dmSans(
                fontSize: 11,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.grayDark),
      ),
      color: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
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
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      time,
                      style: AppTextStyle.dmSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
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
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 16),
                    ),
                  ),
                  child: Text(
                    message,
                    style: AppTextStyle.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
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