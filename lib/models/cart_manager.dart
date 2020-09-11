import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja/models/produto_carrinho.dart';
import 'package:loja/models/produtos.dart';
import 'package:loja/models/user.dart';
import 'package:loja/models/user_manager.dart';

class CartManager extends ChangeNotifier {
  List<ProdutoCarrinho> items = [];

  User user;

  num productsPrice = 0.0;

  void atualizarUsuario(UserManager userManager) {
    user = userManager.user;
    items.clear();

    if (user != null) {
      _pegarItensCarrinho();
    }
  }

  Future<void> _pegarItensCarrinho() async {
    final QuerySnapshot cartSnap = await user.cartReference.getDocuments();
    items = cartSnap.documents
        .map(
            (d) => ProdutoCarrinho.fromDocument(d)..addListener(_atualizarItem))
        .toList();
  }

  void adicionarAoCarrinho(Produto produto) {
    try {
      final e = items.firstWhere((p) => p.estacavel(produto));
      e.incrementar();
    } catch (e) {
      final carrinhoDeProdutos = ProdutoCarrinho.fromProduto(produto);
      carrinhoDeProdutos.addListener(_atualizarItem);
      items.add(carrinhoDeProdutos);
      user.cartReference
          .add(carrinhoDeProdutos.carrinhoParaMap())
          .then((doc) => carrinhoDeProdutos.id = doc.documentID);
      _atualizarItem();
    }
  }

  void _atualizarItem() {
    productsPrice = 0.0;
    for (var i = 0; i < items.length; i++) {
      final produtosCarrinho = items[i];
      if (produtosCarrinho.quantidade == 0) {
        _removerDoCarrinho(produtosCarrinho);
        i--;
        continue;
      }
      productsPrice += produtosCarrinho.totalPrice;
      _atualizarProdutoNoCarrinho(produtosCarrinho);
    }
    notifyListeners();
  }

  void _atualizarProdutoNoCarrinho(ProdutoCarrinho produtoCarinho) {
    if (produtoCarinho.id != null) {
      user.cartReference
          .document(produtoCarinho.id)
          .updateData(produtoCarinho.carrinhoParaMap());
    }
  }

  void _removerDoCarrinho(ProdutoCarrinho produtoCarrinho) {
    items.removeWhere((p) => p.id == produtoCarrinho.id);
    user.cartReference.document(produtoCarrinho.id).delete();
    produtoCarrinho.removeListener(_atualizarItem);
    notifyListeners();
  }

  bool get isCartValid {
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) return false;
    }
    return true;
  }
}
