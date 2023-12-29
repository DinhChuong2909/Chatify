import 'package:flutter/material.dart';

// Models
import '../models/chat_message.dart';
import '../models/chat_user.dart';

// Widgets
import '../widgets/image_message_bubble.dart';
import '../widgets/text_message_bubble.dart';
import '../widgets/rounded_image.dart';

class CustomChatTile extends StatelessWidget {
  final double height;
  final double width;
  final ChatMessage message;

  final ChatUser sender;
  final bool isMe;

  const CustomChatTile({
    super.key,
    required this.height,
    required this.width,
    required this.message,
    required this.sender,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      width: width,
      child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            !isMe
                ? RoundedImageNetwork(
                    imgPath: sender.imgURL,
                    size: width * 0.06,
                    key: UniqueKey(),
                  )
                : const SizedBox(
                    height: 10,
                    width: 10,
                  ),
            SizedBox(
              width: width * 0.04,
            ),
            message.type == MessageType.TEXT
                ? TextMessageBubble(
                    isMe: isMe, message: message, height: height, width: width)
                : ImageMessageBubble(
                    isMe: isMe, message: message, height: height, width: width),
          ]),
    );
  }
}
