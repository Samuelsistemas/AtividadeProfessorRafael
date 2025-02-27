import 'dart:developer';

import 'package:flutter/material.dart';

class EntradaDadosButtons extends StatelessWidget {
  const EntradaDadosButtons({super.key});

  void _cliqueBotao() {
    log("Clique do botão");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Titulo do Aplicativo"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _cliqueBotao,
            child: const Text("Clique aqui") ),
          TextButton(
            onPressed: _cliqueBotao,
            child: const Text("Clique Aqui")),
          OutlinedButton(
            onPressed: _cliqueBotao,
             child: const  Text("CLique aqui"),
             )
        ],
      ),
    );
  }
}