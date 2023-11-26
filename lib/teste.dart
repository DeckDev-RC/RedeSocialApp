import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey,
        body: Center(
          child: TextField(
            obscureText: false,
            style: TextStyle(color: Colors.blue, letterSpacing: 2.0), // Ajuste o estilo aqui
            decoration: InputDecoration(
              labelText: 'Label', // Adicione um rótulo para melhorar a visibilidade
              labelStyle: const TextStyle(color: Colors.green, letterSpacing: 20),
              hintStyle: const TextStyle(color: Colors.red, letterSpacing: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
