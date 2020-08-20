import 'package:flutter/material.dart';

class CadastroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Criar Conta'),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(hintText: 'Nome Completo'),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: 'E-Mail'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Senha'),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Repita a Senha'),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 44,
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  disabledColor: Theme.of(context).primaryColor.withAlpha(100),
                  textColor: Colors.white,
                  onPressed: () {},
                  child: const Text('Criar Conta'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
