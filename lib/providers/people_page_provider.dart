import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

// Services
import '../services/database_service.dart';
import '../services/navigation_service.dart';

// Providers
import '../providers/authentication_provider.dart';

// Models
import '../models/chat_user.dart';
import '../models/chat.dart';

// Pages
import '../pages/chat_page.dart';

class UsersPageProvider extends ChangeNotifier {
  AuthenticationProvider auth;

  late DatabaseService db;
  late NavigationService navigation;

  List<ChatUser>? users;
  late List<ChatUser> _selectedUsers;

  List<ChatUser> get selectedUsers {
    return _selectedUsers;
  }

  UsersPageProvider(this.auth) {
    _selectedUsers = [];
    db = GetIt.instance.get<DatabaseService>();
    navigation = GetIt.instance.get<NavigationService>();
    getUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getUsers({String? name}) async {
    _selectedUsers = [];
    try {
      db.getUsers(name: name).then(
        (snapshot) {
          users = snapshot.docs.map(
            (doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              data["uid"] = doc.id;
              return ChatUser.fromJSON(data);
            },
          ).toList();
          notifyListeners();
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void updateSelectedUsers(ChatUser user) {
    if (selectedUsers.contains(user)) {
      selectedUsers.remove(user);
    } else {
      selectedUsers.add(user);
    }
    notifyListeners();
  }

  void createChat() async {
    try {
      List<String> idMembers =
      selectedUsers.map((user) => user.uid).toList();
      idMembers.add(auth.user.uid);
      bool isGroup = idMembers.length > 2;
      DocumentReference? doc = await db.createChat(
        {
          'members': idMembers,
          'is_group': isGroup,
          'is_activity': false,
        },
      );

      List<ChatUser> members = [];
      for (var id in idMembers) {
        DocumentSnapshot userSnapshot = await db.getUser(id);
        Map<String, dynamic> data = userSnapshot.data() as Map<String, dynamic>;
        data['uid'] = userSnapshot.id;
        members.add(ChatUser.fromJSON(data));
      }
      ChatPage chatPage = ChatPage(
          chat: Chat(
            uid: doc!.id,
            members: members,
            currentUserID: auth.user.uid,
            group: isGroup,
            activity: true,
            messages: [],
          ));
      _selectedUsers = [];
      notifyListeners();
      navigation.navigateToPage(chatPage);
    } catch (e) {
      print(e);
    }
  }
}
