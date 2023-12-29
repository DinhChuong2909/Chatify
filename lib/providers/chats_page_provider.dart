import 'dart:async';

// Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Services
import '../services/database_service.dart';

// Providers
import '../providers/authentication_provider.dart';

// Models
import '../models/chat.dart';
import '../models/chat_user.dart';
import '../models/chat_message.dart';

class ChatsPageProvider extends ChangeNotifier {
  AuthenticationProvider auth;

  late DatabaseService db;
  List<Chat>? chats;

  late StreamSubscription chatStream;

  ChatsPageProvider(this.auth) {
    db = GetIt.instance.get<DatabaseService>();
    getChats();
  }

  @override
  void dispose() {
    chatStream.cancel();
    super.dispose();
  }

  void getChats() async {
    try {
      chatStream = db.getChatsForUser(auth.user.uid).listen((snapshot) async {
        chats = await Future.wait(
          snapshot.docs.map(
            (doc) async {
              Map<String, dynamic> chatData =
                  doc.data() as Map<String, dynamic>;
              // Get User in Chat
              List<ChatUser> members = [];
              for (var uid in chatData["members"]) {
                DocumentSnapshot userSnapshot = await db.getUser(uid);
                if (userSnapshot.data() != null) {
                  Map<String, dynamic> userData =
                  userSnapshot.data() as Map<String, dynamic>;
                  userData["uid"] = userSnapshot.id;
                  members.add(ChatUser.fromJSON(userData));
                }
              }
              // Get Last Message
              List<ChatMessage> messages = [];
              QuerySnapshot chatMessage = await db.getLastMessage(doc.id);
              if (chatMessage.docs.isNotEmpty) {
                Map<String, dynamic> messageData =
                    chatMessage.docs.first.data()! as Map<String, dynamic>;
                messages.add(ChatMessage.fromJSON(messageData));
                // ChatMessage _message = ChatMessage.fromJSON(messageData);
                // messages.add(_message);
              }

              // Return chat instance
              return Chat(
                uid: doc.id,
                currentUserID: auth.user.uid,
                activity: chatData["is_activity"],
                group: chatData["is_group"],
                members: members,
                messages: messages,
              );
            },
          ).toList(),
        );
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }
}
