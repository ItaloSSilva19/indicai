import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/filme.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CollectionReference _filmes;
  final _user = FirebaseAuth.instance.currentUser as User;

  @override
  Widget build(BuildContext context) {
    _filmes =
        FirebaseFirestore.instance.collection('usuarios/${_user.uid}/filmes');
    return StreamBuilder(
      stream: _filmes.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data!.docs.length);
          Widget body = const Center(
            child: Text('Nenhum filme cadastrado'),
          );
          if (snapshot.data!.docs.isNotEmpty) {
            body = ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final documentSnapshot = snapshot.data!.docs[index]
                    as DocumentSnapshot<Map<String, dynamic>>;
                final filme = Filme.fromDocument(documentSnapshot);
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(filme.score!),
                  ),
                  title: Text(filme.nome!),
                  subtitle: Text(filme.categoria!),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/detalhesfilme',
                      arguments: filme,
                    );
                  },
                );
              },
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Text('Indicaí',
                  style: GoogleFonts.rubikWetPaint(
                      textStyle: const TextStyle(fontSize: 36.0))),
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
