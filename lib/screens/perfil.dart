import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:indikai/storage_service.dart';
import '../models/filme.dart';

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({Key? key}) : super(key: key);

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  final _user = FirebaseAuth.instance.currentUser as User;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  late CollectionReference _filmes;
  final Storage storage = Storage();

  Future<void> _signOut() async {
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  Widget get corpoListaFilmesVazia => Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Text('Não indicou nenhum filme?',
                style: GoogleFonts.rubikWetPaint(
                    textStyle:
                        const TextStyle(fontSize: 24.0, color: Colors.white))),
            Text('Indicaí',
                style: GoogleFonts.rubikWetPaint(
                    textStyle:
                        const TextStyle(fontSize: 36.0, color: Colors.white))),
          ]));

  _getImagemDeFirebaseStorage(filme) {
    return FutureBuilder(
        future: storage.downloadURL('${filme.imagem}'),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return SizedBox(
                width: 20,
                height: 155,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                    child: Image.network(
                      snapshot.data!,
                      fit: BoxFit.fitHeight,
                    )));
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          return Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    _filmes = FirebaseFirestore.instance
        .collection('/usuarios')
        .doc(_user.uid)
        .collection('filmes');
    return StreamBuilder(
      stream: _filmes.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          Widget body = corpoListaFilmesVazia;
          if (snapshot.data!.docs.isNotEmpty) {
            body = SingleChildScrollView(
                child: Column(children: [
              const SizedBox(
                height: 50,
              ),
              CircleAvatar(
                radius: 105,
                backgroundColor: Colors.white38,
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage('${_user.photoURL}'),
                  backgroundColor: Colors.transparent,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text('${_user.displayName}',
                  style: GoogleFonts.rubikWetPaint(
                      textStyle: const TextStyle(fontSize: 36.0),
                      color: Colors.white)),
              const SizedBox(height: 5),
              Text('${_user.email}',
                  style:
                      const TextStyle(fontSize: 20.0, color: Colors.white70)),
              const SizedBox(
                height: 20,
              ),
              Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _signOut();
                      if (!mounted) return;
                      Navigator.of(context).pushReplacementNamed("/splash");
                    },
                    child: const Text('Desconectar',
                        style: TextStyle(fontSize: 16)),
                  )),
              Text('Minhas indicações',
                  style: GoogleFonts.medievalSharp(
                      textStyle: const TextStyle(
                          fontSize: 24.0, color: Colors.white))),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final documentSnapshot = snapshot.data!.docs[index]
                      as DocumentSnapshot<Map<String, dynamic>>;
                  final filme = Filme.fromDocument(documentSnapshot);
                  return InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: _getImagemDeFirebaseStorage(filme),
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/detalhesfilme', arguments: filme);
                      });
                },
              )
            ]));
          }
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 75,
              title: Text('Indicaí',
                  style: GoogleFonts.rubikWetPaint(
                      textStyle: const TextStyle(fontSize: 48.0))),
              actions: [
                InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(1),
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
            body: body,
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed("/indicafilme");
              },
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
