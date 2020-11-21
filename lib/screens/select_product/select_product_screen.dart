import 'package:flutter/material.dart';
import 'package:loja/models/product_manager.dart';
import 'package:provider/provider.dart';

class SelectProductScreeen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vincular Produto'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Consumer<ProductManager>(
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.todosProdutos.length,
            itemBuilder: (context, index) {
              final product = value.todosProdutos[index];
              return ListTile(
                leading: Image.network(product.images.first),
                title: Text(product.nome),
                subtitle: Text("R\$ ${product.menorPreco}"),
                onTap: () {
                  Navigator.of(context).pop(product);
                },
              );
            },
          );
        },
      ),
    );
  }
}
