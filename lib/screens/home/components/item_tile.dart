import 'package:flutter/material.dart';
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
      child: AspectRatio(
        aspectRatio: 1.2,
        child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: item.imagem,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
