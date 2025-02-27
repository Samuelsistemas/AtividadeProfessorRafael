import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minha_agenda_supabase/model/despesa.dart';
import 'package:minha_agenda_supabase/repository/despesa_repository.dart';

class TransactionList extends StatefulWidget {
  final List<Despesa> despesas;

  const TransactionList(this.despesas, {super.key});

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final DespesaRepository _despesaRepository = DespesaRepository();

  Future<void> _deleteDespesa(int id) async {
    await _despesaRepository.deleteDespesa(id);
    setState(() {
      widget.despesas.removeWhere((despesa) => despesa.id == id);
    });
  }

  void _mostrarComprovante(String url) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(url),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Fechar"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget.despesas.isEmpty
          ? const Center(child: Text("Nenhuma despesa cadastrada!"))
          : ListView.builder(
              itemCount: widget.despesas.length,
              itemBuilder: (ctx, index) {
                final despesa = widget.despesas[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text('R\$${despesa.amount.toStringAsFixed(2)}'),
                        ),
                      ),
                    ),
                    title: Text(
                      despesa.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data: ${DateFormat.yMd().format(despesa.date)}\nCategoria: ${despesa.category}',
                        ),
                        if (despesa.comprovante != null)
                          Column(
                            children: [
                              const SizedBox(height: 5),
                              GestureDetector(
                                onTap: () => _mostrarComprovante(despesa.comprovante!),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    despesa.comprovante!,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteDespesa(despesa.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
