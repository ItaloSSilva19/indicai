import 'package:flutter/material.dart';

import 'splash.dart';
import 'home_page.dart';
import 'indica_filme.dart';
import 'detalhes_filmes.dart';
import 'editar_filme.dart';
import '../pallete/pallete.dart';

/// A classe [MyApp] representa o ponto-de-partida do aplicativo, ou seja,
/// é o widget de mais alto nível na árvore de widget do aplicativo.
/// As rotas são:
/// /: a rota raiz, associada ao widget [TelaInicial]
/// /posto: associada ao widget [TelaEscolherPosto]
/// /analisar-precos: associada ao widget [TelaCalcularRelacaoEtanolGasolina]
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  /// O método [build] retorna uma instância de [MaterialApp]
  /// para representar a estrutura padrão do aplicativo ao utilizar
  /// o Material Design.
  ///
  /// Este método também define as rotas e indica que a rota inicial
  /// é a associada a [TelaInicial].
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Indicaí',
      theme: ThemeData(
        primarySwatch: Palette.indicaiRed,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const TelaSplash(),
        '/homepage': (context) => const MyHomePage(),
        '/indicafilme': (context) => TelaIndicaFilme(),
        '/detalhesfilme': (context) => TelaDetalhesFilme(),
        '/editarfilme': (context) => TelaEditarFilme(),
      },
    );
  }
}
