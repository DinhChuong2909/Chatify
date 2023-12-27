import 'package:chatify/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

// Providers
import 'package:chatify/providers/authentication_provider.dart';
import '../providers/chats_page_provider.dart';

// Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_list_view_tiles.dart';

// Models
import '../models/chat.dart';
import '../models/chat_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ChatPageState();
  }
}

class ChatPageState extends State<ChatPage> {
  late double deviceHeight;
  late double deviceWidth;

  late AuthenticationProvider auth;
  late ChatsPageProvider pageProvider;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatsPageProvider>(
            create: (_) => ChatsPageProvider(auth)),
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(builder: (BuildContext context) {
      pageProvider = context.watch<ChatsPageProvider>();
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: deviceWidth * 0.03,
          vertical: deviceHeight * 0.02,
        ),
        height: deviceHeight * 0.98,
        width: deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopBar(
              'Chats',
              primaryAction: IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: Color.fromRGBO(0, 82, 218, 1.0),
                ),
                onPressed: () {
                  auth.logout();
                },
              ),
            ),
            chatList(),
          ],
        ),
      );
    });
  }

  Widget chatList() {
    List<Chat>? chats = pageProvider.chats;
    return Expanded(
      child: (() {
        if (chats != null) {
          if (chats.isNotEmpty) {
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (BuildContext context, int index) {
                return chatTile(chats[index]);
              },
            );
          } else {
            return const Center(
              child: Text(
                "No Chats Found.",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      })(),
    );
  }

  Widget chatTile(Chat chat) {
    List<ChatUser> recipients = chat.recipients();
    bool isActive = recipients.any(
      (doc) => doc.wasRecentlyActive(),
    );
    String subtitle = "";
    if (chat.messages.isNotEmpty) {
      subtitle = chat.messages.first.type != MessageType.TEXT
          ? "Media Attachment"
          : chat.messages.first.content;
    }
    return CustomListViewTileWithActivity(
      height: deviceHeight * 0.1,
      title: chat.title(),
      subtitle: subtitle,
      imgPath: chat.imageURL(),
      isActive: isActive,
      isActitivy: chat.activity,
      onTap: () {},
    );
  }
}
