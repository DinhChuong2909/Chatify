import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

// Providers
import '../providers/authentication_provider.dart';
import '../providers/people_page_provider.dart';

// Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_search_field.dart';
import '../widgets/custom_person_tile.dart';
import '../widgets/rounded_button.dart';

// Models
import '../models/chat_user.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return UsersPageState();
  }
}

class UsersPageState extends State<UsersPage> {
  late double deviceHeight;
  late double deviceWidth;

  late AuthenticationProvider auth;
  late UsersPageProvider usersProvider;
  final TextEditingController searchFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersPageProvider>(
          create: (_) => UsersPageProvider(auth),
        ),
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {
        usersProvider = context.watch<UsersPageProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
              horizontal: deviceWidth * 0.03, vertical: deviceHeight * 0.02),
          height: deviceHeight * 0.98,
          width: deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar('People'),
              CustomSearchBar(
                onComplete: (value) {
                  usersProvider.getUsers(name: value);
                  FocusScope.of(context).unfocus();
                },
                hintText: "Search...",
                obscureText: false,
                textController: searchFieldController,
                icon: Icons.search,
              ),
              SizedBox(
                height: deviceHeight * 0.02,
              ),
              usersList(),
              startChatButton(deviceHeight, deviceWidth),
              SizedBox(
                height: deviceHeight * 0.02,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget usersList() {
    List<ChatUser>? users = usersProvider.users;

    return Expanded(
      child: RefreshIndicator(
        key: UniqueKey(),
        color: const Color.fromRGBO(36, 35, 49, 1.0),
        backgroundColor: Colors.white,
        strokeWidth: 4.0,
        onRefresh: () async {
          usersProvider.getUsers();
          print('refresh done');
        },
        child: Column(
          children: [
            Expanded(child: () {
              return users != null
                  ? users.isNotEmpty
                      ? ListView.builder(
                          itemCount: users.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return CustomPersonTile(
                              height: deviceHeight,
                              width: deviceWidth,
                              name: users[index].name,
                              imgUrl: users[index].imgURL,
                              isActive: users[index].wasRecentlyActive(),
                              isSelected: usersProvider.selectedUsers
                                  .contains(users[index]),
                              onTap: () {
                                usersProvider.updateSelectedUsers(users[index]);
                              },
                            );
                          },
                        )
                      : const Center(
                          child: Text("No users found"),
                        )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            }())
          ],
        ),
      ),
    );
  }

  Widget startChatButton(double height, double width) {
    return Visibility(
      visible: usersProvider.selectedUsers.isNotEmpty,
      child: RoundedButton(
        name: usersProvider.selectedUsers.length == 1
            ? "Chat with ${usersProvider.selectedUsers.first.name}"
            : "Group chat ${usersProvider.selectedUsers.length + 1} people",
        height: height * 0.06,
        width: width * 0.7,
        onPressed: () {
          usersProvider.createChat();
        },
      ),
    );
  }
}
