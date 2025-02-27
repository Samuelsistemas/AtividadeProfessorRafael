import 'package:supabase_flutter/supabase_flutter.dart';

class Usuario {
  String? id;
  String? nome;
  String? email;
  String? senha;
  Session? sessao;
  User? userSupabase;

  Usuario(this.nome, this.email, this.senha); 

  Usuario.supabase(this.id, this.nome, this.email, this.sessao, this.userSupabase );
  

}