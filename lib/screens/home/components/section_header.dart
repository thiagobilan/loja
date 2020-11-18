import 'package:flutter/material.dart';
import 'package:loja/common/botao_customizado.dart';
import 'package:loja/models/home_manager.dart';
import 'package:loja/models/section.dart';
import 'package:provider/provider.dart';

class SectionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    final section = context.watch<Section>();
    if (homeManager.editing) {
      return Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              initialValue: section.name,
              decoration: InputDecoration(
                hintText: 'Título',
                isDense: true,
                border: InputBorder.none,
              ),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
              onChanged: (value) => section.name = value,
            ),
          ),
          BotaoCustomizado(
            cor: Colors.white,
            iconeBotao: Icons.remove,
            onTap: () {
              homeManager.removeSection(section);
            },
          )
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          section.name ?? '',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      );
    }
  }
}
