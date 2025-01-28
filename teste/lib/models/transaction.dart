
class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isEssential;
  final double priority;
  final String transactionType;
  final String category;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.isEssential,
    required this.priority,
    required this.transactionType,
    required this.category,
  });
}