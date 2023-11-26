import 'package:app_2/auth/login_or_register.dart';
import 'package:app_2/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //usuário está loggado
          if (snapshot.hasData) {
            return const HomePage();
          }

          //usuário NÃO está loggado
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
