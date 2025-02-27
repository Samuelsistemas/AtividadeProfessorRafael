import 'package:flutter/material.dart';
// Importa o pacote Flutter para construção da interface.

import 'package:minha_agenda_supabase/repository/usuario_repository.dart';
// Importa a classe `UsuarioRepository`, responsável por autenticação no Supabase.

import 'package:supabase_flutter/supabase_flutter.dart';
// Importa a biblioteca do Supabase para comunicação com o banco de dados.

class Login extends StatefulWidget {
  // Declaração da tela de login como um `StatefulWidget`.

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Classe responsável pelo estado da tela de login.

  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  // Controladores para capturar o texto digitado nos campos de login e senha.

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Chave global para validar o formulário.

  bool _mostrarSenha = false;
  // Indica se a senha deve ser exibida ou ocultada.

  bool _loading = false;
  // Indica se o processo de login está em andamento.

  @override
  void dispose() {
    // Método chamado ao destruir a tela para liberar os controladores.

    _loginController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _mostrarAlerta(BuildContext context, String texto) {
    // Método para exibir um alerta quando houver erro no login.

    return showDialog(
        context: context,
        barrierDismissible: false,
        // O usuário não pode fechar o alerta tocando fora da caixa de diálogo.

        builder: (_) {
          return AlertDialog(
            title: const Text('Erro no acesso'),
            content: Row(
              children: [
                const Icon(
                  Icons.warning,
                  color: Colors.red,
                  size: 50,
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 200,
                  child: Text(
                    texto,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Fecha o alerta.
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  Future<void> _loginUsuario() async {
    // Método para autenticar o usuário no Supabase.

    setState(() {
      _loading = true;
    });

    final bool isValid = _formKey.currentState?.validate() ?? false;
    // Valida os campos do formulário.

    final navigator = Navigator.of(context);

    if (isValid) {
      try {
        final AuthResponse usuarioAutenticado = await UsuarioRepository().loginUsuario(
          _loginController.text,
          _senhaController.text,
        );
        // Chama o método para autenticar o usuário no Supabase.

        if (usuarioAutenticado.session != null) {
          navigator.pushReplacementNamed("/");
          // Se a autenticação for bem-sucedida, redireciona para a tela inicial.
        }

      } on AuthApiException catch (e) {
        // Captura erros de autenticação.

        if (e.code == 'invalid_credentials') {
          // Se as credenciais forem inválidas, exibe um alerta.
          _mostrarAlerta(context, 'Usuário ou senha incorreta');
        }
      }
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
      // Define a cor de fundo da tela.

      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 150,
                    ),
                    const SizedBox(height: 60),
                    TextFormField(
                      controller: _loginController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Login',
                        prefixIcon: Icon(Icons.person_outline),
                        prefixIconColor: Colors.lightGreen[700],
                        filled: true,
                        fillColor: Colors.lightGreen[100],
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo é obrigatório';
                        }
                        if (!value.contains('@') || !value.contains(".")) {
                          return 'E-mail é inválido';
                        }
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
                        prefixIcon: Icon(Icons.lock_outline),
                        prefixIconColor: Colors.lightGreen[700],
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
                        suffixIconColor: Colors.lightGreen[700],
                        filled: true,
                        fillColor: Colors.lightGreen[100],
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo é obrigatório';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.lightGreen[900],
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              "/login/cadastro",
                            );
                            // Se o usuário não tem conta, navega para a tela de cadastro.
                          },
                          child: Text(
                            "Criar uma nova conta",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _loginUsuario(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen[700],
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            "Entrar",
                            style: TextStyle(fontSize: 18),
                          ),
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
