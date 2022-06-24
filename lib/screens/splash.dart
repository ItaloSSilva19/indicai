import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

/// Realiza login com o Google
Future<UserCredential> signInWithGoogle() async {
  // Inicia o fluxo de autenticação usando o GoogleSignIn
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtém os detalhes da autenticação a partir da requisição (GoogleSignInAccount)
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Cria uma credencial
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Realiza o login no Firebase
  UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

  // Se o usuário é novo, então cadastra um documento na coleção de usuários
  if (userCredential.additionalUserInfo?.isNewUser == true) {
    final CollectionReference usuarios =
        FirebaseFirestore.instance.collection('usuarios');
    final user = userCredential.user;
    await usuarios.doc(user?.uid).set({
      "display_name": user?.displayName,
      "email": user?.email,
      "photo_url": user?.photoURL
    });
  }

  return userCredential;
}

class TelaSplash extends StatefulWidget {
  const TelaSplash({Key? key}) : super(key: key);

  @override
  State<TelaSplash> createState() => _TelaSplashState();
}

class _TelaSplashState extends State<TelaSplash> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage('assets/graphics/indicai.jpeg'),
          ),
          const SizedBox(
            height: 20,
          ),
          SignInButton(
            Buttons.Google,
            onPressed: () async {
              await signInWithGoogle();
              if (!mounted) return;
              Navigator.of(context).pushReplacementNamed("/homepage");
            },
            text: 'ENTRAR COM GOOGLE',
          ),
        ],
      ),
    );
  }
}
