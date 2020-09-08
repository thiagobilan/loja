import 'package:flutter/material.dart';
import 'package:loja/models/cart_manager.dart';
import 'package:loja/screens/carrinho/componentes/cart_tile.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __) {
          return Column(
              children: cartManager.items
                  .map((produtoCarrinho) => CartTile(produtoCarrinho))
                  .toList());
        },
      ),
    );
  }
}
