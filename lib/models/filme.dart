import 'package:cloud_firestore/cloud_firestore.dart';

class Filme {
  String id;
  String? nome;
  String? categoria;
  String? score;
  String? anoLancamento;

  Filme(
      {required this.id,
      this.nome,
      this.categoria,
      this.score,
      this.anoLancamento});

  Filme.vazio()
      : this(id: '', nome: '', categoria: '', score: '', anoLancamento: '');

  Filme.fromDocument(DocumentSnapshot document)
      : this(
            id: document.id,
            nome: document["nome"],
            categoria: document["categoria"],
            score: document["score"],
            anoLancamento: document["anoLancamento"]);
}
