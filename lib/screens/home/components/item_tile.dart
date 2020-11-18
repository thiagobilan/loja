import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loja/models/home_manager.dart';
import 'package:loja/models/product_manager.dart';
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
                  return AlertDialog(
                    title: const Text("Editar item."),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            context.read<Section>().removeitem(item);
                            Navigator.of(context).pop();
                          },
                          textColor: Colors.red,
                          child: const Text('Excluir'))
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
