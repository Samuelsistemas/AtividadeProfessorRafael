import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final Function(
    String, double, DateTime, bool, double, String, String, File?) onSubmit;

  const TransactionForm(this.onSubmit, {super.key});

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  bool _isEssential = false;
  double _priority = 1.0;
  String _transactionType = "Despesa";
  String _category = "Outros";
  File? _comprovante; // ✅ Arquivo do comprovante de pagamento

  void _submitData() {
    final title = _titleController.text;
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    if (title.isEmpty || amount <= 0 || _selectedDate == null) {
      return;
    }

    widget.onSubmit(
      title,
      amount,
      _selectedDate!,
      _isEssential,
      _priority,
      _transactionType,
      _category,
      _comprovante, // ✅ Passando o comprovante junto da despesa
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
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  Future<void> _capturarComprovante({bool camera = true}) async {
    final ImagePicker picker = ImagePicker();
    XFile? temp = await picker.pickImage(source: camera ? ImageSource.camera : ImageSource.gallery);

    if (temp != null) {
      setState(() {
        _comprovante = File(temp.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Valor (R\$)'),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Nenhuma data selecionada!'
                          : 'Data: ${DateFormat.yMd().format(_selectedDate!)}',
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
              SwitchListTile(
                title: const Text('Essencial?'),
                value: _isEssential,
                onChanged: (val) {
                  setState(() {
                    _isEssential = val;
                  });
                },
              ),
              DropdownButton<double>(
                value: _priority,
                items: [1, 2, 3, 4, 5]
                    .map((e) => DropdownMenuItem(
                          value: e.toDouble(),
                          child: Text('Prioridade $e'),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _priority = val!;
                  });
                },
              ),
              DropdownButton<String>(
                value: _category,
                items: ["Alimentação", "Transporte", "Lazer", "Saúde", "Outros"]
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _category = val!;
                  });
                },
              ),
              const SizedBox(height: 10),
              _comprovante != null
                  ? Image.file(_comprovante!, height: 100, fit: BoxFit.cover)
                  : const Text("Nenhum comprovante selecionado"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () => _capturarComprovante(camera: true),
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo_library),
                    onPressed: () => _capturarComprovante(camera: false),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Adicionar Despesa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
