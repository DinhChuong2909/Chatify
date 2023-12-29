import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

// Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_list_view_tiles.dart';
import '../widgets/custom_input_fields.dart';
import '../widgets/custom_chat_tile.dart';

// Models
import '../models/chat.dart';
import '../models/chat_message.dart';

// Providers
import '../providers/chat_page_provider.dart';
import '../providers/authentication_provider.dart';

// Services
import '../services/navigation_service.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  const ChatPage({super.key, required this.chat});

  @override
  State<StatefulWidget> createState() {
    return ChatPageState();
  }
}

class ChatPageState extends State<ChatPage> {
  late double deviceHeight;
  late double deviceWidth;

  late AuthenticationProvider auth;
  late ChatPageProvider pageProvider;
  late NavigationService navigation;

  late GlobalKey<FormState> messageFormState;
  late ScrollController messagesScroll;

  @override
  void initState() {
    super.initState();
    messageFormState = GlobalKey<FormState>();
    messagesScroll = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    auth = Provider.of<AuthenticationProvider>(context);
    navigation = GetIt.instance.get<NavigationService>();

    return MultiProvider(providers: [
      ChangeNotifierProvider<ChatPageProvider>(
          create: (_) =>
              ChatPageProvider(widget.chat.uid, auth, messagesScroll))
    ], child: buildUI());
  }

  Widget buildUI() {
    return Builder(builder: (BuildContext context) {
      pageProvider = context.watch<ChatPageProvider>();
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: deviceWidth * 0.03, vertical: deviceWidth * 0.02),
            height: deviceHeight,
            width: deviceWidth * 0.97,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TopBar(
                  widget.chat.title(),
                  primaryAction: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.call,
                        color: Colors.white60,
                      )),
                  secondAction: IconButton(
                    onPressed: () {
                      navigation.goBack();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  fontSize: deviceWidth * 0.05,
                ),
                messagesListUI(),
                bottomForm(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget messagesListUI() {
    if (pageProvider.messages != null) {
      if (pageProvider.messages!.isNotEmpty) {
        return Expanded(
          child: ListView.builder(
            controller: messagesScroll,
            padding: EdgeInsets.zero,
            itemCount: pageProvider.messages!.length,
            itemBuilder: (
              BuildContext context,
              int index,
            ) {
              bool isMe = pageProvider.messages![index].senderID ==
                  auth.user.uid;
              return CustomChatTile(
                height: deviceHeight,
                width: deviceWidth,
                message: pageProvider.messages![index],
                sender: widget.chat.members
                    .where((user) =>
                user.uid == pageProvider.messages![index].senderID)
                    .first,
                isMe: isMe,
              );
            },
          ),
        );
      } else {
        return const Center(
          child: Text("No messages yet",
              style: TextStyle(color: Colors.white60, fontSize: 20)),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
  }

  Widget bottomForm() {
    return Container(
      height: deviceHeight * 0.06,
      width: deviceWidth * 0.9,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 31, 29, 42),
          borderRadius: BorderRadius.circular(22)),
      child: Form(
        key: messageFormState,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [sendImgButton(), customTextField(), sendMsgButton()]),
      ),
    );
  }

  Widget customTextField() {
    return SizedBox(
      height: deviceHeight * 0.06,
      width: deviceWidth * 0.6,
      child: CustomTextFormField(
        onSaved: (value) {
          pageProvider.messageContent = value;
        },
        regEx: r'.*',
        hintText: "Type...",
        obscureText: false,
      ),
    );
  }

  Widget sendMsgButton() {
    double size = deviceHeight * 0.06;
    return SizedBox(
      height: size,
      width: size,
      child: IconButton(
          onPressed: () {
            if (messageFormState.currentState!.validate()) {
              messageFormState.currentState!.save();
              pageProvider.sendText();
              messageFormState.currentState!.reset();
            }
          },
          icon: const Icon(
            Icons.send,
            color: Colors.white,
          )),
    );
  }

  Widget sendImgButton() {
    double size = deviceHeight * 0.06;
    return SizedBox(
      height: size,
      width: size,
      child: IconButton(
          onPressed: () {
            pageProvider.sendImageMessage();
          },
          icon: const Icon(
            Icons.image,
            color: Colors.white,
          )),
    );
  }
}
