import 'package:flutter/material.dart';
import 'package:loja/common/botao_customizado.dart';
import 'package:loja/models/tamanho_item.dart';

class EditItemSize extends StatelessWidget {
  final TamanhoItem size;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  const EditItemSize(
      {this.size, this.onRemove, this.onMoveDown, this.onMoveUp, Key key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 30,
          child: TextFormField(
            validator: (name) {
              if (name.isEmpty) {
                return 'Inválido';
              }
              return null;
            },
            initialValue: size.nome,
            decoration: const InputDecoration(
              labelText: 'Título',
              isDense: true,
            ),
            onChanged: (name) => size.nome = name,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          flex: 30,
          child: TextFormField(
            validator: (stock) {
              if (int.tryParse(stock) == null) {
                return 'Inválido';
              }
              return null;
            },
            onChanged: (stock) => size.quantidade = int.tryParse(stock),
            initialValue: size.quantidade?.toString(),
            decoration: const InputDecoration(
              labelText: 'Estoque',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          flex: 40,
          child: TextFormField(
            validator: (price) {
              if (num.tryParse(price) == null) {
                return 'Inválido';
              }
              return null;
            },
            onChanged: (price) => size.preco = num.tryParse(price),
            initialValue: size.preco?.toStringAsFixed(2),
            decoration: const InputDecoration(
              labelText: 'Preço',
              prefixText: 'R\$:  ',
              isDense: true,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        BotaoCustomizado(
          iconeBotao: Icons.remove,
          cor: Colors.red,
          onTap: onRemove,
        ),
        BotaoCustomizado(
          iconeBotao: Icons.arrow_drop_up,
          cor: Colors.black,
          onTap: onMoveUp,
        ),
        BotaoCustomizado(
          iconeBotao: Icons.arrow_drop_down,
          cor: Colors.black,
          onTap: onMoveDown,
        ),
      ],
    );
  }
}
