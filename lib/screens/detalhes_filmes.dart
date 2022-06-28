import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:indikai/storage_service.dart';
import 'package:like_button/like_button.dart';
import 'package:indikai/models/filme.dart';

class TelaDetalhesFilme extends StatefulWidget {
  const TelaDetalhesFilme({Key? key}) : super(key: key);

  @override
  State<TelaDetalhesFilme> createState() => _TelaDetalhesFilmeState();
}

class _TelaDetalhesFilmeState extends State<TelaDetalhesFilme> {
  late Filme _filme;
  late DocumentReference _filmeRef;

  final _user = FirebaseAuth.instance.currentUser as User;
  final Storage storage = Storage();
  void _handleConfirmarExclusao() async {
    final excluir = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: const Text('Tem certeza que deseja excluir esta indicação?'),
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
      Navigator.of(context).pop();
    }
  }

  _getImagem(filme) {
    return FutureBuilder(
        future: storage.downloadURL('${filme.imagem}'),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                      width: 400,
                      height: 420,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            snapshot.data!,
                            fit: BoxFit.fill,
                          ))),
                ),
              ],
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    _filme = ModalRoute.of(context)!.settings.arguments as Filme;
    _filmeRef = FirebaseFirestore.instance
        .doc('usuarios/${_user.uid}/filmes/${_filme.id}');

    FirebaseFirestore.instance.collection('usuarios').doc('filmes');
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        title: Text('Detalhaí',
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
      body: Column(
        children: [
          _getImagem(_filme),
          Text('${_filme.nome}',
              style: GoogleFonts.medievalSharp(
                  textStyle:
                      const TextStyle(fontSize: 36.0, color: Colors.white))),
          Column(children: [LikeButton(), Text('${_filme.indicada}')]),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // use whichever suits your need

            children: [
              SizedBox(
                width: 20,
              ),
              Text('${_filme.categoria}',
                  style: GoogleFonts.medievalSharp(
                      textStyle: const TextStyle(
                          fontSize: 24.0, color: Colors.white))),
              Text('${_filme.anoLancamento}',
                  style: GoogleFonts.medievalSharp(
                      textStyle: const TextStyle(
                          fontSize: 20.0, color: Colors.white))),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.black,
            child: Text('${_filme.score}',
                style: GoogleFonts.medievalSharp(
                    textStyle:
                        const TextStyle(fontSize: 32.0, color: Colors.white))),
          )
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
