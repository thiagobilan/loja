import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loja/models/home_manager.dart';
import 'package:loja/models/product_manager.dart';
import 'package:loja/models/produtos.dart';
import 'package:loja/models/section.dart';
import 'package:loja/models/section_item.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemTile extends StatelessWidget {
  const ItemTile(this.item);
  final SectionItem item;
  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    return GestureDetector(
      onTap: () {
        if (item.produto != null) {
          final product =
              context.read<ProductManager>().findProductById(item.produto);
          if (product != null) {
            Navigator.of(context).pushNamed('/produto', arguments: product);
          }
        }
      },
      onLongPress: homeManager.editing
          ? () {
              showDialog(
                context: context,
                builder: (_) {
                  final product = context
                      .read<ProductManager>()
                      .findProductById(item.produto);
                  return AlertDialog(
                    title: const Text("Editar item."),
                    content: product != null
                        ? ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Image.network(product.images.first),
                            title: Text(product.nome),
                            subtitle: Text("R\$ ${product.menorPreco}"),
                          )
                        : null,
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          context.read<Section>().removeitem(item);
                          Navigator.of(context).pop();
                        },
                        textColor: Colors.red,
                        child: const Text('Excluir'),
                      ),
                      FlatButton(
                          onPressed: () async {
                            if (product != null) {
                              item.produto = null;
                            } else {
                              final Produto product =
                                  await Navigator.of(context)
                                      .pushNamed('/select_product') as Produto;
                              item.produto = product?.id;
                            }
                            Navigator.of(context).pop();
                          },
                          child: Text(
                              product != null ? 'Desvincular' : 'Vincular'))
                    ],
                  );
                },
              );
            }
          : null,
      child: AspectRatio(
        aspectRatio: 1.2,
        child: item.imagem is String
            ? FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: item.imagem as String,
                fit: BoxFit.cover,
              )
            : Image.file(
                item.imagem as File,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
