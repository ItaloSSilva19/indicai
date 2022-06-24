import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:indikai/models/filme.dart';
import 'package:indikai/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
          title: Text('Índicaí',
              style: GoogleFonts.rubikWetPaint(
                  textStyle: const TextStyle(
                fontSize: 36.0,
              ))),
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
                      content: Text('No file selected.'),
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
              },
              child: Text('Upload File')),
          FutureBuilder(
              future: storage.listFiles(),
              builder: (BuildContext context,
                  AsyncSnapshot<firebase_storage.ListResult> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ElevatedButton(
                          onPressed: () {},
                          child: Text(snapshot.data!.items[index].name),
                        );
                      },
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return Container();
              }),
          FutureBuilder(
              future: storage.downloadURL('batman.jpg'),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Container(
                      width: 200,
                      height: 150,
                      child: Image.network(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      ));
                }
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return Container();
              })
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
                });
                Navigator.of(context).pushNamed("/homepage");
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
                if (value == null || value.isEmpty) {
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
                if (value == null || value.isEmpty) {
                  return 'Informe a categoria do Filme';
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
                if (value == null || value.isEmpty) {
                  return 'Informe o ano de lançamento do Filme';
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
                if (value == null || value.isEmpty) {
                  return 'Qual a sua indicação do Filme';
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
