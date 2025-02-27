import 'package:minha_agenda_supabase/model/usuario.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsuarioRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<AuthResponse> criarUsuario(Usuario usuario) async{
    return await supabase.auth.signUp(
      email: usuario.email,
      password: usuario.senha!,
      data: {
        'display_name': usuario.nome,

      },
      );
      }
    Future<AuthResponse> loginUsuario(String email, String senha) async{
      return await supabase.auth.signInWithPassword(
        email:email, 
        password: senha,
        );
    }


      bool isLogado(){
        return supabase.auth.currentSession != null ? true: false;
      }
  Usuario usuarioLogado(){
    final sessao = supabase.auth.currentSession;
    return Usuario.supabase(
      sessao!.user.id,
       sessao.user.userMetadata?['display_name'],
        sessao.user.email,
         sessao, sessao.user,
         );
  }
}