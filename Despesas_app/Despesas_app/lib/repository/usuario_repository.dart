import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:minha_agenda_supabase/model/usuario.dart';
class UsuarioRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<AuthResponse> criarUsuario(Usuario usuario) async {
    final response = await supabase.auth.signUp(
      email: usuario.email!,
      password: usuario.senha!,
      data: {'display_name': usuario.nome},
    );

    // Após criar a conta, garantir que o usuário existe na tabela 'contato'
    if (response.user != null) {
      await verificarOuCriarUsuario(response.user!.id);
    }

    return response;
  }

  Future<AuthResponse> loginUsuario(String email, String senha) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: senha,
    );

    // Após login, garantir que o usuário existe na tabela 'contato'
    if (response.user != null) {
      await verificarOuCriarUsuario(response.user!.id);
    }

    return response;
  }

  Future<void> verificarOuCriarUsuario(String userId) async {
    final response = await supabase
        .from('contato')
        .select()
        .eq('usuario', userId)
        .maybeSingle(); // Retorna `null` se não encontrar

    if (response == null) {
      // Se o usuário ainda não existe na tabela `contato`, insere um novo registro
      await supabase.from('contato').insert({
        'usuario': userId,
        'telefone': '000000000', // Pode ser atualizado depois pelo usuário
        'dataNascimento': '2000-01-01', // Pode ser atualizado depois
        'foto': '', // Pode ser atualizado depois
      });
    }
  }

  bool isLogado() {
    return supabase.auth.currentSession != null;
  }

  Usuario usuarioLogado() {
    final sessao = supabase.auth.currentSession;
    return Usuario.supabase(
      sessao!.user.id,
      sessao.user.userMetadata?['display_name'],
      sessao.user.email,
      sessao,
      sessao.user,
    );
  }
}
