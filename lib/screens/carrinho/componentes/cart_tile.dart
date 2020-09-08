import 'package:flutter/material.dart';
import 'package:loja/models/produto_carrinho.dart';

class CartTile extends StatelessWidget {
  const CartTile(this.produtoCarrinho);
  final ProdutoCarrinho produtoCarrinho;
  @override
  Widget build(BuildContext context) {
    return Card(
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
                    Text(
                      'R\$ ${produtoCarrinho.precoUnitario.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
