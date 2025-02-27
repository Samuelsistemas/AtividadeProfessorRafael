
import 'dart:math';

import 'package:flutter/material.dart';

class EntradaDadosListtile extends StatefulWidget {
  const EntradaDadosListtile({super.key});

  @override
  State<EntradaDadosListtile> createState() => _EntradaDadosListtileState();
}

class _EntradaDadosListtileState extends State<EntradaDadosListtile> {


  String? _linguagem;
  bool _dart = false;
  bool _php = false;
  bool _java = false;

  bool  _cozinha = false;
  bool  _sala = false;
  bool  _quarto = false;

void _setLinguagem(String? value){
  setState(() {
    _linguagem = value;
  });
}

void _enviarDados(){
  log("Linguagem: $_linguagem" as num);
  log("Linguagens selecionadas: \nDart: $_dart\nPHP: $_php\nJava:$_java" as num);
  log("Luzes : \nSala: $_sala\nCozinha:$_cozinha\nQuarto:$_quarto" as num);

}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text("Ëntrada de Dados - List Tile"),
        backgroundColor: Colors.orange,

      ),

      body: SafeArea(child: SingleChildScrollView(child: Padding(padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("Selecione uma linguagem "),
          ListTile(
            title: const Text("Dart"),
            subtitle: const Text("linguagem utilizada com o flutter"),
            leading: Radio<String>(
              value: "Dart",
              groupValue: _linguagem,
              onChanged: _setLinguagem ,
            ),
          ),
          ListTile(
            title: const Text("PHP"),
            leading: Radio<String>(
              value: "PHP",
              groupValue: _linguagem,
              onChanged: _setLinguagem ,
            ),
          ),
          ListTile(
            title: const Text("JAVA"),
            leading: Radio<String>(
              value: "JAVA",
              groupValue: _linguagem,
              onChanged: _setLinguagem ,
            ),
          ),
          const SizedBox(height: 20.0),
          const Text("Selecione uma ou mais linguagens"),
          CheckboxListTile(
            title: const Text('Dart'),
            value: _dart,
             onChanged: (bool? value) {
              	setState(() {
              	  _dart = value!;
              	});
             }),
             CheckboxListTile(
            title: const Text('PHP'),
            value: _php,
             onChanged: (bool? value) {
              	setState(() {
              	  _php = value!;
              	});
             }),
             CheckboxListTile(
            title: const Text('Java'),
            value: _java,
             onChanged: (bool? value) {
              	setState(() {
              	  _java = value!;
              	});
             }),

             const SizedBox(height: 20.0,),
             const Text("Ligue/Desligue as luzes:"),

             SwitchListTile(
              title: const Text("Sala"),
              value: _sala,
               onChanged: (bool value){
                setState(() {
                  _sala= value;
                });

               },
               ),
                SwitchListTile(
              title: const Text("Cozinha"),
              value: _cozinha,
               onChanged: (bool value){
                setState(() {
                  _cozinha= value;
                });

               },
               ),
                SwitchListTile(
              title: const Text("Quarto"),
              value: _quarto,
               onChanged: (bool value){
                setState(() {
                  _quarto= value;
                });

               },
               ),

          const SizedBox(height: 30.0,),
          ElevatedButton(onPressed: _enviarDados,
          child: const Text("Enviar"),
          ),
          
        ],
      )
      )
      ,
      ),
       ),

    );
  }
}