// Importações necessárias
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class ProductApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Produtos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Database database;
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'products.db');

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE products (id INTEGER PRIMARY KEY, name TEXT, price REAL, inStock INTEGER)',
        );
      },
    );
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final data = await database.query('products');
    setState(() {
      products = data;
    });
  }

  Future<void> _addProduct(String name, double price, bool inStock) async {
    await database.insert('products', {
      'name': name,
      'price': price,
      'inStock': inStock ? 1 : 0,
    });
    _fetchProducts();
  }

  void _navigateToAddProductScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductScreen(onAddProduct: _addProduct)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            leading: Icon(product['inStock'] == 1 ? Icons.check_box : Icons.check_box_outline_blank),
            title: Text(product['name']),
            subtitle: Text('Preço: R\$${product['price']}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProductScreen,
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddProductScreen extends StatefulWidget {
  final Function(String, double, bool) onAddProduct;

  AddProductScreen({required this.onAddProduct});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  double _price = 0.0;
  bool _inStock = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome do Produto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do produto';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o preço';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Insira um valor válido';
                  }
                  return null;
                },
                onSaved: (value) {
                  _price = double.parse(value!);
                },
              ),
              SwitchListTile(
                title: Text('Em Estoque'),
                value: _inStock,
                onChanged: (value) {
                  setState(() {
                    _inStock = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onAddProduct(_name, _price, _inStock);
                    Navigator.pop(context);
                  }
                },
                child: Text('Adicionar Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}