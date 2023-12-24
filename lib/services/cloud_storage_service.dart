import 'dart:io';

// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

const String USER_COLLECTION = "Users";

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CloudStorageService();

  Future<String?> saveUserImageToStorage(String uid, PlatformFile file) async {
    try {
      Reference ref =
          _storage.ref().child('images/users/$uid/profile.${file.extension}');
      UploadTask task = ref.putFile(
        File(file.path!),
      );
      return await task.then(
        (result) => result.ref.getDownloadURL(),
      );
    } catch (e) {
      print(e);
    }
    return "";
  }

  Future<String?> saveChatImageToStorage(
      String chatID, String uid, PlatformFile file) async {
    try {
      Reference ref = _storage.ref().child(
          'images/chats/$chatID/${uid}_${Timestamp.now().microsecondsSinceEpoch}/profile.${file.extension}');
      UploadTask task = ref.putFile(
        File(file.path!),
      );
      return await task.then(
        (result) => result.ref.getDownloadURL(),
      );
    } catch (e) {
      print(e);
    }
    return "";
  }
}
