import 'dart:developer';

import 'package:flutter/material.dart';

const List<String> linguagens =<String>['Dart','PHP','Java'];

class EntradaDadosClique extends StatefulWidget {
  const EntradaDadosClique({super.key});

  @override
  State<EntradaDadosClique> createState() => _EntradaDadosCliqueState();
}

class _EntradaDadosCliqueState extends State<EntradaDadosClique> {
  bool _flutter = false;
  bool _luzes = false;
  double _volume = 1;
  String? _linguagem;
  String? _linguagemSelecionada;

  void _enviarDados(){
    log("Valor Checkbox: $_flutter Valor Switch: $_luzes\nVolume: $_volume\nLinguagem: $_linguagem\nLinguagem Selecionada: $_linguagemSelecionada");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Entrada de dados por clique"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: SafeArea(child: Padding(padding: const EdgeInsets.only(left: 16, right: 16,
      ),
      child: Column(
        children: [
          Row(
            children: [
            const Text("Flutter"), 
            Checkbox(value: _flutter,
            activeColor: Colors.amber,
            onChanged: (bool? value ){
              setState(() {
                _flutter = value!;
              });
            },)
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              const Text("ligar luzes?"),
              Switch(value: _luzes, onChanged: (bool value){
                setState(() {
                  _luzes = value;
                });
              })
            ],
          ),
          const SizedBox(height: 20.0,),
          Slider(value: _volume,
           max: 5,
           divisions: 5,
           label: _volume.toString(),
           onChanged: (double value){
            setState(() {
              _volume = value;

            });

           },
           ),
           const SizedBox(
            height: 20.0,
           ),
           
          Row(
            children: [
              Radio(value: "Dart", groupValue: _linguagem, onChanged: (String? value){
                setState(() {
                  _linguagem = value;
                });
              }),
              const Text("Dart"),
            ],
          ),

          Row(
            children: [
              Radio(value: "PHP", groupValue: _linguagem, onChanged: (String? value){
                setState(() {
                  _linguagem = value;
                });
              }),
              const Text("PHP"),
            ],
          ),
            const SizedBox(
            height: 20.0,
           ),
           DropdownButton(value: _linguagemSelecionada, items: linguagens.map<DropdownMenuItem<String>>((String value){
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value));
            }).toList(), 
           onChanged: (String? value){
            setState(() {
              _linguagemSelecionada = value;
            });
           }),
           const SizedBox(
            height: 20.0,
           ),


           ElevatedButton(onPressed: _enviarDados, child: const Text("Enviar")),

           
        ],
      ),
      ),
      ),
    );
  }
}