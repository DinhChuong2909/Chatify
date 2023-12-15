// Packages
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// Services
import './services/navigation_service.dart';

// Pages
import './pages/splash_page.dart';
import './pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    SplashPage(
      key: UniqueKey(),
      onInitializationComplete: () {
        runApp(
          const MainApp(),
        );
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      },
    );
  }
}
