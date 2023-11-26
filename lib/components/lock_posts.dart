// ignore_for_file: use_build_context_synchronously

import 'package:app_2/components/comment.dart';
import 'package:app_2/components/comment_button.dart';
import 'package:app_2/components/delete_button.dart';
import 'package:app_2/components/like_button.dart';
import 'package:app_2/helper/helper_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LockPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;

  const LockPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    required this.time,
  });

  @override
  State<LockPost> createState() => _LockPostState();
}

class _LockPostState extends State<LockPost> {
  //Usuário
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  int commentCount = 0;

  // controle de texto comentarios
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);

    updateCommentCount();
  }

  void updateCommentCount() {
    FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postId)
        .collection('Comments')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        commentCount = querySnapshot.docs.length;
      });
    });
  }

  //Alternancia like
  void toggleLIke() {
    setState(() {
      isLiked = !isLiked;
    });

    //Acesso o documento no Firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      //Se a postagem foi curtida, adicione o e-mail do usuário ao campo de curtidas.
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      //Se a postagem foi descurtida, remova o e-mail do usuário do campo de curtidas.
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  //adicionando comentario
  void addComment(String commentText) async {
    //Escreva o comentário no Firestore, na coleção de comentários para esta postagem
    FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postId)
        .collection('Comments')
        .add({
      'CommentText': commentText,
      'CommentedBy': currentUser.email,
      'CommentTime': Timestamp.now() // lembrar de formatar quando mostrar
    });

    updateCommentCount();
  }

  //mostrando uma caixa de dialogo adicionando comentário
  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Comentário'),
        content: TextField(
          controller: _commentTextController,
          decoration:
              const InputDecoration(hintText: 'Escreva um comentário...'),
        ),
        actions: [
          //botão cancelar
          TextButton(
            onPressed: () {
              //pop na caixa
              Navigator.pop(context);

              //limpar controlador
              _commentTextController.clear();
            },
            child: const Text('Cancelar'),
          ),

          // botão postar
          TextButton(
            onPressed: () {
              //adiciona comentario
              addComment(_commentTextController.text);

              //pop na caixa
              Navigator.pop(context);

              //limpa controlador
              _commentTextController.clear();
            },
            child: const Text('Postar'),
          ),
        ],
      ),
    );
  }

  // deletar um post
  void deletePost() {
    //mostrando um dialogo para confirmação antes de deletar o post
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar Post'),
        content: const Text('Tem certeza que quer deletar este post? '),
        actions: [
          // BOTÃO CANCELAR
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),

          //BOTÃO DELETAR
          TextButton(
            onPressed: () async {
              //Exclua os comentários do Firestore primeiro
              //(Se você apenas excluir a postagem, os comentários ainda permanecerão armazenados no Firestore)
              final commentDocs = await FirebaseFirestore.instance
                  .collection('User Posts')
                  .doc(widget.postId)
                  .collection('Comments')
                  .get();

              for (var doc in commentDocs.docs) {
                await FirebaseFirestore.instance
                    .collection('User Posts')
                    .doc(widget.postId)
                    .collection('Comments')
                    .doc(doc.id)
                    .delete();
              }

              //Em seguida, exclua a postagem
              FirebaseFirestore.instance
                  .collection('User Posts')
                  .doc(widget.postId)
                  .delete()
                  .then((value) => print('post deletado'))
                  .catchError(
                      (error) => print('falha do deletar o post: $error'));

              updateCommentCount();

              //Feche o dialogo
              Navigator.pop(context);
            },
            child: const Text('Deletar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Posts
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //grupo de texto (mensagem + email usuário)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mensagem
                  Text(widget.message),

                  const SizedBox(height: 5),

                  // Usuário
                  Row(
                    children: [
                      Text(
                        widget.user,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Text(
                        ' . ',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Text(
                        widget.time,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ],
              ),

              // botão deletar
              if (widget.user == currentUser.email)
                DeleteButton(onTap: deletePost),
            ],
          ),

          const SizedBox(height: 20),

          // botões
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //LIKE
              Column(
                children: [
                  // BOTÃO DE LIKE
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLIke,
                  ),

                  const SizedBox(height: 5),

                  //CONTADOR DE LIKES
                  Text(
                    widget.likes.length.toString(),
                    style: const TextStyle(color: Colors.grey),
                  )
                ],
              ),

              const SizedBox(width: 10),

              //COMENTARIO
              Column(
                children: [
                  // BOTÃO DE COMENTARIO
                  CommentButton(onTap: showCommentDialog),

                  const SizedBox(height: 5),
                  //CONTADOR DE comentarios
                  Text(
                    commentCount.toString(),
                    style: const TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          //comentários de baixo do post
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('User Posts')
                .doc(widget.postId)
                .collection('Comments')
                .orderBy('CommentTime', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              // mostrando circulo de carregamento se nao tiver dados ainda
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                shrinkWrap: true, //para listas aninhadas
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  //pegando comentarios
                  final commentData = doc.data() as Map<String, dynamic>;

                  //retornando os comentarios
                  return Comment(
                    text: commentData['CommentText'],
                    user: commentData['CommentedBy'],
                    time: formatDate(commentData['CommentTime']),
                  );
                }).toList(),
              );
            },
          )
        ],
      ),
    );
  }
}
