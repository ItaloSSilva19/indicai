import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({Key? key}) : super(key: key);

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  final _user = FirebaseAuth.instance.currentUser as User;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Indicaí',
                style: GoogleFonts.rubikWetPaint(
                    textStyle: const TextStyle(fontSize: 36.0)))),
        body: Column(
          children: [
            SizedBox(
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
            SizedBox(
              height: 20,
            ),
            Text('${_user.displayName}',
                style: GoogleFonts.rubikWetPaint(
                    textStyle: const TextStyle(fontSize: 36.0),
                    color: Colors.white)),
            SizedBox(height: 5),
            Text('${_user.email}',
                style: TextStyle(fontSize: 20.0, color: Colors.white70)),
            SizedBox(
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
                  child: Text('Desconectar', style: TextStyle(fontSize: 16)),
                )),
          ],
        ));
  }
}
