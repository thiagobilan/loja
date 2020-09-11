import 'package:flutter/material.dart';
import 'package:loja/common/custom_drawer/custom_drawer.dart';
import 'package:loja/models/product_manager.dart';
import 'package:loja/screens/produtos/componentes/produto_list_tile.dart';
import 'package:loja/screens/produtos/componentes/search_dialog.dart';
import 'package:provider/provider.dart';

class ProdutoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Consumer<ProductManager>(
          builder: (_, productManager, __) {
            if (productManager.search.isEmpty) {
              return const Text('Produtos');
            } else {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    onTap: () {
                      mostrarPesquisa(context, productManager.search);
                    },
                    child: Container(
                      width: constraints.biggest.width,
                      child: Text(
                        productManager.search,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          Consumer<ProductManager>(builder: (_, productManager, __) {
            if (productManager.search.isEmpty) {
              return IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  mostrarPesquisa(context, productManager.search);
                },
                // {
                //   final search = await showDialog(
                //     context: context,
                //     builder: (_) => SearchDialog(productManager.search),
                //   );
                //   if (search != null) {
                //     context.read<ProductManager>().search = search as String;
                //   }
                // },
              );
            } else {
              return IconButton(
                icon: Icon(Icons.close),
                onPressed: () async {
                  context.read<ProductManager>().search = '';
                },
              );
            }
          })
        ],
      ),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __) {
          final produtosFiltrados = productManager.produtosFiltrados;
          return ListView.builder(
            itemCount: produtosFiltrados.length,
            itemBuilder: (context, index) {
              return ProdutoListaTile(produtosFiltrados[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/carrinho'),
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.shopping_cart),
      ),
    );
  }

  Future<void> mostrarPesquisa(BuildContext context, String pesquisa) async {
    final search = await showDialog(
      context: context,
      builder: (_) => SearchDialog(pesquisa),
    );
    if (search != null) {
      context.read<ProductManager>().search = search as String;
    }
  }
}
