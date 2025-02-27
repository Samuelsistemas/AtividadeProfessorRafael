import 'package:flutter/material.dart';
// Importa o pacote Flutter Material, necessário para criar a interface do usuário.

import 'package:flutter_localizations/flutter_localizations.dart';
// Importa o suporte para internacionalização, permitindo traduzir elementos da UI para outros idiomas.

import 'package:minha_agenda_supabase/repository/usuario_repository.dart';
// Importa o repositório responsável pelo gerenciamento do usuário, incluindo login e autenticação.

import 'package:supabase_flutter/supabase_flutter.dart';
// Importa o pacote Supabase para comunicação com o banco de dados e autenticação.

import 'package:minha_agenda_supabase/route_generator.dart';
// Importa o gerador de rotas, que será responsável por definir as telas do aplicativo.

Future<void> main() async {
  // Função principal do aplicativo, que será executada ao iniciar.
  
  WidgetsFlutterBinding.ensureInitialized();
  // Garante que o Flutter está inicializado antes de rodar qualquer código assíncrono.

  await Supabase.initialize(
    // Inicializa o Supabase, que será usado como backend para autenticação e banco de dados.

    url: 'https://srlhhcvbeuhgloexwwmy.supabase.co',
    // URL do projeto no Supabase.

    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNybGhoY3ZiZXVoZ2xvZXh3d215Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkyMzE0NjAsImV4cCI6MjA1NDgwNzQ2MH0.A2aOMNeJ5ChFZcdccCKED913uq2dPb7xmprxBvvYCPI',
    // Chave anônima usada para acessar o Supabase. Essa chave deve ser protegida em produção.
  );

  runApp(MaterialApp(
    // Inicia o aplicativo com um `MaterialApp`, que é a base do app Flutter.

    localizationsDelegates: [
      GlobalCupertinoLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    // Define os delegados responsáveis por carregar as traduções padrão do Flutter.

    supportedLocales: [
      Locale('pt', 'BR'),
    ],
    // Especifica que o aplicativo oferecerá suporte ao idioma português do Brasil.

    theme: ThemeData(useMaterial3: true),
    // Define o tema do aplicativo usando Material Design 3.

    onGenerateRoute: RouteGenerator.generateRoute,
    // Define a função responsável por gerar as rotas do aplicativo.

    initialRoute: UsuarioRepository().isLogado() ? "/" : "/login",
    // Define a tela inicial com base no status de login do usuário:
    // Se o usuário estiver logado, a tela inicial será "/".
    // Caso contrário, ele será direcionado para a tela de login "/login".

    debugShowCheckedModeBanner: false,
    // Remove a faixa de "debug" no canto superior direito do aplicativo em modo de depuração.
  ));
}
