import '../models/chat_user.dart';
import '../models/chat_message.dart';

class Chat {
  final String uid;
  final String currentUserID;
  final bool activity;
  final bool group;
  final List<ChatUser> members;
  List<ChatMessage> messages;

  late final List<ChatUser> recipientList;

  Chat({
    required this.uid,
    required this.currentUserID,
    required this.activity,
    required this.group,
    required this.members,
    required this.messages,
  }) {
    recipientList = members.where((i) => i.uid != currentUserID).toList();
  }

  List<ChatUser> recipients() {
    return recipientList;
  }

  String title() {
    return !group
        ? recipientList.first.name
        : recipientList.map((user) => user.name).join(", ");
  }

  String imageURL() {
    return !group ? recipientList.first.imgURL : "https://cdn-icons-png.flaticon.com/512/6387/6387947.png";
  }
}
