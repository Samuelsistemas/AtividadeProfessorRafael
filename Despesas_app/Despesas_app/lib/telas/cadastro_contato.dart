import 'dart:io';
// Importa a biblioteca `dart:io` para manipular arquivos locais, como imagens.

import 'package:flutter/material.dart';
// Importa o pacote Flutter para construção da interface.

import 'package:image_picker/image_picker.dart';
// Importa a biblioteca `image_picker` para capturar imagens da câmera ou galeria.

import 'package:intl/intl.dart';
// Importa a biblioteca `intl` para formatar datas.

import 'package:minha_agenda_supabase/model/contato.dart';
// Importa a classe `Contato`, que representa um contato no sistema.

import 'package:minha_agenda_supabase/model/usuario.dart';
// Importa a classe `Usuario`, que representa um usuário logado.

import 'package:minha_agenda_supabase/repository/contato_repository.dart';
// Importa a classe `ContatoRepository`, responsável por salvar contatos no banco.

import 'package:minha_agenda_supabase/repository/usuario_repository.dart';
// Importa a classe `UsuarioRepository`, responsável por autenticação de usuários.

class CadastroContato extends StatefulWidget {
  // Declaração da tela de cadastro de contatos.

  const CadastroContato({super.key});

  @override
  State<CadastroContato> createState() => _CadastroContatoState();
}

class _CadastroContatoState extends State<CadastroContato> {
  // Classe responsável pelo estado da tela.

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _nascimentoController = TextEditingController();
  // Controladores de texto para capturar os dados do formulário.

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Chave global para validar o formulário.

  final bool _mostrarSenha = false;
  // Variável para controle de exibição de senha (não utilizada no código).

  bool _loading = false;
  // Indica se o processo de salvamento está em andamento.

  bool? _foto;
  // Indica se uma foto foi selecionada.

  XFile? _imagem;
  // Variável para armazenar a imagem capturada ou selecionada.

  Future<void> _capturarFoto({bool camera = true}) async {
    // Método para capturar ou selecionar uma foto.

    setState(() {
      _loading = true;
    });

    XFile? temp;
    final ImagePicker picker = ImagePicker();
    // Instancia um seletor de imagens.

    if (camera) {
      temp = await picker.pickImage(source: ImageSource.camera);
      // Captura a imagem da câmera.
    } else {
      temp = await picker.pickImage(source: ImageSource.gallery);
      // Seleciona a imagem da galeria.
    }

    if (temp != null) {
      setState(() {
        _foto = true;
        _imagem = temp;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    // Método chamado ao destruir a tela para liberar os controladores.

    _nomeController.dispose();
    _telefoneController.dispose();
    _nascimentoController.dispose();
    super.dispose();
  }

  Future<void> _abrirCalendario(BuildContext context) async {
    // Método para abrir um calendário e selecionar a data de nascimento.

    final DateTime? data = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      currentDate: DateTime.now(),
    );

    if (data != null) {
      setState(() {
        _nascimentoController.text = DateFormat("dd/MM/yyyy").format(data).toString();
      });
    }
  }

  bool _validarFoto() {
    // Método para verificar se uma foto foi selecionada.

    return _imagem != null ? true : false;
  }

  Future<void> _salvarContato() async {
    // Método para salvar o contato no banco de dados.

    setState(() {
      _loading = true;
    });

    final bool isValid = _formKey.currentState?.validate() ?? false;
    // Valida os campos do formulário.

    final navigator = Navigator.of(context);

    setState(() {
      _foto = _validarFoto();
    });

    if (isValid && _foto!) {
      Usuario usuarioLogado = UsuarioRepository().usuarioLogado();
      // Obtém o usuário autenticado.

      final novoContato = await ContatoRepository().cadastroContato(
        Contato(
          usuarioLogado.id,
          _nomeController.text,
          _telefoneController.text,
          DateFormat('dd/MM/yyyy').parse(_nascimentoController.text),
        ),
      );

      novoContato.foto = await ContatoRepository().enviarFoto(
        File(_imagem!.path),
        novoContato.usuario!,
      );

      ContatoRepository().atualizarFoto(novoContato);
      // Atualiza a foto do contato no banco de dados.

      navigator.pop();
      // Fecha a tela após o cadastro.
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Método responsável por construir a interface da tela.

    return Scaffold(
      backgroundColor: Colors.lightGreen[200],
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Center(
                      child: Text(
                        "Cadastro de novo Contato",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.lightGreen[900],
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    TextFormField(
                      controller: _nomeController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        filled: true,
                        fillColor: Colors.lightGreen[100],
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Este campo é obrigatório' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _telefoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Telefone',
                        filled: true,
                        fillColor: Colors.lightGreen[100],
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Este campo é obrigatório' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nascimentoController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: 'Data de Nascimento',
                        suffixIcon: IconButton(
                          onPressed: () => _abrirCalendario(context),
                          icon: Icon(Icons.calendar_month_outlined),
                        ),
                        filled: true,
                        fillColor: Colors.lightGreen[100],
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Este campo é obrigatório' : null,
                    ),
                    const SizedBox(height: 20),
                    _imagem != null ? Image.file(File(_imagem!.path), fit: BoxFit.cover) : Container(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _salvarContato(),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen[700]),
                      child: Text("Criar contato", style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
