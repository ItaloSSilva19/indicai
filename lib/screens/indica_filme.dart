import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:indikai/models/filme.dart';

Future<void> filmeSetup(String nome) async {
  final CollectionReference filmes =
      FirebaseFirestore.instance.collection("filmes");
  filmes.add({'nome': nome});
  return;
}

class TelaIndicaFilme extends StatelessWidget {
  TelaIndicaFilme({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _filme = Filme.vazio();

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
        body: Column(children: [
          _buildForm(context),
        ]),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              FirebaseFirestore.instance
                  .runTransaction((Transaction transaction) async {
                CollectionReference reference =
                    FirebaseFirestore.instance.collection('filmes');

                await reference.add({
                  "nome": _filme.nome,
                  "anoLancamento": _filme.anoLancamento,
                  "score": _filme.score,
                  "categoria": _filme.categoria
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
              decoration: const InputDecoration(labelText: 'Nome'),
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
              decoration: const InputDecoration(labelText: 'Categoria'),
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
              decoration: const InputDecoration(labelText: 'Ano de lançamento'),
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
              decoration: const InputDecoration(labelText: 'Pontuação'),
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
