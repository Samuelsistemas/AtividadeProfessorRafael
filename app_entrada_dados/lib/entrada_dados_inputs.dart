import 'dart:developer';

import 'package:flutter/material.dart';

class EntradaDadosInputs extends StatefulWidget {
  const EntradaDadosInputs({super.key});

  @override
  State<EntradaDadosInputs> createState() => _EntradaDadosInputsState();
}

class _EntradaDadosInputsState extends State<EntradaDadosInputs> {

  final TextEditingController _textoController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();


  void _salvarForm(){
    final bool isvalid = _formkey.currentState?.validate() ?? false;

    if(!isvalid){
      return;
    }

  }
  @override
  void dispose() {
    _textoController.dispose();
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16), 
          child: Column(
            children: [
              TextField(
                controller: _textoController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Digite um texto',
                ),
              ),
              const SizedBox (height: 10.0,),
              ElevatedButton(onPressed: (){
                log("Texto do input:${_textoController.text}");
              }, 
              child: const Text("Enviar")
              ),
              const SizedBox (height: 50.0,
              ),
              Form(
                key:_formkey ,
                child: Column(
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      hintText: "Digite seu nome"
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Este campo é obrigatório';
                      } 

                      return null;
                    },
                  ),
                  const SizedBox(height: 30.0,),
                  ElevatedButton(onPressed: _salvarForm,
                   style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white70,

                   ) ,
                   child: const Text("Enviar"),
                   )
                ],
              )),

            ],
          ),
        ),
        ),
    );
  }
}