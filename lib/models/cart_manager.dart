import 'package:loja/models/produto_carrinho.dart';
import 'package:loja/models/produtos.dart';

class CartManager {
  List<ProdutoCarrinho> items = [];

  void adicionarAoCarrinho(Produto produto) {
    items.add(ProdutoCarrinho.fromProduto(produto));
  }
}
