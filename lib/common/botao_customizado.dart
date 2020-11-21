import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  const BotaoCustomizado({this.iconeBotao, this.cor, this.onTap, this.size});
  final IconData iconeBotao;
  final Color cor;
  final VoidCallback onTap;
  final double size;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Icon(
              iconeBotao,
              color: onTap != null ? cor : Colors.grey,
              size: size ?? 24,
            ),
          ),
        ),
      ),
    );
  }
}
