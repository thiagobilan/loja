import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja/models/address.dart';
import 'package:loja/models/cart_manager.dart';
import 'package:provider/provider.dart';

class AddressImputField extends StatelessWidget {
  const AddressImputField(this.address);
  final Address address;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final cartmanager = context.watch<CartManager>();

    String emptyValidator(String text) {
      return text.isEmpty ? 'Campo Obrigatorio' : null;
    }

    if (address.zipCode != null && cartmanager.deliveryPrice == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            enabled: !cartmanager.loading,
            initialValue: address.street,
            decoration: const InputDecoration(
                isDense: true,
                labelText: 'Rua/Avenida',
                hintText: 'Av. Brasil'),
            validator: emptyValidator,
            onSaved: (newValue) {
              address.street = newValue;
            },
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  enabled: !cartmanager.loading,
                  initialValue: address.number,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: '123',
                    labelText: 'Numero',
                  ),
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  validator: emptyValidator,
                  onSaved: (newValue) => address.number = newValue,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: TextFormField(
                  enabled: !cartmanager.loading,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'Opcional',
                    labelText: 'Complemento',
                  ),
                  onSaved: (newValue) => address.complement = newValue,
                ),
              ),
            ],
          ),
          TextFormField(
            enabled: !cartmanager.loading,
            autocorrect: false,
            initialValue: address.district,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Bairro',
              hintText: 'Olaria',
            ),
            validator: emptyValidator,
            onSaved: (newValue) => address.district = newValue,
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: TextFormField(
                  autocorrect: false,
                  enabled: false,
                  initialValue: address.city,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'Rio de Janeiro',
                    labelText: 'Cidade',
                  ),
                  validator: emptyValidator,
                  onSaved: (newValue) => address.city = newValue,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: TextFormField(
                  autocorrect: false,
                  enabled: false,
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 2,
                  initialValue: address.state,
                  decoration: const InputDecoration(
                    counterText: '',
                    isDense: true,
                    hintText: 'RJ',
                    labelText: 'UF',
                  ),
                  onSaved: (newValue) => address.state = newValue,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          if (cartmanager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
              backgroundColor: Colors.transparent,
            ),
          RaisedButton(
            onPressed: !cartmanager.loading
                ? () async {
                    if (Form.of(context).validate()) {
                      Form.of(context).save();
                      try {
                        await context.read<CartManager>().setAddress(address);
                      } catch (e) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                : null,
            color: primaryColor,
            disabledColor: primaryColor.withAlpha(100),
            textColor: Colors.white,
            child: const Text('Calcular Frete'),
          )
        ],
      );
    } else if (address.zipCode != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          '${address.street}, ${address.number}\n${address.district}\n${address.city} - ${address.state}',
        ),
      );
    } else {
      return Container();
    }
  }
}
