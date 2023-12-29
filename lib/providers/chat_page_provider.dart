import 'dart:async';

// Packages
import 'package:chatify/models/chat.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

// Services
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';
import '../services/media_service.dart';
import '../services/navigation_service.dart';

// Provider
import '../providers/authentication_provider.dart';

// Models
import '../models/chat_message.dart';

class ChatPageProvider extends ChangeNotifier {
  late DatabaseService db;
  late NavigationService navigation;
  late CloudStorageService storage;
  late MediaService media;

  AuthenticationProvider auth;
  ScrollController messagesScroll;

  String chatID;
  List<ChatMessage>? messages;

  late StreamSubscription messagesStream;
  late StreamSubscription keyboardStream;
  late KeyboardVisibilityController keyboardController;

  String? messageContent;

  String get message {
    return message;
  }

  ChatPageProvider(this.chatID, this.auth, this.messagesScroll) {
    db = GetIt.instance.get<DatabaseService>();
    media = GetIt.instance.get<MediaService>();
    storage = GetIt.instance.get<CloudStorageService>();
    navigation = GetIt.instance.get<NavigationService>();
    keyboardController = KeyboardVisibilityController();
    listenMessages();
    listenToKeyboard();
  }

  @override
  void dispose() {
    messagesStream.cancel();
    super.dispose();
  }

  void listenMessages() async {
    try {
      messagesStream = db.streamMessages(chatID).listen((snapshot) {
        List<ChatMessage> _messages = snapshot.docs.map(
          (message) {
            Map<String, dynamic> messageData =
                message.data() as Map<String, dynamic>;
            return ChatMessage.fromJSON(messageData);
          },
        ).toList();
        messages = _messages;
        notifyListeners();
        // Post frame callback
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          // Add Scroll to Bottom Call
          if (messagesScroll.hasClients) {
            messagesScroll.jumpTo(messagesScroll.position.maxScrollExtent);
          }
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void listenToKeyboard() {
    keyboardStream = keyboardController.onChange.listen(
      (e) {
        db.updateChatData(chatID, {"is_activity": e});
      },
    );
  }

  void sendText() {
    if (messageContent != null) {
      ChatMessage messageToSend = ChatMessage(
        senderID: auth.user.uid,
        type: MessageType.TEXT,
        content: messageContent!,
        sentTime: DateTime.now(),
      );
      db.addMessage(chatID, messageToSend);
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? file = await media.pickImageFromLibrary();
      if (file != null) {
        String? downloadURL =
            await storage.saveChatImageToStorage(chatID, auth.user.uid, file);
        ChatMessage messageToSend = ChatMessage(
          senderID: auth.user.uid,
          type: MessageType.IMAGE,
          content: downloadURL!,
          sentTime: DateTime.now(),
        );
        db.addMessage(chatID, messageToSend);
      }
    } catch (e) {
      print("Send image message error!");
      print(e);
    }
  }

  void deleteChat() {
    goBack();
    db.deleteChat(chatID);
  }

  void goBack() {
    navigation.goBack();
  }
}
