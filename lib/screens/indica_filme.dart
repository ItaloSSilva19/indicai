import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:indikai/models/filme.dart';
import 'package:indikai/storage_service.dart';

class TelaIndicaFilme extends StatefulWidget {
  const TelaIndicaFilme({Key? key}) : super(key: key);

  @override
  State<TelaIndicaFilme> createState() => _TelaIndicaFilmeState();
}

class _TelaIndicaFilmeState extends State<TelaIndicaFilme> {
  final _formKey = GlobalKey<FormState>();
  final _filme = Filme.vazio();
  final _user = FirebaseAuth.instance.currentUser as User;
  final Storage storage = Storage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          title: Text('Cadastraí',
              style: GoogleFonts.rubikWetPaint(
                  textStyle: const TextStyle(fontSize: 36.0))),
          actions: [
            InkWell(
                child: Padding(
                  padding: EdgeInsets.all(1),
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage('${_user.photoURL}'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/perfil');
                })
          ],
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          _buildForm(context),
          ElevatedButton(
              onPressed: () async {
                final results = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.custom,
                  allowedExtensions: ['png', 'jpg', 'jpeg'],
                );
                if (results == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nenhuma Imagem Selecionada.'),
                    ),
                  );
                  return;
                }
                final path = results.files.single.path!;
                final fileName = results.files.single.name;

                storage
                    .uploadFile(path, fileName)
                    .then((value) => print('Done'));
                print(path);
                print(fileName);
                _filme.imagem = fileName;
              },
              child: Text('Adicionar Imagem')),
        ])),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.check),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              FirebaseFirestore.instance
                  .runTransaction((Transaction transaction) async {
                CollectionReference reference = FirebaseFirestore.instance
                    .collection('usuarios/${_user.uid}/filmes');

                await reference.add({
                  "nome": _filme.nome,
                  "anoLancamento": _filme.anoLancamento,
                  "score": _filme.score,
                  "categoria": _filme.categoria,
                  "usuario": _user.displayName,
                  "imagem": _filme.imagem!,
                  "indicada": 1
                });
              });

              FirebaseFirestore.instance
                  .runTransaction((Transaction transaction) async {
                CollectionReference referenceFilmes =
                    FirebaseFirestore.instance.collection('filmes');

                await referenceFilmes.add({
                  "nome": _filme.nome,
                  "anoLancamento": _filme.anoLancamento,
                  "score": _filme.score,
                  "categoria": _filme.categoria,
                  "usuario": _user.displayName,
                  "imagem": _filme.imagem!,
                  "indicada": 1
                });
                Navigator.of(context).pop();
              });
            } else {
              Text('deu ruim');
            }
          },
        ));
  }

  Widget _buildForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: Colors.white54)),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Informe o nome do Filme';
                }
                return null;
              },
              onSaved: (value) {
                _filme.nome = value!;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: 'Categoria',
                  labelStyle: TextStyle(color: Colors.white54)),
              validator: (value) {
                if (value!.isEmpty &&
                    !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                  return 'Informe uma categoria válida';
                }
                return null;
              },
              onSaved: (value) {
                _filme.categoria = value!;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: 'Ano de lançamento',
                  labelStyle: TextStyle(color: Colors.white54)),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'19[00-99]|20[00-99]').hasMatch(value)) {
                  return 'Informe um ano válido: 1900 à 2099';
                }
                return null;
              },
              onSaved: (value) {
                _filme.anoLancamento = value!;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: 'Pontuação',
                  labelStyle: TextStyle(color: Colors.white54)),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'^[0-9]?$|^10$').hasMatch(value)) {
                  return 'Informe uma indicação válida: 0 até 10';
                }
                return null;
              },
              onSaved: (value) {
                _filme.score = value!;
              },
            ),
          ],
        ));
  }
}
