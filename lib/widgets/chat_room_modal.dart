import 'package:flutter/material.dart';
import 'dart:ui';
import 'app_modal_container.dart';
import 'app_colors.dart';
import 'app_icons.dart';
import 'app_text_style.dart';
import 'app_banner.dart';
import 'chat_message_card.dart';
import 'app_button.dart';

class ChatRoomModal extends StatefulWidget {
  final VoidCallback onClose;
  final String userInitials;
  final int activeUsers;
  final bool isConnected;

  const ChatRoomModal({
    super.key,
    required this.onClose,
    required this.userInitials,
    required this.activeUsers,
    this.isConnected = true,
  });

  @override
  State<ChatRoomModal> createState() => _ChatRoomModalState();
}

class _ChatRoomModalState extends State<ChatRoomModal> {
  final TextEditingController _messageController = TextEditingController();
  final int maxLength = 250;
  
  // Add this list to store chat messages
  final List<Map<String, dynamic>> messages = [
    {
      'message': 'Lorem ipsum dolor sit amet, Lorem ipsum dolor sit',
      'senderName': 'John Doe',
      'senderInitials': 'JD',
      'time': '08:00',
      'isMe': false,
    },
    {
      'message': 'Lorem ipsum dolor sit amet, Lorem ipsum dolor sit amet, Lorem ipsum dolor sit',
      'senderName': 'John Doe',
      'senderInitials': 'JD',
      'time': '00:05',
      'isMe': false,
    },
    {
      'message': 'Lorem ipsum dolor sit amet, Lorem ipsum dolor sit, Lorem ipsum dolor sit amet, Lorem ipsum dolor sit',
      'senderName': 'Me',
      'senderInitials': 'JD', // Use widget.userInitials here
      'time': 'Just Now',
      'isMe': true,
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isConnected ? AppColors.greenBright : Colors.red,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.isConnected ? 'Connected' : 'Disabled',
              style: AppTextStyle.dmSans(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const AppIcons(
              icon: AppIconData.people,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              widget.activeUsers.toString(),
              style: AppTextStyle.dmSans(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              maxLength: maxLength,
              style: AppTextStyle.dmSans(
                fontSize: 14,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Type Here',
                hintStyle: AppTextStyle.dmSans(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                ),
                border: InputBorder.none,
                counterText: '',
                suffixText: '${_messageController.text.length}/$maxLength',
                suffixStyle: AppTextStyle.dmSans(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 44,
            height: 44,
            child: AppButton(
              text: '', // Add empty text since it's required
              onPressed: _messageController.text.isEmpty ? null : _handleSendMessage,
              fillColor: _messageController.text.isEmpty 
                ? AppColors.grayLight 
                : AppColors.greenBright,
              layerColor: _messageController.text.isEmpty 
                ? AppColors.grayDark 
                : AppColors.greenDark,
              borderColor: Colors.white,
              height: 44,
              borderRadius: 8,
              iconPath: AppIconData.send, // Use iconPath instead of child
              iconColor: Colors.white,
              iconSize: 24,
              disabled: _messageController.text.isEmpty,
            ),
          ),
        ],
      ),
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
          child: Center(
            child: AppModalContainer(
              width: 500,
              height: 650,
              fillColor: AppColors.purplePrimary,
              borderColor: AppColors.purpleLight,
              layerColor: AppColors.purpleDark,
              layerTopPosition: -4,
              borderRadius: 32,
              maintainFocus: true,
              onClose: widget.onClose,
              banner: AppBanner(
                text: 'Chat Room',
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildHeader(),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Text(
                              'Click profile to report or mute a Player',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Add chat messages here
                            ...messages.map((message) {
                              return ChatMessageCard(
                                message: message['message'],
                                senderName: message['senderName'],
                                senderInitials: message['senderInitials'],
                                time: message['time'],
                                isMe: message['isMe'],
                                onProfileTap: message['isMe'] ? null : () {
                                  // Handle profile tap for reporting/muting
                                },
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildChatInput(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Add this method to handle sending new messages
  void _handleSendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        messages.add({
          'message': _messageController.text,
          'senderName': 'Me',
          'senderInitials': widget.userInitials,
          'time': 'Just Now',
          'isMe': true,
        });
      });
      _messageController.clear();
    }
  }
} 