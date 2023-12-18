// Packages
import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSGAGES_COLlECTION = "Messages";

class DatabaseService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  DatabaseService() {}

  Future<DocumentSnapshot> getUser(String uid) {
    return db.collection(USER_COLLECTION).doc(uid).get();
  }

  Future<void> updateUserLastSeenTime(String uid) async {
    try {
      await db.collection(USER_COLLECTION).doc(uid).update(
          {
            "last_active": DateTime.now().toUtc()
          }
      );
    } catch (e) {
      print(e);
    }
  }
}