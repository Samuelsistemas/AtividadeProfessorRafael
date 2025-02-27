import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ExibicaoDadosImagem extends StatefulWidget {
  const ExibicaoDadosImagem({super.key});

  @override
  State<ExibicaoDadosImagem> createState() => _ExibicaoDadosImagemState();
}

class _ExibicaoDadosImagemState extends State<ExibicaoDadosImagem> {
  String? _imagem;

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exibicao de Imagem'),
        backgroundColor: Colors.amber[700],

      ),
      body: SafeArea(
        child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 16,
        ),
        child: Column(
          children: [
            Image.asset('assets/imagem.jpg',
            width: 200,
            ),
            const SizedBox(height: 10.0,),
            Container(
            width: 200,
            child: Image.asset('assets/imagem.jpeg',
            height: 100,
            fit: BoxFit.contain,
            ),
            ),
            const SizedBox(height: 20.0,),
            Image.network('link da imagem',
            loadingBuilder: context,child,progress){
                return progress == null ? child : const LinearProgressIndicator();
            },
            const SizedBox(height: 20.0,),
            ElevatedButton(onPressed: (){
              setState(() {
                
                _imagem = 
              });
            }, child: const Text("Carregar Imagem"),
            ),
            const SizedBox(height: 10.0,),
            _imagem != null ?
            Image.network(_imagem!, 
            loadingBuilder: (context, child, loadingProgress){
              return loadingProgress == null ? child : const CircularProgressIndicator();

            },
            )
            :Container(),
          ],

      ),)),

    );
  }
}