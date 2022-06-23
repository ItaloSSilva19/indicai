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

  factory Filme.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Filme(
        id: snapshot.id,
        nome: data?["nome"],
        categoria: data?["categoria"],
        score: data?["score"],
        anoLancamento: data?["anoLancamento"]);
  }

  Map<String, dynamic> toDocument() {
    return {
      if (nome != null) "nome": nome,
      if (categoria != null) "categoria": categoria,
      if (score != null) "score": score,
      if (anoLancamento != null) "anoLancamento": anoLancamento,
    };
  }
}
