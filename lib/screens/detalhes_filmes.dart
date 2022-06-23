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

  @override
  Widget build(BuildContext context) {
    _filme = ModalRoute.of(context)!.settings.arguments as Filme;
    _filmeRef = FirebaseFirestore.instance.doc('/filmes/${_filme.id}');
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
        FloatingActionButton(onPressed: () {
          Navigator.of(context).pushNamed(
            '/editarfilme',
            arguments: _filme,
          );
        })
      ]),
    );
  }
}
