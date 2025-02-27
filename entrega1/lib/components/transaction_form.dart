import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(
    String title,
    double value,
    DateTime date,
    bool isEssential,
    double priority,
    String transactionType,
    String category,
  ) onSubmit;

  const TransactionForm(this.onSubmit, {Key? key}) : super(key: key);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final titleController = TextEditingController();
  final valueController = TextEditingController();
  DateTime? selectedDate;
  bool isEssential = false;
  double priority = 1.0;
  String transactionType = 'Despesa';
  String selectedCategory = 'Alimentação';

  void _submitData() {
    if (titleController.text.isEmpty || valueController.text.isEmpty || selectedDate == null) {
      return;
    }

    widget.onSubmit(
      titleController.text,
      double.parse(valueController.text),
      selectedDate!,
      isEssential,
      priority,
      transactionType,
      selectedCategory,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(labelText: 'Título'),
              controller: titleController,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Valor'),
              controller: valueController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _submitData(),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    selectedDate == null
                        ? 'Nenhuma data selecionada!'
                        : 'Data Selecionada: ${DateFormat.yMd().format(selectedDate!)}',
                  ),
                ),
                TextButton(
                  onPressed: _presentDatePicker,
                  child: const Text(
                    'Selecionar Data',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                const Text('É essencial?'),
                Checkbox(
                  value: isEssential,
                  onChanged: (val) {
                    setState(() {
                      isEssential = val!;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                const Text('Prioridade'),
                Slider(
                  value: priority,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: priority.round().toString(),
                  onChanged: (val) {
                    setState(() {
                      priority = val;
                    });
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                const Text('Tipo'),
                Radio(
                  value: 'Despesa',
                  groupValue: transactionType,
                  onChanged: (val) {
                    setState(() {
                      transactionType = val.toString();
                    });
                  },
                ),
                const Text('Despesa'),
                Radio(
                  value: 'Receita',
                  groupValue: transactionType,
                  onChanged: (val) {
                    setState(() {
                      transactionType = val.toString();
                    });
                  },
                ),
                const Text('Receita'),
              ],
            ),
            DropdownButton<String>(
              value: selectedCategory,
              items: <String>['Alimentação', 'Transporte', 'Lazer', 'Outros']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedCategory = val!;
                });
              },
            ),
            ElevatedButton(
              onPressed: _submitData,
              child: const Text('Adicionar Transação'),
            ),
          ],
        ),
      ),
    );
  }
}