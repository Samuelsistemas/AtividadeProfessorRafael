import 'package:flutter/material.dart';
// Importa o pacote Flutter para construção da interface gráfica.

class Home extends StatefulWidget {
  // Declaração da tela inicial (`Home`) como um `StatefulWidget`.

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Classe responsável pelo estado da tela inicial.

  @override
  Widget build(BuildContext context) {
    // Método responsável por construir a interface da tela.

    return Scaffold(
      // Estrutura básica da tela, com um fundo, corpo e um botão flutuante.

      backgroundColor: Colors.lightGreen[200],
      // Define a cor de fundo da tela como um tom claro de verde.

      body: Container(),
      // Corpo da tela (atualmente vazio).

      floatingActionButton: FloatingActionButton(
        // Botão flutuante na parte inferior da tela.

        onPressed: () {
          Navigator.pushNamed(context, "/contato/cadastro");
          // Quando pressionado, o botão navega para a tela de cadastro de contatos.
        },

        backgroundColor: Colors.lightGreen[700],
        // Define a cor de fundo do botão como um tom mais escuro de verde.

        child: Icon(
          Icons.person_add_alt_1_outlined,
          // Ícone do botão (ícone de adicionar pessoa).

          color: Colors.white,
          // Define a cor do ícone como branca.

          size: 30,
          // Define o tamanho do ícone.
        ),
      ),
    );
  }
}
