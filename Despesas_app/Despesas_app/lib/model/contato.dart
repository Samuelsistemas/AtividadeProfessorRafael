class Contato {
  int? id;
  // Identificador único do contato (pode ser nulo, pois pode ser definido no banco de dados).

  String? nome;
  // Nome do contato.

  String? telefone;
  // Número de telefone do contato.

  DateTime? dataNascimento;
  // Data de nascimento do contato.

  String? usuario;
  // Identificação do usuário dono do contato.

  String? foto;
  // URL ou caminho da foto do contato.

  Contato(
    this.usuario,
    this.nome,
    this.telefone,
    this.dataNascimento
  );
  // Construtor padrão para criar um contato, sem foto.

  Contato.foto(
    this.usuario,
    this.nome,
    this.telefone,
    this.dataNascimento,
    this.foto
  );
  // Construtor alternativo que permite definir uma foto para o contato.

  Map<String, dynamic> toSupabase() {
    // Método para converter um objeto Contato em um formato adequado para o Supabase.

    return {
      'nome': nome,
      'telefone': telefone,
      'dataNascimento': dataNascimento.toString(),
      // Converte a data para uma string antes de enviar para o banco de dados.

      if (foto != null) 'foto': foto else 'foto': null,
      // Se houver uma foto, inclui no mapa; caso contrário, define como `null`.
    };
  }

  Contato.fromMap(Map map) {
    // Construtor que cria um objeto Contato a partir de um mapa (usado para recuperar dados do banco).

    id = map['id'];
    // Define o ID do contato.

    usuario = map['usuario'];
    // Define o usuário dono do contato.

    nome = map['nome'];
    // Define o nome do contato.

    telefone = map['telefone'];
    // Define o telefone do contato.

    dataNascimento = DateTime.parse(map['dataNascimento']);
    // Converte a string da data de nascimento para um objeto DateTime.

    foto = map['foto'];
    // Define a foto do contato.
  }
}
