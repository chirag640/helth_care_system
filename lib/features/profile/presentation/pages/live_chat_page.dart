import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';

/// Live Chat Page - Support Chat Interface
class LiveChatPage extends StatefulWidget {
  const LiveChatPage({super.key});

  @override
  State<LiveChatPage> createState() => _LiveChatPageState();
}

class _LiveChatPageState extends State<LiveChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Hello! How can I help you today?',
      isSupport: true,
      time: '12:12 AM',
      isSeen: true,
    ),
    ChatMessage(
      text: 'I need help with my appointment',
      isSupport: false,
      time: '12:13 AM',
      isSeen: true,
    ),
    ChatMessage(
      text:
          'Sure, I can help you with that. Can you provide me with your appointment ID?',
      isSupport: true,
      time: '12:14 AM',
      isSeen: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.white,
              size: AppResponsive.icon(context, 24),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: AppResponsive.s(context, 20),
                backgroundImage:
                    const AssetImage('assets/images/support_avatar.png'),
                onBackgroundImageError: (_, __) {},
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withValues(alpha: 0.2),
                  ),
                  child: Icon(
                    Icons.support_agent,
                    size: AppResponsive.icon(context, 20),
                    color: AppColors.white,
                  ),
                ),
              ),
              SizedBox(width: AppResponsive.p(context, 12)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dave',
                    style: TextStyle(
                      fontSize: AppResponsive.fontSize(context, 16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    'Support Team',
                    style: TextStyle(
                      fontSize: AppResponsive.fontSize(context, 12),
                      color: AppColors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(AppResponsive.p(context, 16)),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),
            _buildInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment:
          message.isSupport ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: AppResponsive.p(context, 12)),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: message.isSupport
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (message.isSupport)
              Padding(
                padding: EdgeInsets.only(bottom: AppResponsive.p(context, 4)),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: AppResponsive.s(context, 12),
                      backgroundColor: AppColors.chatBubbleSupport,
                      child: Icon(
                        Icons.support_agent,
                        size: AppResponsive.icon(context, 12),
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: AppResponsive.p(context, 8)),
                    Text(
                      'Dave',
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 12),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.p(context, 16),
                vertical: AppResponsive.p(context, 12),
              ),
              decoration: BoxDecoration(
                color: message.isSupport
                    ? AppColors.chatBubbleSupport
                    : AppColors.chatBubbleUser,
                borderRadius: BorderRadius.circular(
                  AppResponsive.radius(context, 16),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: AppResponsive.fontSize(context, 14),
                  color: message.isSupport
                      ? AppColors.textPrimary
                      : AppColors.white,
                ),
              ),
            ),
            SizedBox(height: AppResponsive.p(context, 4)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.time,
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 10),
                    color: AppColors.textSecondary,
                  ),
                ),
                if (!message.isSupport) ...[
                  SizedBox(width: AppResponsive.p(context, 4)),
                  Icon(
                    message.isSeen ? Icons.done_all : Icons.done,
                    size: AppResponsive.icon(context, 12),
                    color: message.isSeen
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.all(AppResponsive.p(context, 12)),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.attach_file,
              color: AppColors.textSecondary,
              size: AppResponsive.icon(context, 24),
            ),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.p(context, 16),
              ),
              decoration: BoxDecoration(
                color: AppColors.chatInputBackground,
                borderRadius: BorderRadius.circular(
                  AppResponsive.radius(context, 24),
                ),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: AppResponsive.fontSize(context, 14)),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(width: AppResponsive.p(context, 8)),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.send,
                color: AppColors.white,
                size: AppResponsive.icon(context, 20),
              ),
              onPressed: () {
                if (_messageController.text.isNotEmpty) {
                  setState(() {
                    _messages.add(ChatMessage(
                      text: _messageController.text,
                      isSupport: false,
                      time: '12:15 AM',
                      isSeen: false,
                    ));
                    _messageController.clear();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isSupport;
  final String time;
  final bool isSeen;

  ChatMessage({
    required this.text,
    required this.isSupport,
    required this.time,
    required this.isSeen,
  });
}
