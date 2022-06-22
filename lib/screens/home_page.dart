import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../pallete/pallete.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/filme.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Indicaí',
      theme: ThemeData(
          primarySwatch: Palette.indicaiRed,
          scaffoldBackgroundColor: const Color(0xFF49454F)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CollectionReference _filmes =
      FirebaseFirestore.instance.collection('filmes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Indicaí',
              style: GoogleFonts.rubikWetPaint(
                  textStyle: const TextStyle(
                fontSize: 36.0,
              ))),
        ),
        body: Column(
          children: [
            Flexible(
              child: StreamBuilder(
                stream: _filmes.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];
                        final Filme filme =
                            Filme.fromDocument(documentSnapshot);
                        return Column(
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, "/indicafilme");
                                },
                                child: Card(
                                    child: ListTile(
                                  leading: CircleAvatar(
                                    child: Text(filme.score!),
                                  ),
                                  title: Text(filme.nome!),
                                  subtitle: Text(filme.categoria!),
                                )))
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/indicafilme");
              },
              child: Text('Indicar'),
            ),
          ],
        ));
  }
}
