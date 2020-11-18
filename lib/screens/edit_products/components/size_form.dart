import 'package:flutter/material.dart';
import 'package:loja/common/botao_customizado.dart';
import 'package:loja/models/produtos.dart';
import 'package:loja/models/tamanho_item.dart';
import 'package:loja/screens/edit_products/components/edit_item_size.dart';

class SizesForm extends StatelessWidget {
  final Produto product;
  const SizesForm(this.product);
  @override
  Widget build(BuildContext context) {
    return FormField<List<TamanhoItem>>(
      validator: (sizes) {
        if (sizes.isEmpty) {
          return 'Insira um Tamanho';
        }
        return null;
      },
      initialValue: product.tamanhos,
      builder: (state) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Tamanhos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                BotaoCustomizado(
                  iconeBotao: Icons.add,
                  cor: Colors.black,
                  onTap: () {
                    state.value.add(TamanhoItem());
                    state.didChange(state.value);
                  },
                ),
              ],
            ),
            Column(
              children: state.value.map((tamanho) {
                return EditItemSize(
                  key: ObjectKey(tamanho),
                  size: tamanho,
                  onRemove: () {
                    state.value.remove(tamanho);
                    state.didChange(state.value);
                  },
                  onMoveUp: tamanho == state.value.first
                      ? null
                      : () {
                          final index = state.value.indexOf(tamanho);
                          state.value.remove(tamanho);
                          state.value.insert(index - 1, tamanho);
                          state.didChange(state.value);
                        },
                  onMoveDown: tamanho == state.value.last
                      ? null
                      : () {
                          final index = state.value.indexOf(tamanho);
                          state.value.remove(tamanho);
                          state.value.insert(index + 1, tamanho);
                          state.didChange(state.value);
                        },
                );
              }).toList(),
            ),
            if (state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              )
          ],
        );
      },
    );
  }
}
