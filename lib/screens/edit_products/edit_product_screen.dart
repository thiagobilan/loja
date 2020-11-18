import 'package:flutter/material.dart';
import 'package:loja/models/product_manager.dart';
import 'package:loja/models/produtos.dart';
import 'package:loja/screens/edit_products/components/images_form.dart';
import 'package:loja/screens/edit_products/components/size_form.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen(Produto p)
      : editing = p != null,
        product = p != null ? p.clone() : Produto();
  final Produto product;
  final bool editing;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(editing ? 'Editar Produto' : 'Criar Produto'),
          centerTitle: true,
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              ImagesForm(product),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      onSaved: (name) => product.nome = name,
                      initialValue: product.nome,
                      decoration: const InputDecoration(
                        hintText: 'Titulo',
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      validator: (name) {
                        if (name.length < 6) {
                          return 'Título muito curto';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'A paritr de',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      'R\$ ${product.menorPreco.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                      ),
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextFormField(
                      onSaved: (description) => product.descricao = description,
                      initialValue: product.descricao,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'Descrição',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      validator: (desc) {
                        if (desc.length < 10) {
                          return 'Descrição muito curta';
                        }
                        return null;
                      },
                    ),
                    SizesForm(product),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 44,
                      child: Consumer<Produto>(
                        builder: (_, product, __) {
                          return RaisedButton(
                            textColor: Colors.white,
                            color: Theme.of(context).primaryColor,
                            disabledColor:
                                Theme.of(context).primaryColor.withAlpha(100),
                            onPressed: product.loading
                                ? null
                                : () {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();
                                      product.save();
                                      context
                                          .read<ProductManager>()
                                          .update(product);
                                      Navigator.of(context).pop();
                                    }
                                  },
                            child: product.loading
                                ? const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Salvar',
                                    style: TextStyle(fontSize: 18),
                                  ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
