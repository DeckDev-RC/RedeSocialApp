import 'package:app_2/components/drawer.dart';
import 'package:app_2/components/lock_posts.dart';
import 'package:app_2/components/my_textfield.dart';
import 'package:app_2/helper/helper_methods.dart';
import 'package:app_2/pages/profile_page.dart';
import 'package:app_2/pages/users_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //usuário
  final currentUser = FirebaseAuth.instance.currentUser!;

  // Controle de texto
  final textController = TextEditingController();

  // Saída de usuário loggado
  void signOut() {
    Navigator.pop(context);
    FirebaseAuth.instance.signOut();
  }

  //Postar Mensagem
  void postMessage() {
    // Só vai postar aqui se tiver algo na caixa de texto
    if (textController.text.isNotEmpty) {
      //store no firebase
      FirebaseFirestore.instance.collection('User Posts').add({
        'username': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }

    // Limpar caixa de texto
    setState(() {
      textController.clear();
    });
  }

  //Navegando para página de perfil
  void goToProfilePage() {
    // pop menu lateral
    Navigator.pop(context);

    //indo para perfil
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  //Navegando para a página de usuários
  void goToUsersPage() {
    //pop menu lateral
    Navigator.pop(context);

    //indo para usuários
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UsersPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'L O C K E R',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onUsersTap: goToUsersPage,
        onSignOut: signOut,
      ),
      body: Center(
        child: Column(
          children: [
            // o cadeado
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('User Posts')
                    .orderBy(
                      'TimeStamp',
                      descending: false,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        //  pegando mensagens
                        final post = snapshot.data!.docs[index];
                        return LockPost(
                          message: post['Message'],
                          user: post['username'],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                          time: formatDate(post['TimeStamp']),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error:${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),

            // mensagem postada
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  //caixa de texto
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: 'Escreva algo no cadeado...',
                      obscureText: false,
                    ),
                  ),
                  //Botão de postagem
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(Icons.arrow_circle_up),
                  ),
                ],
              ),
            ),

            //entrou em
            Text(
              'Entrou como: ${currentUser.email!}',
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
