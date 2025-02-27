import 'dart:io';

import 'package:minha_agenda_supabase/model/contato.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContatoRepository { 
  final SupabaseClient supabase = Supabase.instance.client;
  final String tabela = 'contato';
  final String bucket = 'fotos';

  String gerarNome(){
    final agora = DateTime.now();
    return agora.microsecondsSinceEpoch.toString();
    
  }

  Future<Contato> cadastroContato(Contato contato) async{
  
    final response = await supabase.from(tabela).insert(contato.toSupabase()).select();
   
    return Contato.fromMap(response[0]);
  }

  Future<String> enviarFoto(File imagem, String uid) async{
    final String nome = '${gerarNome()}.jpg';
    final String caminhoFoto = await supabase.storage.from(bucket).upload('/$uid/$nome', imagem);  
    return supabase.storage.from(bucket).getPublicUrl('$uid/$nome');

  }

  Future<void> atualizarFoto(Contato contato) async{
    await supabase.from(tabela).update({
      'foto': contato.foto!,
    }).eq('id', contato.id!);
  }
}