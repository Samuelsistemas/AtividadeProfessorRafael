import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:minha_agenda_supabase/model/contato.dart';
import 'package:minha_agenda_supabase/model/usuario.dart';
import 'package:minha_agenda_supabase/repository/contato_repository.dart';
import 'package:minha_agenda_supabase/repository/usuario_repository.dart';

class CadastroContato extends StatefulWidget {
  const CadastroContato({super.key});

  @override
  State<CadastroContato> createState() => _CadastroContatoState();
}

class _CadastroContatoState extends State<CadastroContato> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _nascimentoController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final bool _mostrarSenha = false;
  bool _loading = false;
  bool? _foto;
  XFile? _imagem;

  Future<void> _capturarFoto({bool camera = true}) async{
    setState(() {
      _loading = true;
    });
    XFile? temp;
    final ImagePicker picker = ImagePicker(); 
    if (camera) {
      temp = await picker.pickImage(source: ImageSource.camera);
      
    } else {
            temp = await picker.pickImage(source: ImageSource.gallery);

    }
    if (temp!= null ) {
      setState(() {
        _foto = true;
        _imagem = temp;
        _loading = false;
      });
      
    } else {
      
    }

    }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _nascimentoController.dispose();

    super.dispose();
  }

  Future<void> _abrirCalendario(BuildContext context) async {
    final DateTime? data = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      currentDate: DateTime.now(),
    );

    if (data != null) {
      setState(() {
        _nascimentoController.text = DateFormat("dd/MM/yyyy").format(data).toString();
      });
    }
  }

  bool _validarFoto(){
    return _imagem != null ? true : false;
  }
  Future<void> _salvarContato() async{
    setState(() {
      _loading = true;
    });
  final bool isValid = _formKey.currentState?.validate() ?? false;
  final navigator = Navigator.of(context);

  setState(() {
    _foto = _validarFoto();

  });

  if (isValid && _foto!) {
    Usuario usuarioLogado = UsuarioRepository().usuarioLogado();
    final novoContato = await ContatoRepository().cadastroContato(
      Contato(
        usuarioLogado.id,
         _nomeController.text,
          _telefoneController.text,

           DateFormat('dd/MM/yyyy').parse(_nascimentoController.text),
           ),
           );

           novoContato.foto = await ContatoRepository().enviarFoto(
            File(_imagem!.path),
             novoContato.usuario!
             );

             ContatoRepository().atualizarFoto(novoContato);
             navigator.pop();
}

    setState(() {
      _loading = false;
    });
 
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[200],
      body: Stack(children: [Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Center(
                  child: Text(
                    "Cadastro de novo Contato",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.lightGreen[900],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                TextFormField(
                  controller: _nomeController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    filled: true,
                    fillColor: Colors.lightGreen[100],
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    floatingLabelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.lightGreen[900],
                      fontWeight: FontWeight.w700,
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.lightGreen,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.lightGreen[900],
                    fontSize: 18,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo é obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _telefoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Telefone',
                    filled: true,
                    fillColor: Colors.lightGreen[100],
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    floatingLabelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.lightGreen[900],
                      fontWeight: FontWeight.w700,
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.lightGreen,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.lightGreen[900],
                    fontSize: 18,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo é obrigatório';
                    }
                  
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _nascimentoController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: 'Data de Nascimento',
                    suffixIcon: IconButton(
                      onPressed: () => _abrirCalendario(context),
                      icon: Icon(Icons.calendar_month_outlined),
                    ),
                    suffixIconColor: Colors.lightGreen[700],
                    filled: true,
                    fillColor: Colors.lightGreen[100],
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    floatingLabelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.lightGreen[900],
                      fontWeight: FontWeight.w700,
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.lightGreen,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.lightGreen[900],
                    fontSize: 18,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo é obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                _imagem != null ?
                Image.file(
                  File(_imagem!.path),
                   fit: BoxFit.cover,
                   ) 
                   : Container(),

                const SizedBox( height: 20,
                ),
                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                      onPressed: (){
                        _capturarFoto(camera: true);

                      },
                      icon: Icon(Icons.camera_alt_outlined,
                      color: Colors.lightGreen[700],
                      ),
                       label: Text('Camera',
                        style: TextStyle(
                      fontSize: 16, 
                      color:  Colors.green[900],
                    ),
                    )),

                    TextButton.icon(
                      onPressed: (){
                          _capturarFoto(camera: false);
                      },
                      icon: Icon(Icons.photo_library_outlined,
                      color: Colors.lightGreen[700],
                      ),
                       label: Text('Galeria',
                        style: TextStyle(
                      fontSize: 16, 
                      color:  Colors.green[900],
                    ),
                    )),
                  ],

                ),

                const SizedBox(
                   height: 5,
                ),
                _foto != null && !_foto! ? Center(child: Text('Você deve selecionar/capturar uma foto', 
                style: TextStyle(
                  color: Colors.red,
                   fontSize: 12,
                    ),
                    ),
                    ) : Container(),

                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () => _salvarContato(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen[700],
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    "Criar contato",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
       if(_loading)
        Container(
          height: double.infinity,
          color: Colors.black.withOpacity(0.5),
          child: Center(child: CircularProgressIndicator(
            color: Colors.limeAccent[400],
            strokeWidth: 10,
          ),
          ),
        ),
      ],
      ),
    );
  }
}
