import 'package:flutter/material.dart';
import 'package:loja/common/empty_card.dart';
import 'package:loja/common/login_card.dart';
import 'package:loja/common/price_card.dart';
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
          if (cartManager.user == null) {
            return const LoginCard();
          }
          if (cartManager.items.isEmpty) {
            return EmptyCard(
              icon: Icons.remove_shopping_cart,
              title: 'Nenhum Pedido no Carrinho',
            );
          }
          return ListView(
            children: <Widget>[
              Column(
                children: cartManager.items
                    .map((produtoCarrinho) => CartTile(produtoCarrinho))
                    .toList(),
              ),
              PriceCard(
                buttonText: 'Continuar para entrega',
                onPressed: cartManager.isCartValid
                    ? () {
                        Navigator.of(context).pushNamed('/address');
                      }
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
