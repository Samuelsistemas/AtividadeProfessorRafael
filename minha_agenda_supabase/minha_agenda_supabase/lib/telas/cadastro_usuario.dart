import 'package:flutter/material.dart';
import 'package:minha_agenda_supabase/model/usuario.dart';
import 'package:minha_agenda_supabase/repository/usuario_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({super.key});

  @override
  State<CadastroUsuario> createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _csenhaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _mostrarSenha = false;
  bool _isEmailUso = false;
  bool _isSenhaFraca = false;
  bool _loading = false;

  Future<void> _salvarUsuario() async{
    setState(() {
      _loading = true;

    });

    final bool isValid = _formKey.currentState?.validate() ?? false;
    final navigator = Navigator.of(context);
    if (isValid){
      try {
        final AuthResponse usuarioAutenticado = await UsuarioRepository().criarUsuario(
          Usuario(
            _nomeController.text,
            _emailController.text,
            _senhaController.text,
          ),
        );
    if (usuarioAutenticado.session != null){
      navigator.pushReplacementNamed("/");
    }

      } on AuthApiException catch (e) {
        switch (e.code) {
          case 'user_already_existis':
            setState(() {
              _isEmailUso = true;
            });
            break;
          case 'weak_password':
            setState(() {
              _isSenhaFraca = true;
            });
            break;
          default:
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
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _csenhaController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[200],
      body: Stack(children: [
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
                const SizedBox(
                  height: 60,
                ),
                TextFormField(
                  controller: _nomeController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Nome',
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
                  height: 20,
                ),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
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
                    errorText: _isEmailUso ? 'Email já está em uso': null,
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
                    errorText: _isSenhaFraca ? 'Senha fraca' : null,
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
                  height: 20,
                ),
                TextFormField(
                  controller: _csenhaController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
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
                    if (value != _senhaController.text) {
                      return 'As senhas não são iguais';
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
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Fazer login",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _salvarUsuario(), 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen[700],
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        "Criar conta",
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
