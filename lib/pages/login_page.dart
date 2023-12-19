import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

// Widgets
import '../widgets/custom_input_fields.dart';
import '../widgets/rounded_button.dart';

// Providers
import '../providers/authentication_provider.dart';

// Services
import '../services/navigation_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  late double deviceHeight;
  late double deviceWidth;

  late AuthenticationProvider auth;
  late NavigationService navigation;

  final loginFormKey = GlobalKey<FormState>();

  String? email;
  String? pwd;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    navigation = GetIt.instance.get<NavigationService>();
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
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
            _pageTitle(),
            SizedBox(
              height: deviceHeight * 0.04,
            ),
            _loginForm(),
            SizedBox(
              height: deviceHeight * 0.05,
            ),
            _loginButton(),
            SizedBox(
              height: deviceHeight * 0.05,
            ),
            _registerAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget _pageTitle() {
    return Container(
      height: deviceHeight * 0.1,
      child: const Text(
        'Chatify',
        style: TextStyle(
            color: Colors.white, fontSize: 40, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      height: deviceHeight * 0.2,
      child: Form(
          key: loginFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                      pwd = value;
                    });
                  },
                  regEx: r".{6,}",
                  hintText: "Password",
                  obscureText: true)
            ],
          )),
    );
  }

  Widget _loginButton() {
    return RoundedButton(
        name: "Login",
        height: deviceHeight * 0.065,
        width: deviceWidth * 0.65,
        onPressed: () {
          if (loginFormKey.currentState!.validate()) {
            loginFormKey.currentState!.save();
            auth.loginUsingEmailAndPassword(email!, pwd!);
          }
        });
  }

  Widget _registerAccountLink() {
    return GestureDetector(
      onTap: () => navigation.navigateToRoute('/register'),
      child: Container(
        child: const Text(
          'Don\'t have an account?',
          style: TextStyle(color: Colors.blueAccent),
        ),
      ),
    );
  }
}
