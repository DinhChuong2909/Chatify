// Packages
import 'package:cloud_firestore/cloud_firestore.dart';

// Models
import '../models/chat_message.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSGAGES_COLlECTION = "messages";

class DatabaseService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  DatabaseService();

  Future<void> createUser(
      String uid, String email, String name, String imageURL) async {
    try {
      await db.collection(USER_COLLECTION).doc(uid).set(
        {
          "email": email,
          "name": name,
          "image": imageURL,
          "last_active": DateTime.now().toUtc(),
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> getUser(String uid) {
    return db.collection(USER_COLLECTION).doc(uid).get();
  }

  Stream<QuerySnapshot> getChatsForUser(String uid) {
    return db
        .collection(CHAT_COLLECTION)
        .where('members', arrayContains: uid)
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessage(String chatID) {
    return db
        .collection(CHAT_COLLECTION)
        .doc(chatID)
        .collection(MESSGAGES_COLlECTION)
        .orderBy('sent_time', descending: true)
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessages(String chatID) {
    return db
        .collection(CHAT_COLLECTION)
        .doc(chatID)
        .collection(MESSGAGES_COLlECTION)
        .orderBy("sent_time", descending: false)
        .snapshots();
  }

  Future<void> addMessage(String chatID, ChatMessage chatMessage) async {
    try {
      await db
          .collection(CHAT_COLLECTION)
          .doc(chatID)
          .collection(MESSGAGES_COLlECTION)
          .add(chatMessage.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateChatData(String chatID, Map<String, dynamic> data) async {
    try {
      await db.collection(CHAT_COLLECTION).doc(chatID).update(data);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserLastSeenTime(String uid) async {
    try {
      await db
          .collection(USER_COLLECTION)
          .doc(uid)
          .update({"last_active": DateTime.now().toUtc()});
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteChat(String chatID) async {
    try {
      await db.collection(CHAT_COLLECTION).doc(chatID).delete();
    } catch (e) {
      print(e);
    }
  }
}
