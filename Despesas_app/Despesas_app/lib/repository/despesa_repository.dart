import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:minha_agenda_supabase/model/despesa.dart';

class DespesaRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  final String tabela = 'despesas';
  final String bucket = 'comprovantes'; // 📌 Nome do bucket no Supabase Storage

  Future<void> addDespesa(Despesa despesa) async {
    await supabase.from(tabela).insert(despesa.toMap());
  }

  Future<List<Despesa>> getDespesas(String usuarioId) async {
    final response = await supabase
        .from(tabela)
        .select()
        .eq('usuario', usuarioId);

    return response.map<Despesa>((map) => Despesa.fromMap(map)).toList();
  }

  Future<String> enviarComprovante(File imagem, String uid) async {
  final String nomeArquivo = '${DateTime.now().millisecondsSinceEpoch}.jpg';
  final String caminho = '/$uid/$nomeArquivo';

  final supabase = Supabase.instance.client;
  
  await supabase.storage.from('comprovantes').upload(caminho, imagem);

  return supabase.storage.from('comprovantes').getPublicUrl(caminho);
}


  Future<void> atualizarComprovante(Despesa despesa) async {
    await supabase.from(tabela).update({
      'comprovante': despesa.comprovante!,
    }).eq('id', despesa.id);
  }

  Future<void> deleteDespesa(int id) async {
    // Busca a despesa antes de excluir, para remover a imagem do Supabase Storage se houver.
    final response = await supabase
        .from(tabela)
        .select('comprovante')
        .eq('id', id)
        .maybeSingle();

    if (response != null && response['comprovante'] != null) {
      final String url = response['comprovante'];
      final String filePath = url.split('/').last; // Obtém o nome do arquivo
      await supabase.storage.from(bucket).remove(['/comprovantes/$filePath']);
    }

    // Exclui a despesa do banco de dados
    await supabase.from(tabela).delete().eq('id', id);
  }
}
