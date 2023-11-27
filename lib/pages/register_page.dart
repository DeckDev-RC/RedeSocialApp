import 'package:app_2/components/my_button.dart';
import 'package:app_2/components/my_textfield.dart';
import 'package:app_2/helper/helper_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // controles de edição de texto
  final usernameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  // Cadastro de usuário
  void signUp() async {
    //Mostrando circulo de carregamento
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Tendo certeza que as senhas são iguais
    if (passwordTextController.text != confirmPasswordTextController.text) {
      //pop circulo de carregamento
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      // Mostrar erro para usuário
      displayMessageToUser('Senhas não coincidem!', context);
      return;
    }
    // Tentando criar um usuário
    try {
      //criar o usuário
      UserCredential? userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );

      //depois de criar o usuário, criar novo documento na nuvem firestore chamada Users
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': usernameTextController.text,
        'bio': 'Empty bio...', // inicio bio vazia
        // adicionar qualquer campo necessario
      });

      
    } on FirebaseAuthException catch (e) {
      // pop circulo de carregamento

      //mostrar erro
      displayMessage(e.code);
    }
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(message),
        ),
      ),
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

                  const SizedBox(height: 25),

                  // Texto de boas vindas
                  Text(
                    'Vamos criar uma conta para você',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // campo de usuário
                  MyTextField(
                    controller: usernameTextController,
                    hintText: 'Nome de Usuário',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // campo de email
                  MyTextField(
                    controller: emailTextController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // campo de senha
                  MyTextField(
                    controller: passwordTextController,
                    hintText: 'Senha',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  // confirmar senha
                  MyTextField(
                    controller: confirmPasswordTextController,
                    hintText: 'Confirmar Senha',
                    obscureText: true,
                  ),

                  const SizedBox(height: 25),

                  // Botão Login
                  MyButton(
                    onTap: signUp,
                    text: 'Cadastrar conta',
                  ),

                  const SizedBox(height: 50),

                  // não tem cadastro? registre-se
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Já tem uma conta?',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Entre agora',
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
