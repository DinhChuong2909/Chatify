// Packages
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

// Services
import './services/navigation_service.dart';

// Providers
import './providers/authentication_provider.dart';

// Pages
import './pages/splash_page.dart';
import './pages/login_page.dart';
import './pages/home_page.dart';

void main() async {
  runApp(
    SplashPage(
      key: UniqueKey(),
      onInitializationComplete: () {
        Future.delayed(const Duration(seconds: 2), () {
        runApp(
          const MainApp(),
        );
      });
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
            create: (BuildContext context) {
          return AuthenticationProvider();
        })
      ],
      child: MaterialApp(
        title: 'Chatify',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueAccent,
            background: const Color.fromRGBO(36, 35, 49, 1.0),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromRGBO(30, 29, 37, 1.0),
          ),
        ),
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: '/login',
        routes: {
          '/login': (BuildContext context) => const LoginPage(),
          '/home' : (BuildContext context) => HomePage(),
        },
      ),
    );
  }
}
