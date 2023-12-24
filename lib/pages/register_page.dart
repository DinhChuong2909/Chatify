import 'package:chatify/widgets/rounded_image.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // upload user image
import 'package:get_it/get_it.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// Services
import '../services/media_service.dart';
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';
import '../services/navigation_service.dart';

// Widgets
import '../widgets/rounded_button.dart';
import '../widgets/custom_input_fields.dart';
import '../widgets/rounded_image.dart';

// Providers
import '../providers/authentication_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  late double deviceWidth;
  late double deviceHeight;

  late AuthenticationProvider auth;
  late DatabaseService db;
  late CloudStorageService cloudStorage;
  late NavigationService navigation;

  String? email;
  String? name;
  String? password;

  Rx<PlatformFile?> profileImage = Rx<PlatformFile?>(null);

  final registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthenticationProvider>(context);
    db = GetIt.instance.get<DatabaseService>();
    cloudStorage = GetIt.instance.get<CloudStorageService>();
    navigation = GetIt.instance.get<NavigationService>();
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.symmetric(
              horizontal: deviceWidth * 0.03, vertical: deviceHeight * 0.02),
          height: deviceHeight * 0.98,
          width: deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              profileImageField(),
              SizedBox(
                height: deviceHeight * 0.05,
              ),
              registerForm(),
              SizedBox(
                height: deviceHeight * 0.05,
              ),
              registerButton(),
              SizedBox(
                height: deviceHeight * 0.05,
              ),
            ],
          ),
        ));
  }

  Widget profileImageField() {
    return GestureDetector(
      onTap: () {
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then(
          (file) {
            setState(
              () {
                profileImage.value = file;
              },
            );
          },
        );
      },
      child: () {
        PlatformFile? currentProfileImage;
        if (profileImage.value != null) {
          currentProfileImage = profileImage.value!;
        } else {
          currentProfileImage = PlatformFile(
              name: "default.jpg", size: 0, path: "assets/images/default.jpg");
        }

        return RoundedImageFile(
            key: UniqueKey(),
            image: currentProfileImage,
            size: deviceWidth * 0.15);
      }(),
    );
  }

  Widget registerForm() {
    return Container(
      height: deviceHeight * 0.35,
      child: Form(
        key: registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
                onSaved: (value) {
                  setState(() {
                    name = value;
                  });
                },
                regEx: r'.{8,}',
                hintText: "Name",
                obscureText: false),
            CustomTextFormField(
                onSaved: (value) {
                  setState(() {
                    email = value;
                  });
                },
                regEx:
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                hintText: "Email",
                obscureText: false),
            CustomTextFormField(
                onSaved: (value) {
                  setState(() {
                    password = value;
                  });
                },
                regEx: r'.{8,}',
                hintText: "Password",
                obscureText: true),
          ],
        ),
      ),
    );
  }

  Widget registerButton() {
    return RoundedButton(
      name: "Register",
      height: deviceHeight * 0.065,
      width: deviceWidth * 0.65,
      onPressed: () async {
        if (registerFormKey.currentState!.validate() &&
            profileImage.value != null) {
          registerFormKey.currentState!.save();
          String? uid =
              await auth.registerUserUsingEmailAndPassword(email!, password!);
          String? imageURL = await cloudStorage.saveUserImageToStorage(
              uid!, profileImage.value!);
          await db.createUser(uid, email!, name!, imageURL!);
          await auth.logout();
          await auth.loginUsingEmailAndPassword(email!, password!);
          navigation.removeAndNavigateToRoute("/login");
        }
      },
    );
  }
}
