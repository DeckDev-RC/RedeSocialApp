import 'package:app_2/helper/helper_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Usuários',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          //qualquer erro
          if (snapshot.hasError) {
            displayMessageToUser('Algo deu errado', context);
          }

          //mostrando circulo de carregamento
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == null) {
            return const Text('Sem Dados');
          }

          //Pegando todos os usuários
          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              //pegando usuários individualmente
              final user = users[index];

              return ListTile(
                title: Text(
                  user['username'],
                  style: TextStyle(color: Colors.green[400]),
                ),
                subtitle: Text(user['email']),
              );
            },
          );
        },
      ),
    );
  }
}
