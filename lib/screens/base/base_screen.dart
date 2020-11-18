import 'package:flutter/material.dart';
import 'package:loja/common/custom_drawer/custom_drawer.dart';
import 'package:loja/models/page_manager.dart';
import 'package:loja/models/user_manager.dart';
import 'package:loja/screens/admin_users/admin_users_screen.dart';
import 'package:loja/screens/home/home_screen.dart';
import 'package:loja/screens/produtos/produtos_screen.dart';

import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __) {
          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              HomeScreen(),
              ProdutoScreen(),
              Scaffold(
                drawer: CustomDrawer(),
                appBar: AppBar(
                  title: const Text('Home 3'),
                ),
              ),
              Scaffold(
                drawer: CustomDrawer(),
                appBar: AppBar(
                  title: const Text('Home 4'),
                ),
              ),
              if (userManager.adminEnabled) ...{
                AdminUsersScreen(),
                Scaffold(
                  drawer: CustomDrawer(),
                  appBar: AppBar(
                    title: const Text('Pedidos'),
                  ),
                ),
              }
            ],
          );
        },
      ),
    );
  }
}
