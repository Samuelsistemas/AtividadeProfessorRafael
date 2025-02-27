


import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:minha_agenda_supabase/repository/usuario_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:minha_agenda_supabase/route_generator.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(

  url: 'https://srlhhcvbeuhgloexwwmy.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNybGhoY3ZiZXVoZ2xvZXh3d215Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkyMzE0NjAsImV4cCI6MjA1NDgwNzQ2MH0.A2aOMNeJ5ChFZcdccCKED913uq2dPb7xmprxBvvYCPI',
  );

  runApp(MaterialApp(
    localizationsDelegates: [
      GlobalCupertinoLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: [
      Locale('pt', 'BR'),
    ],
    theme: ThemeData(useMaterial3: true),
    onGenerateRoute: RouteGenerator.generateRoute,
    initialRoute: UsuarioRepository().isLogado() ? "/" : "/login",
    debugShowCheckedModeBanner: false,
  ));
}
