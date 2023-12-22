import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

// Services
import '../models/chat_user.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth auth;
  late final NavigationService navigationService;
  late final DatabaseService databaseService;

  late ChatUser user;

  AuthenticationProvider() {
    auth = FirebaseAuth.instance;
    navigationService = GetIt.instance.get<NavigationService>();
    databaseService = GetIt.instance.get<DatabaseService>();
    // auth.signOut();
    auth.authStateChanges().listen((_user) {
      if (_user != null) {
        databaseService.updateUserLastSeenTime(_user.uid);
        databaseService.getUser(_user.uid).then((snapshot) {
          Map<String, dynamic> userData =
              snapshot.data()! as Map<String, dynamic>;
          user = ChatUser.fromJSON(
            {
              "uid": _user.uid,
              "name": userData["name"],
              "email": userData["email"],
              "last_active": userData["last_active"],
              "image": userData["image"],
            },
          );
          navigationService.removeAndNavigateToRoute('/home');
        });
      } else {
        navigationService.removeAndNavigateToRoute('/login');
      }
    });
  }

  Future<void> loginUsingEmailAndPassword(String email, String pwd) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: pwd);
    } on FirebaseAuthException {
      print("Error loggin user into Firebase");
    } catch (e) {
      print(e);
    }
  }

  Future<String?> registerUserUsingEmailAndPassword(String email, String pwd) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: pwd);
      return credential.user!.uid;
    } on FirebaseAuthException{
      print("Error register user");
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
