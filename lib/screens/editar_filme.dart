import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:indikai/models/filme.dart';

class TelaEditarFilme extends StatefulWidget {
  const TelaEditarFilme({Key? key}) : super(key: key);

  @override
  State<TelaEditarFilme> createState() => _TelaEditarFilme();
}

class _TelaEditarFilme extends State<TelaEditarFilme> {
  late Filme _filme;
  late DocumentReference _filmeRef;
  final _formKey = GlobalKey<FormState>();

  Widget _buildForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              initialValue: _filme.nome,
              decoration: const InputDecoration(
                labelText: 'Nome',
                helperText: 'Informe o nome do filme',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o nome do filme';
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
              initialValue: _filme.categoria,
              decoration: const InputDecoration(
                labelText: 'Categoria',
                helperText: 'Informe a categoria',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe a categoria do filme';
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
              initialValue: _filme.anoLancamento,
              decoration: const InputDecoration(
                labelText: 'Ano de lançamento',
                helperText: 'Informe o ano de lançamento',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o ano de lançamento do filme';
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
              initialValue: _filme.score,
              decoration: const InputDecoration(
                labelText: 'Nota',
                helperText: 'Informe a nota do filme',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe a nota do filme';
                }
                return null;
              },
              onSaved: (value) {
                _filme.score = value!;
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ));
  }

  void _showDialogErrors() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Informações do filme'),
            content: const Text(
                'Há erros nos campos. Corrija-os e tente novamente.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Fechar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _filme = ModalRoute.of(context)!.settings.arguments as Filme;

    _filmeRef = FirebaseFirestore.instance.doc('filmes/${_filme.id}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar filme'),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: const Text('Atualize os dados do filme'),
              ),
              const SizedBox(
                height: 10,
              ),
              _buildForm(context)
            ],
          )),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.check),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              await _filmeRef.update(_filme.toDocument());
              if (!mounted) return;
              Navigator.of(context).pushNamed('/homepage');
            } else {
              _showDialogErrors();
            }
          }),
    );
  }
}
