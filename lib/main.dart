import 'package:app_2/auth/auth.dart';
import 'package:app_2/auth/login_or_register.dart';
import 'package:app_2/firebase_options.dart';
import 'package:app_2/pages/home_page.dart';
import 'package:app_2/pages/login_page.dart';
import 'package:app_2/pages/profile_page.dart';
import 'package:app_2/pages/users_page.dart';
import 'package:app_2/theme/dark_theme.dart';
import 'package:app_2/theme/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      routes: {
        '/login_register_page':(context) => const LoginOrRegister(),
        '/home_page':(context) => const HomePage(),
        '/profile_page':(context) => const ProfilePage(),
        '/users_page':(context) => const UsersPage(),
      },
      home: const AuthPage(),
    );
  }
}
