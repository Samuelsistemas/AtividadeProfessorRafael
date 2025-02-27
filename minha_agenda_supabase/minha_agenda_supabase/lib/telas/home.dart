import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[200],
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/contato/cadastro");
        },
        backgroundColor: Colors.lightGreen[700],
        child: Icon(
          Icons.person_add_alt_1_outlined,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
