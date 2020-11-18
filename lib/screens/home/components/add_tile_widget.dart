import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja/models/section.dart';
import 'package:loja/models/section_item.dart';
import 'package:provider/provider.dart';
import 'package:loja/screens/edit_products/components/image_source_sheet.dart';

class AddTileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final section = context.watch<Section>();
    void onImageSelected(File file) {
      section.addItem(SectionItem(imagem: file));
      Navigator.of(context).pop();
    }

    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: () {
          if (Platform.isAndroid) {
            showModalBottomSheet(
                context: context,
                builder: (_) => ImageSourceSheet(
                      onImageSelected: onImageSelected,
                    ));
            //COLOCAR ASYNC NA FUNCTION
            // File file = await showModalBottomSheet(
            //     context: context,
            //     builder: (_) => ImageSourceSheet());
          } else {
            showCupertinoModalPopup(
                context: context,
                builder: (_) => ImageSourceSheet(
                      onImageSelected: onImageSelected,
                    ));
          }
        },
        child: Container(
          color: Colors.white.withAlpha(30),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
