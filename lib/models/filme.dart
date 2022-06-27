import 'package:cloud_firestore/cloud_firestore.dart';

class Filme {
  String id;
  String? nome;
  String? categoria;
  String? score;
  String? anoLancamento;
  String? imagem;
  String? usuario;
  int? indicada;

  Filme(
      {required this.id,
      this.nome,
      this.categoria,
      this.score,
      this.anoLancamento,
      this.imagem,
      this.usuario,
      this.indicada});

  Filme.vazio()
      : this(
          id: '',
          nome: '',
          categoria: '',
          score: '',
          anoLancamento: '',
          imagem: 'indicai.png',
          usuario: '',
          indicada: 0,
        );

  factory Filme.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Filme(
        id: snapshot.id,
        nome: data?["nome"],
        categoria: data?["categoria"],
        score: data?["score"],
        anoLancamento: data?["anoLancamento"],
        imagem: data?["imagem"],
        usuario: data?["usuario"],
        indicada: data?["indicada"]);
  }

  Map<String, dynamic> toDocument() {
    return {
      if (nome != null) "nome": nome,
      if (categoria != null) "categoria": categoria,
      if (score != null) "score": score,
      if (anoLancamento != null) "anoLancamento": anoLancamento,
      if (imagem != null) "imagem": imagem,
      if (usuario != null) "usuario": usuario,
      if (indicada != null) "indicada": indicada,
    };
  }
}
