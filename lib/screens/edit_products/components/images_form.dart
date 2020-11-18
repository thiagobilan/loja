import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja/models/produtos.dart';
import 'package:loja/screens/edit_products/components/image_source_sheet.dart';

class ImagesForm extends StatelessWidget {
  const ImagesForm(this.product);
  final Produto product;
  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List.from(product.images),
      validator: (images) {
        if (images.isEmpty) {
          return 'Insira ao menos uma Imagem.';
        }
        return null;
      },
      onSaved: (images) => product.newImages = images,
      builder: (state) {
        void onImageSelected(File file) {
          state.value.add(file);
          state.didChange(state.value);
          Navigator.of(context).pop();
        }

        return Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: state.value.map<Widget>((image) {
                  return Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      if (image is String)
                        Image.network(image)
                      else
                        Image.file(
                          image as File,
                          fit: BoxFit.cover,
                        ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            icon: Icon(Icons.remove),
                            color: Colors.red,
                            onPressed: () {
                              state.value.remove(image);

                              // Chamado quando tem modificacao!
                              state.didChange(state.value);
                            }),
                      )
                    ],
                  );
                }).toList()
                  ..add(
                    Material(
                      color: Colors.grey[100],
                      child: IconButton(
                        icon: Icon(Icons.add_a_photo),
                        iconSize: 80,
                        color: Theme.of(context).primaryColor,
                        onPressed: () async {
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
                      ),
                    ),
                  ),
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: Theme.of(context).primaryColor,
                autoplayDuration: const Duration(seconds: 15),
              ),
            ),
            if (state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
