class Despesa {
  int id;
  String title;
  double amount;
  DateTime date;
  bool isEssential;
  double priority;
  String transactionType;
  String category;
  String usuario;
  String? comprovante; // ✅ Novo campo para armazenar a URL da foto do comprovante

  Despesa({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.isEssential,
    required this.priority,
    required this.transactionType,
    required this.category,
    required this.usuario,
    this.comprovante, // ✅ Agora o comprovante pode ser opcional
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'isEssential': isEssential,
      'priority': priority,
      'transactionType': transactionType,
      'category': category,
      'usuario': usuario,
      'comprovante': comprovante, // ✅ Adicionamos o comprovante no banco de dados
    };
  }

  factory Despesa.fromMap(Map<String, dynamic> map) {
    return Despesa(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      isEssential: map['isEssential'],
      priority: map['priority'],
      transactionType: map['transactionType'],
      category: map['category'],
      usuario: map['usuario'],
      comprovante: map['comprovante'], // ✅ Pega a URL do comprovante
    );
  }
}
