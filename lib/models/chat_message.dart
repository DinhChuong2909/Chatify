import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  TEXT,
  IMAGE,
  UNKNOWN,
}

class ChatMessage {
  final String senderID;
  final MessageType type;
  final String content;
  final DateTime sendTime;

  ChatMessage({
    required this.senderID,
    required this.type,
    required this.content,
    required this.sendTime,
  });

  factory ChatMessage.fromJSON(Map<String, dynamic> json) {
    MessageType messageType;
    switch (json["type"]) {
      case "text":
        messageType = MessageType.TEXT;
        break;
      case "image":
        messageType = MessageType.IMAGE;
        break;
      default:
        messageType = MessageType.UNKNOWN;
    }
    return ChatMessage(
      senderID: json['sender_id'],
      type: messageType,
      content: json['content'],
      sendTime: json['sent_time'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    String messageType;
    switch (type) {
      case MessageType.TEXT:
        messageType = "text";
        break;
      case MessageType.IMAGE:
        messageType = "image";
        break;
      default:
        messageType = "unknown";
    }
    return { // map
      "content": content,
      "type": messageType,
      "sender_id": senderID,
      "sent_time": Timestamp.fromDate(sendTime),
    };
  }
}
