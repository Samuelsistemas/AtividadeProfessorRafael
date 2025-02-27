import 'package:flutter/material.dart';

class ExibicaoDadosTexto extends StatefulWidget {
  const ExibicaoDadosTexto({super.key});

  @override
  State<ExibicaoDadosTexto> createState() => _ExibicaoDadosTextoState();
}

class _ExibicaoDadosTextoState extends State<ExibicaoDadosTexto> {

  final TextEditingController _nomeController= TextEditingController();
  String _nome = '';
@override
  void dispose() {
    // TODO: implement dispose
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exibicao de texto"),
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'texto dentro do widget text',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            RichText(text: const TextSpan(
              text: 'Texto dentro do widget text.',
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
            ),
            const SizedBox(height: 30.0,),
            TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  hintText: 'Digite seu nome',
                  labelText: 'Nome',
                  border: OutlineInputBorder(),

                ),
            ),

            ElevatedButton(
            onPressed: (){
              setState(() {
                _nome = _nomeController.text;
                _nomeController.text ='';
              });
            },
            child: const Text('Enviar')),
            const SizedBox(height: 40.0,),
            Text(_nome),
          ],
        ),
      )),
    );
  }
}