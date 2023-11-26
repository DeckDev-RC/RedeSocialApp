import 'package:flutter/material.dart';

// Mostrar mensagem de erro para usuário
void displayMessageToUser(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Center(
        child: Text(message),
      ),
    ),
  );
}
