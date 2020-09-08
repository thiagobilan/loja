import 'package:loja/models/produtos.dart';
import 'package:loja/models/tamanho_item.dart';

class ProdutoCarrinho {
  ProdutoCarrinho.fromProduto(this.produto) {
    produtoId = produto.id;
    quantidade = 1;
    tamanho = produto.tamanhoSelecionado.nome;
  }
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

  num get precoUnitario {
    if (produto == null) {
      return null;
    }
    return itemSize?.preco ?? 0;
  }
}
