import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

// Models
import '../models/chat_message.dart';

class TextMessageBubble extends StatelessWidget {
  final bool isMe;
  final ChatMessage message;
  final double height;
  final double width;

  const TextMessageBubble(
      {super.key,
        required this.isMe,
        required this.message,
        required this.height,
        required this.width});

  @override
  Widget build(BuildContext context) {
    List<Color> colors = isMe
        ? [
      const Color.fromRGBO(0, 136, 249, 1),
      const Color.fromRGBO(0, 82, 218, 1)
    ]
        : [
      const Color.fromRGBO(51, 49, 68, 1),
      const Color.fromRGBO(51, 49, 68, 1)
    ];
    return Container(
        height: height * 0.06 + message.content.length,
        width: width * 0.6,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
              colors: colors,
              stops: const [0.3, 0.7],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(color: Colors.white, fontSize: height * 0.02),
            ),
            Text(
              timeago.format(message.sentTime),
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ));
  }
}
