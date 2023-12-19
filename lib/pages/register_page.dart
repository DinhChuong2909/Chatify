import 'package:chatify/widgets/rounded_image.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // upload user image
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

// Services
import '../services/media_service.dart';
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';

// Widgets
import '../widgets/rounded_button.dart';
import '../widgets/custom_input_fields.dart';
import '../widgets/rounded_image.dart';

// Providers
import '../providers/authentication_provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  late double deviceWidth;
  late double deviceHeight;

  String? email;
  String? name;
  String? password;

  PlatformFile? profileImage;

  final registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
              regitsetButton(),
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
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then((file) {
          setState(() {
            profileImage = file;
          });
        });
      },
      child: () {
        if (profileImage != null) {
          return RoundedImageFile(
              key: UniqueKey(), image: profileImage!, size: deviceWidth * 0.15);
        } else {
          return RoundedImageNetwork(
              key: UniqueKey(),
              imgPath:
                  "https://media.gcflearnfree.org/ctassets/topics/246/share_flower_fullsize.jpg",
              size: deviceHeight * 0.15);
        }
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
      height: deviceWidth * 0.065,
      width: deviceWidth * 0.065,
      onPressed: () async {},
    );
  }
}
