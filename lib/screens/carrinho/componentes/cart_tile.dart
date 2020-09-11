import 'package:flutter/material.dart';
import 'package:loja/common/botao_customizado.dart';
import 'package:loja/models/produto_carrinho.dart';
import 'package:provider/provider.dart';

class CartTile extends StatelessWidget {
  const CartTile(this.produtoCarrinho);
  final ProdutoCarrinho produtoCarrinho;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: produtoCarrinho,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                height: 80,
                width: 80,
                child: Image.network(produtoCarrinho.produto.images.first),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        produtoCarrinho.produto.nome,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: Text(
                          'Tamanho: ${produtoCarrinho.tamanho}',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Consumer<ProdutoCarrinho>(
                        builder: (context, value, child) {
                          if (produtoCarrinho.hasStock) {
                            return Text(
                              'R\$ ${produtoCarrinho.unitPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          } else {
                            return const Text(
                              'Sem Estoque suficiente',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Consumer<ProdutoCarrinho>(builder: (_, produtoCarrinho, __) {
                return Column(
                  children: <Widget>[
                    BotaoCustomizado(
                      cor: Theme.of(context).primaryColor,
                      iconeBotao: Icons.add,
                      onTap: produtoCarrinho.incrementar,
                    ),
                    Text(
                      '${produtoCarrinho.quantidade}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    BotaoCustomizado(
                      cor: produtoCarrinho.quantidade > 1
                          ? Theme.of(context).primaryColor
                          : Colors.red,
                      iconeBotao: Icons.remove,
                      onTap: produtoCarrinho.decrementar,
                    ),
                  ],
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
