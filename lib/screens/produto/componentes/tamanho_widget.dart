import 'package:flutter/material.dart';
import 'package:loja/models/produtos.dart';
import 'package:loja/models/tamanho_item.dart';
import 'package:provider/provider.dart';

class TamanhoWidget extends StatelessWidget {
  const TamanhoWidget({this.tamanho});
  final TamanhoItem tamanho;
  @override
  Widget build(BuildContext context) {
    final produto = context.watch<Produto>();
    final selecionado = tamanho == produto.tamanhoSelecionado;
    Color color;
    if (!tamanho.temEstoque) {
      color = Colors.red.withAlpha(50);
    } else if (selecionado) {
      color = Theme.of(context).primaryColor;
    } else {
      color = Colors.grey;
    }
    return GestureDetector(
      onTap: () {
        if (tamanho.temEstoque) {
          produto.tamanhoSelecionado = tamanho;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: color,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                tamanho.nome,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'R\$ ${tamanho.preco.toStringAsFixed(2)}',
                style: TextStyle(
                  color: color,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
