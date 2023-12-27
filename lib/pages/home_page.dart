import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Pages
import './chats_page.dart';
import './users_page.dart';
import './settings_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int currentPage = 0;
  final List<Widget> pages = [
    const ChatPage(),
    const UsersPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: "Chats",
            icon: Icon(Icons.chat_bubble_sharp),
          ),
          BottomNavigationBarItem(
            label: "Users",
            icon: Icon(Icons.supervised_user_circle_sharp),
          ),
          BottomNavigationBarItem(
            label: "Settings",
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
