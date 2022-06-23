import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:indikai/models/filme.dart';

class TelaDetalhesFilme extends StatefulWidget {
  const TelaDetalhesFilme({Key? key}) : super(key: key);

  @override
  State<TelaDetalhesFilme> createState() => _TelaDetalhesFilmeState();
}

class _TelaDetalhesFilmeState extends State<TelaDetalhesFilme> {
  late Filme _filme;
  late DocumentReference _filmeRef;

  void _handleConfirmarExclusao() async {
    final excluir = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: const Text('Tem certeza que deseja excluir este veículo?'),
          actions: [
            TextButton(
              child: const Text("NÃO"),
              onPressed: () {
                return Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text("SIM"),
              onPressed: () {
                return Navigator.of(context).pop(true);
              },
            )
          ],
        );
      },
    );
    if (excluir) {
      await _filmeRef.delete();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/homepage');
    }
  }

  @override
  Widget build(BuildContext context) {
    _filme = ModalRoute.of(context)!.settings.arguments as Filme;
    _filmeRef = FirebaseFirestore.instance.doc('filmes/${_filme.id}');
    return Scaffold(
      appBar: AppBar(
          title: Text('Indicaí',
              style: GoogleFonts.rubikWetPaint(
                  textStyle: const TextStyle(fontSize: 36.0)))),
      body: Column(
        children: [
          ListTile(
            leading: CircleAvatar(child: Text(_filme.score!)),
            title: Text(_filme.nome!),
            subtitle: Text(_filme.categoria!),
          ),
        ],
      ),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
            heroTag: 'editar',
            child: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/editarfilme',
                arguments: _filme,
              );
            }),
        FloatingActionButton(
          heroTag: 'excluir',
          backgroundColor: Colors.red,
          child: Icon(Icons.delete),
          onPressed: _handleConfirmarExclusao,
        )
      ]),
    );
  }
}
