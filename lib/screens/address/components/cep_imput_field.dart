import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:loja/common/botao_customizado.dart';
import 'package:loja/models/address.dart';
import 'package:loja/models/cart_manager.dart';
import 'package:provider/provider.dart';

class CepImputField extends StatefulWidget {
  const CepImputField(this.address);

  final Address address;

  @override
  _CepImputFieldState createState() => _CepImputFieldState();
}

class _CepImputFieldState extends State<CepImputField> {
  final TextEditingController cepControlleer = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final cartManager = context.watch<CartManager>();
    if (widget.address.zipCode == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            enabled: !cartManager.loading,
            controller: cepControlleer,
            decoration: const InputDecoration(
                isDense: true, labelText: 'Cep', hintText: '12345-678'),
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              CepInputFormatter()
            ],
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty) {
                return 'Campo Obrigatorio';
              } else if (value.length != 10) {
                return 'Cep Inválido';
              } else {
                return null;
              }
            },
          ),
          if (cartManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
              backgroundColor: Colors.transparent,
            ),
          RaisedButton(
            onPressed: !cartManager.loading
                ? () async {
                    if (Form.of(context).validate()) {
                      try {
                        await cartManager.getAddress(cepControlleer.text);
                      } catch (e) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        // TODO
                      }
                    }
                  }
                : null,
            color: primaryColor,
            textColor: Colors.white,
            disabledColor: primaryColor.withAlpha(100),
            child: const Text('Buscar CEP'),
          ),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          Expanded(
            child: Text(
              'CEP: ${widget.address.zipCode}',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          BotaoCustomizado(
            iconeBotao: Icons.edit,
            cor: primaryColor,
            onTap: () {
              context.read<CartManager>().removeAddress();
            },
            size: 20,
          )
        ],
      );
    }
  }
}
