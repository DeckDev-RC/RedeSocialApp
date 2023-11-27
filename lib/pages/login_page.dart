import 'package:app_2/components/my_button.dart';
import 'package:app_2/components/my_textfield.dart';
import 'package:app_2/components/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controles de edição de texto
  final emailTextController = TextEditingController();
  final passwordController = TextEditingController();

  //Loggin usuario Entrar
  void signIn() async {
    // mostrando circulo de carregamento
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // tentando logar
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordController.text,
      );
      // pop do circulo de carregamento
      circularLoad();
    } on FirebaseAuthException catch (e) {
      circularLoad();
      //Senha ou email errado
      if (e.code == 'invalid-credential') {
        wrongEmailOrPwdMessage();
        // email invalido
      } else if (e.code == 'invalid-email') {
        invalidEmailMessage();
      }
      // display de mensagem de erro
      // displayMessageToUser(e.code, context);
    }
  }

  void circularLoad() {
    Navigator.pop(context);
  }

  void wrongEmailOrPwdMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Email ou Senha incorretos!'),
        );
      },
    );
  }

  void invalidEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Email Inválido!'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  // Logo
                  Icon(
                    Icons.lock,
                    size: 100,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'L O C K E D',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),

                  const SizedBox(height: 50),
                  // Texto de boas vindas
                  Text(
                    'Bem-vindo de volta!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // campo de usuário
                  MyTextField(
                    controller: emailTextController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // campo de senha
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Senha',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  // Esqueceu a senha?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Esqueceu a Senha?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Botão Login
                  MyButton(
                    onTap: signIn,
                    text: 'Entrar',
                  ),

                  const SizedBox(height: 50),

                  // ou continue com
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: .0),
                          child: Text(
                            'Continuar com',
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  // botões login google + apple
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //botão google
                      SquareTile(imagePath: 'lib/assets/google.png'),

                      SizedBox(
                        width: 10,
                      ),

                      //botão apple
                      SquareTile(imagePath: 'lib/assets/apple.png'),
                    ],
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  // não tem cadastro? registre-se
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Não tem conta?',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Registre-se agora',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
