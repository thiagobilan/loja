import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja/models/cart_manager.dart';
import 'package:loja/models/produtos.dart';
import 'package:loja/models/user_manager.dart';
import 'package:loja/screens/produto/componentes/tamanho_widget.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen(this.produto);
  final Produto produto;
  @override
  Widget build(BuildContext context) {
    final corPrimaria = Theme.of(context).primaryColor;
    return ChangeNotifierProvider.value(
      value: produto,
      child: Scaffold(
        appBar: AppBar(
          title: Text(produto.nome),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.5,
              child: Carousel(
                dotSize: 4,
                dotBgColor: Colors.transparent,
                dotColor: corPrimaria,
                autoplayDuration: const Duration(seconds: 15),
                images: produto.images.map((url) {
                  return Image.network(
                    url,
                    fit: BoxFit.contain,
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    produto.nome,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: Text(
                      'A partir de',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Text(
                    'R\$ 19.99',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: corPrimaria,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Descrição',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    produto.descricao,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Tamanhos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: produto.tamanhos.map((e) {
                      return TamanhoWidget(
                        tamanho: e,
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (produto.temEstoque)
                    Consumer2<UserManager, Produto>(
                      builder: (_, userManager, produto, __) {
                        return SizedBox(
                          height: 44,
                          child: RaisedButton(
                            onPressed: produto.tamanhoSelecionado != null
                                ? () {
                                    if (userManager.isLogged) {
                                      context
                                          .read<CartManager>()
                                          .adicionarAoCarrinho(produto);
                                      Navigator.of(context)
                                          .pushNamed('/carrinho');
                                    } else {
                                      Navigator.of(context).pushNamed('/login');
                                    }
                                  }
                                : null,
                            color: corPrimaria,
                            textColor: Colors.white,
                            child: Text(
                              userManager.isLogged
                                  ? 'Adicionar ao Carrinho'
                                  : 'Entre para comprar',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      },
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
