import 'package:flutter/material.dart';
import 'package:minha_agenda_supabase/telas/despesas_page.dart'; // Importa a nova tela de despesas
import 'package:minha_agenda_supabase/telas/cadastro_usuario.dart';
import 'package:minha_agenda_supabase/telas/login.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => const DespesasPage(), // Agora usa a tela de despesas!
        );
      case "/login":
        return MaterialPageRoute(
          builder: (_) => const Login(),
        );
      case "/login/cadastro":
        return MaterialPageRoute(
          builder: (_) => const CadastroUsuario(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
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
          ),
        );
    }
  }
}
