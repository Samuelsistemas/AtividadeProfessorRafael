import 'dart:io';
// Importa a biblioteca `dart:io`, necessária para manipular arquivos locais (como imagens).

import 'package:minha_agenda_supabase/model/contato.dart';
// Importa a classe `Contato`, que representa um contato no sistema.

import 'package:supabase_flutter/supabase_flutter.dart';
// Importa a biblioteca do Supabase para comunicação com o banco de dados e armazenamento.

class ContatoRepository {
  // Classe responsável por gerenciar os contatos no banco de dados Supabase.

  final SupabaseClient supabase = Supabase.instance.client;
  // Obtém a instância do cliente Supabase para interagir com o banco de dados e o armazenamento.

  final String tabela = 'contato';
  // Define o nome da tabela no banco de dados Supabase onde os contatos serão armazenados.

  final String bucket = 'fotos';
  // Define o nome do bucket no Supabase Storage onde as fotos dos contatos serão armazenadas.

  String gerarNome() {
    // Método para gerar um nome único baseado no tempo atual para evitar duplicação de arquivos.
    
    final agora = DateTime.now();
    // Obtém a data e hora atuais.

    return agora.microsecondsSinceEpoch.toString();
    // Retorna a quantidade de microssegundos desde 1970 (timestamp) como uma string única.
  }

  Future<Contato> cadastroContato(Contato contato) async {
    // Método para cadastrar um novo contato no banco de dados.

    final response = await supabase.from(tabela).insert(contato.toSupabase()).select();
    // Insere os dados do contato na tabela do Supabase e retorna o contato cadastrado.

    return Contato.fromMap(response[0]);
    // Converte o primeiro item da resposta em um objeto `Contato` e o retorna.
  }

  Future<String> enviarFoto(File imagem, String uid) async {
    // Método para enviar uma foto para o Supabase Storage e retornar a URL pública da imagem.

    final String nome = '${gerarNome()}.jpg';
    // Gera um nome único para a foto usando a função `gerarNome()` e adiciona a extensão ".jpg".

    final String caminhoFoto = await supabase.storage.from(bucket).upload('/$uid/$nome', imagem);
    // Faz o upload da imagem para o bucket `fotos`, armazenando-a dentro da pasta do usuário (`uid`).

    return supabase.storage.from(bucket).getPublicUrl('$uid/$nome');
    // Obtém e retorna a URL pública da imagem enviada.
  }

  Future<void> atualizarFoto(Contato contato) async {
    // Método para atualizar a foto de um contato no banco de dados.

    await supabase.from(tabela).update({
      'foto': contato.foto!,
    }).eq('id', contato.id!);
    // Atualiza o campo `foto` na tabela `contato`, garantindo que a atualização seja feita no contato correto pelo `id`.
  }
}
