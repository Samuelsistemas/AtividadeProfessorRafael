import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minha_agenda_supabase/componentes/chart.dart';
import 'package:minha_agenda_supabase/componentes/transaction_form.dart';
import 'package:minha_agenda_supabase/componentes/transaction_list.dart';
import 'package:minha_agenda_supabase/model/despesa.dart';
import 'package:minha_agenda_supabase/repository/despesa_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class DespesasPage extends StatefulWidget {
  const DespesasPage({Key? key}) : super(key: key);

  @override
  _DespesasPageState createState() => _DespesasPageState();
}

class _DespesasPageState extends State<DespesasPage> {
  bool _isDarkTheme = false;
  List<Despesa> _userDespesas = [];
  final DespesaRepository _despesaRepository = DespesaRepository();

  @override
  void initState() {
    super.initState();
    _carregarDespesas();
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkTheme = isDark;
    });
  }

  Future<void> _logout() async {
    final supabase = Supabase.instance.client;
    await supabase.auth.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  Future<void> _carregarDespesas() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user != null) {
      final despesas = await _despesaRepository.getDespesas(user.id);
      setState(() {
        _userDespesas = despesas;
      });
    } else {
      print("Usuário não autenticado!");
    }
  }

  Future<void> _addDespesa(
    String title,
    double amount,
    DateTime date,
    bool isEssential,
    double priority,
    String transactionType,
    String category,
    File? comprovante, 
  ) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user != null) {
      String? urlComprovante;
      
      if (comprovante != null) {
        urlComprovante = await _despesaRepository.enviarComprovante(comprovante, user.id);
      }

      final newDespesa = Despesa(
        id: Random().nextInt(1000000),
        title: title,
        amount: amount,
        date: date,
        isEssential: isEssential,
        priority: priority,
        transactionType: transactionType,
        category: category,
        usuario: user.id,
        comprovante: urlComprovante, 
      );

      await _despesaRepository.addDespesa(newDespesa);
      _carregarDespesas();
    } else {
      print("Erro: Usuário não autenticado!");
    }
  }

  void _startAddNewDespesa(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return TransactionForm(_addDespesa);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Controle de Despesas'),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: _logout,
            ),
            Switch(
              value: _isDarkTheme,
              onChanged: _toggleTheme,
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.show_chart), text: 'Resumo'),
              Tab(icon: Icon(Icons.list), text: 'Despesas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Chart(_userDespesas),
                Expanded(child: TransactionList(_userDespesas)),
              ],
            ),
            Expanded(child: TransactionList(_userDespesas)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _startAddNewDespesa(context),
        ),
      ),
    );
  }
}
