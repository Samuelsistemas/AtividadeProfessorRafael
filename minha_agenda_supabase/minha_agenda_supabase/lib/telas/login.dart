import 'package:flutter/material.dart';
import 'package:minha_agenda_supabase/repository/usuario_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _mostrarSenha = false;
  bool _loading = false;

  @override
  void dispose() {
    _loginController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _mostrarAlerta(BuildContext context, String texto) {
    return showDialog(
        context: context,
        barrierDismissible: false,
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
                const SizedBox(
                  width: 10,
                ),

                SizedBox(width: 200,
                child:
                Text(
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
                },
                child: const Text('ok'),
              ),
            ],
          );
        });
  }
  Future<void> _loginUsuario() async{
    setState(() {
      _loading = true;
    });

    final bool isValid = _formKey.currentState?.validate() ?? false;
    final navigator = Navigator.of(context);
    if (isValid){
      try {
        final AuthResponse usuarioAutenticado = await UsuarioRepository().loginUsuario(
          _loginController.text, 
          _senhaController.text,
        );
    if (usuarioAutenticado.session != null){
      navigator.pushReplacementNamed("/");
    }

      } on AuthApiException catch (e) {
        if(e.code == 'invalid_credentials'){
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
    return Scaffold(
      backgroundColor: Colors.lightGreen[200],
      body: Stack(children: [ Center(
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
                const SizedBox(
                  height: 60,
                ),
                TextFormField(
                  controller: _loginController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Login',
                    prefixIcon: Icon(Icons.person_outline),
                    prefixIconColor: Colors.lightGreen[700],
                    filled: true,
                    fillColor: Colors.lightGreen[100],
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    floatingLabelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.lightGreen[900],
                      fontWeight: FontWeight.w700,
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.lightGreen,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.lightGreen[900],
                    fontSize: 18,
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
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _senhaController,
                  keyboardType: TextInputType.text,
                  obscureText: !_mostrarSenha,
                  enableSuggestions: false,
                  autocorrect: false,
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
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    floatingLabelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.lightGreen[900],
                      fontWeight: FontWeight.w700,
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.lightGreen,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.lightGreen[900],
                    fontSize: 18,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo é obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
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
                      },
                      child: Text(
                        "Criar uma nova conta",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: ()=> _loginUsuario(), 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen[700],
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      if(_loading)
        Container(
          height: double.infinity,
          color: Colors.black.withOpacity(0.5),
          child: Center(child: CircularProgressIndicator(
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
