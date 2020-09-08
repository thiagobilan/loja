import 'package:flutter/material.dart';
import 'package:loja/helpers/validator.dart';
import 'package:loja/models/user.dart';
import 'package:loja/models/user_manager.dart';
import 'package:provider/provider.dart';

class CadastroScreen extends StatelessWidget {
  final User usuario = User();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController senhalController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Criar Conta'),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Consumer<UserManager>(
            builder: (_, userManager, __) => Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                children: <Widget>[
                  TextFormField(
                    autocorrect: false,
                    enabled: !userManager.loading,
                    decoration:
                        const InputDecoration(hintText: 'Nome Completo'),
                    validator: (nome) {
                      if (nome.isEmpty) {
                        return ' Campo obrigatório';
                      } else if (nome.trim().split(' ').length <= 1) {
                        return 'Preencha seu Nome Completo';
                      }
                      return null;
                    },
                    onSaved: (nome) => usuario.nome = nome,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    autocorrect: false,
                    enabled: !userManager.loading,
                    decoration: const InputDecoration(hintText: 'E-Mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo obrigatório';
                      } else if (!emailValidator(value)) {
                        return 'E-mail inválido';
                      }
                      return null;
                    },
                    onSaved: (email) => usuario.email = email,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    enabled: !userManager.loading,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: 'Senha'),
                    validator: (senha) {
                      if (senha.isEmpty) {
                        return 'Campo obrigatório';
                      } else if (senha.length < 6) {
                        return 'Senha curta';
                      }
                      return null;
                    },
                    onSaved: (senha) => usuario.pass = senha,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    enabled: !userManager.loading,
                    obscureText: true,
                    decoration:
                        const InputDecoration(hintText: 'Repita a Senha'),
                    validator: (senha) {
                      if (senha.isEmpty) {
                        return 'Campo obrigatório';
                      } else if (senha.length < 6) {
                        return 'Senha curta';
                      }
                      return null;
                    },
                    onSaved: (senha) => usuario.validarSenha = senha,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 44,
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      disabledColor:
                          Theme.of(context).primaryColor.withAlpha(100),
                      textColor: Colors.white,
                      onPressed: userManager.loading
                          ? null
                          : () {
                              if (formKey.currentState.validate()) {
                                formKey.currentState.save();
                                if (usuario.pass != usuario.validarSenha) {
                                  scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content:
                                          const Text('Senhas não coincidem!'),
                                      backgroundColor: Colors.red[800],
                                    ),
                                  );
                                  return;
                                }
                                context.read<UserManager>().criarConta(
                                      usuario: usuario,
                                      onSuccess: () {
                                        Navigator.of(context).pop();
                                      },
                                      onFail: (e) {
                                        // debugPrint(e.toString());
                                        scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                          content: Text('Falha ao Entrar: $e'),
                                          backgroundColor: Colors.red,
                                        ));
                                      },
                                    );
                              }
                            },
                      child: userManager.loading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                          : const Text(
                              'Criar Conta',
                            ),
                    ),
                  )
                ],
              ),
<<<<<<< HEAD
            ),
=======
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
>>>>>>> parent of 405546e... Projeto Criado
          ),
        ),
      ),
    );
  }
}
