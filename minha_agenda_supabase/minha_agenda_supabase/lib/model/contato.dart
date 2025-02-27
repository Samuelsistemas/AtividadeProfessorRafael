class Contato {
  int? id;
  String? nome;
  String? telefone;
  DateTime? dataNascimento;
  String? usuario;
  String? foto;

  Contato(
    this.usuario,
    this.nome,
    this.telefone,
    this.dataNascimento);


  Contato.foto(
    this.usuario,
    this.nome,
    this.telefone,
    this.dataNascimento,
    this.foto
    );

    Map<String, dynamic> toSupabase() {
      return{
        'nome': nome,
        'telefone': telefone,
        'dataNascimento': dataNascimento.toString(),
        if (foto != null)'foto': foto else 'foto': null,
        
      };
}
  Contato.fromMap(Map map){
    id = map['id'];
    usuario = map['usuario'];
    nome = map['nome'];
    telefone = map['telefone'];
    dataNascimento = DateTime.parse(map['dataNascimento']);
    usuario = map['usuario'];
    foto = map['foto'];

  }
}


