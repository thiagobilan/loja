import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja/models/produtos.dart';
import 'package:loja/models/tamanho_item.dart';

class ProdutoCarrinho extends ChangeNotifier {
  ProdutoCarrinho.fromProduto(this.produto) {
    produtoId = produto.id;
    quantidade = 1;
    tamanho = produto.tamanhoSelecionado.nome;
  }

  ProdutoCarrinho.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    produtoId = document.data['pid'] as String;
    quantidade = document.data['qtd'] as int;
    tamanho = document.data['size'] as String;
    firestore.document('produtos/$produtoId').get().then(
      (d) {
        produto = Produto.fromDocument(d);
        notifyListeners();
      },
    );
  }

  Map<String, dynamic> carrinhoParaMap() {
    return {
      'pid': produtoId,
      'qtd': quantidade,
      'size': tamanho,
    };
  }

  final Firestore firestore = Firestore.instance;
  String id;
  Produto produto;
  String produtoId;
  String tamanho;
  int quantidade;

  TamanhoItem get itemSize {
    if (produto == null) {
      return null;
    }
    return produto.findSize(tamanho);
  }

  num get unitPrice {
    if (produto == null) {
      return 0;
    }
    return itemSize?.preco ?? 0;
  }

  num get totalPrice => unitPrice * quantidade;

  bool estacavel(Produto p) {
    return p.id == produtoId && p.tamanhoSelecionado.nome == tamanho;
  }

  void incrementar() {
    quantidade++;
    notifyListeners();
  }

  void decrementar() {
    quantidade--;
    notifyListeners();
  }

  bool get hasStock {
    final size = itemSize;
    if (size == null) return false;
    return size.quantidade > quantidade;
  }
}
