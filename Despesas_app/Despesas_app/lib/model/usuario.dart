import 'package:supabase_flutter/supabase_flutter.dart';
// Importa a biblioteca do Supabase, que será usada para autenticação e gerenciamento de usuários.

class Usuario {
  String? id;
  // Identificador único do usuário (pode ser `null` se o usuário ainda não foi registrado).

  String? nome;
  // Nome do usuário.

  String? email;
  // Endereço de e-mail do usuário.

  String? senha;
  // Senha do usuário (⚠️ Em um sistema real, a senha não deve ser armazenada diretamente na classe).

  Session? sessao;
  // Objeto `Session` do Supabase, que contém detalhes da sessão ativa do usuário.

  User? userSupabase;
  // Objeto `User` do Supabase, que representa o usuário autenticado.

  Usuario(this.nome, this.email, this.senha);
  // Construtor padrão para criar um novo usuário com nome, e-mail e senha.

  Usuario.supabase(this.id, this.nome, this.email, this.sessao, this.userSupabase);
  // Construtor alternativo para um usuário autenticado no Supabase, incluindo informações da sessão.
}
