import 'package:flutter/material.dart';
// Importa o pacote Flutter para construção da interface.

import 'package:minha_agenda_supabase/model/usuario.dart';
// Importa a classe `Usuario`, que representa um usuário no sistema.

import 'package:minha_agenda_supabase/repository/usuario_repository.dart';
// Importa a classe `UsuarioRepository`, responsável por criar e autenticar usuários no Supabase.

import 'package:supabase_flutter/supabase_flutter.dart';
// Importa a biblioteca do Supabase para comunicação com o banco de dados e autenticação.

class CadastroUsuario extends StatefulWidget {
  // Declaração da tela de cadastro de usuários.

  const CadastroUsuario({super.key});

  @override
  State<CadastroUsuario> createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  // Classe responsável pelo estado da tela.

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _csenhaController = TextEditingController();
  // Controladores de texto para capturar os dados do formulário.

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Chave global para validar o formulário.

  bool _mostrarSenha = false;
  // Indica se a senha deve ser exibida ou ocultada.

  bool _isEmailUso = false;
  // Indica se o e-mail já está em uso.

  bool _isSenhaFraca = false;
  // Indica se a senha é considerada fraca.

  bool _loading = false;
  // Indica se o processo de cadastro está em andamento.

  Future<void> _salvarUsuario() async {
    // Método para criar um novo usuário.

    setState(() {
      _loading = true;
    });

    final bool isValid = _formKey.currentState?.validate() ?? false;
    // Valida os campos do formulário.

    final navigator = Navigator.of(context);

    if (isValid) {
      try {
        final AuthResponse usuarioAutenticado = await UsuarioRepository().criarUsuario(
          Usuario(
            _nomeController.text,
            _emailController.text,
            _senhaController.text,
          ),
        );
        // Chama o método para criar um novo usuário no Supabase.

        if (usuarioAutenticado.session != null) {
          navigator.pushReplacementNamed("/");
          // Redireciona para a tela inicial caso o cadastro seja bem-sucedido.
        }

      } on AuthApiException catch (e) {
        // Captura erros de autenticação.

        switch (e.code) {
          case 'user_already_exists':
            // Se o erro for de e-mail já cadastrado:
            setState(() {
              _isEmailUso = true;
            });
            break;

          case 'weak_password':
            // Se o erro for de senha fraca:
            setState(() {
              _isSenhaFraca = true;
            });
            break;

          default:
            // Para outros erros:
            setState(() {
              _isEmailUso = false;
              _isSenhaFraca = false;
            });
        }
      }
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    // Método chamado ao destruir a tela para liberar os controladores.

    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _csenhaController.dispose();
    super.dispose();
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
                        "Cadastro de novo Usuário",
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
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        filled: true,
                        fillColor: Colors.lightGreen[100],
                        border: const OutlineInputBorder(),
                        errorText: _isEmailUso ? 'Email já está em uso' : null,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Este campo é obrigatório';
                        if (!value.contains('@') || !value.contains(".")) return 'E-mail inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _senhaController,
                      keyboardType: TextInputType.text,
                      obscureText: !_mostrarSenha,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _mostrarSenha = !_mostrarSenha;
                            });
                          },
                          icon: Icon(
                            _mostrarSenha ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.lightGreen[100],
                        border: const OutlineInputBorder(),
                        errorText: _isSenhaFraca ? 'Senha fraca' : null,
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Este campo é obrigatório' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _csenhaController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirmar Senha',
                        filled: true,
                        fillColor: Colors.lightGreen[100],
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Este campo é obrigatório';
                        if (value != _senhaController.text) return 'As senhas não são iguais';
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(foregroundColor: Colors.lightGreen[900]),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Fazer login", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        ElevatedButton(
                          onPressed: () => _salvarUsuario(),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen[700]),
                          child: Text("Criar conta", style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_loading)
            Container(
              height: double.infinity,
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.limeAccent[400],
                  strokeWidth: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
