import 'package:flutter/material.dart';
import 'package:minha_agenda_supabase/telas/cadastro_contato.dart';
import 'package:minha_agenda_supabase/telas/cadastro_usuario.dart';
import 'package:minha_agenda_supabase/telas/home.dart';
import 'package:minha_agenda_supabase/telas/login.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => const Home(),
        );
      case "/login":
        return MaterialPageRoute(
          builder: (_) => const Login(),
        );
      case "/login/cadastro":
        return MaterialPageRoute(
          builder: (_) => const CadastroUsuario(),
        );
      case "/contato/cadastro":
        return MaterialPageRoute(
          builder: (_) => const CadastroContato(),
        );
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            backgroundColor: Colors.lightGreen[200],
            body: Center(
              child: Text(
                "Tela não encontrada",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreen[900],
                ),
              ),
            ),
          );
        });
    }
  }
}
