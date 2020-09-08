import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja/models/tamanho_item.dart';

class Produto extends ChangeNotifier {
  Produto.fromDocument(DocumentSnapshot document) {
    id = document['id'] as String;
    nome = document['nome'] as String;
    descricao = document['descricao'] as String;
    images = List<String>.from(document.data['imgs'] as List<dynamic>);
    tamanhos = (document.data['sizes'] as List<dynamic> ?? [])
        .map((s) => TamanhoItem.fromMap(s as Map<String, dynamic>))
        .toList();
  }
  String id;
  String nome;
  String descricao;
  List<String> images;
  List<TamanhoItem> tamanhos;
  TamanhoItem _tamanhoSelecionado;

  TamanhoItem get tamanhoSelecionado => _tamanhoSelecionado;
  set tamanhoSelecionado(TamanhoItem tamanho) {
    if (tamanho == _tamanhoSelecionado) {
      _tamanhoSelecionado = null;
    } else {
      _tamanhoSelecionado = tamanho;
    }
    notifyListeners();
  }

  int get estoqueTotal {
    int estoque = 0;
    for (final tamanho in tamanhos) {
      estoque += tamanho.quantidade;
    }
    return estoque;
  }

  bool get temEstoque => estoqueTotal > 0;

  TamanhoItem findSize(String nome) {
    try {
      return tamanhos.firstWhere((element) => element.nome == nome);
    } catch (e) {
      return null;
    }
  }
}
