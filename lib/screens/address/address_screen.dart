import 'package:flutter/material.dart';
import 'package:loja/common/price_card.dart';
import 'package:loja/models/cart_manager.dart';
import 'package:loja/screens/address/components/address_card.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrega'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AddressCard(),
          Consumer<CartManager>(
            builder: (_, value, __) {
              return PriceCard(
                buttonText: 'Continuar para o Pagamento!',
                onPressed: value.isAddressValid ? () {} : null,
              );
            },
          )
        ],
      ),
    );
  }
}
