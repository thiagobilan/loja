import 'package:flutter/material.dart';
import 'package:loja/models/admin_users_manager.dart';
import 'package:loja/models/cart_manager.dart';
import 'package:loja/models/home_manager.dart';
import 'package:loja/models/product_manager.dart';
import 'package:loja/models/produtos.dart';
import 'package:loja/models/user_manager.dart';
import 'package:loja/screens/base/base_screen.dart';
import 'package:loja/screens/cadastro/cadastro_screen.dart';
import 'package:loja/screens/carrinho/cart_screen.dart';
import 'package:loja/screens/edit_products/edit_product_screen.dart';
import 'package:loja/screens/login/login_screen.dart';
import 'package:loja/screens/produto/product_screen.dart';
import 'package:loja/screens/address/address_screen.dart';
import 'package:loja/screens/select_product/select_product_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          update: (_, userManager, cartManager) =>
              cartManager..updateUser(userManager),
          create: (context) => CartManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          update: (_, userManager, adminUsersManager) =>
              adminUsersManager..updateUser(userManager),
          create: (_) => AdminUsersManager(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'Loja Thiago',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 4, 125, 141),
          scaffoldBackgroundColor: const Color.fromARGB(255, 4, 125, 141),
          appBarTheme: const AppBarTheme(
            elevation: 0,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/base',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/base':
              return MaterialPageRoute(
                builder: (_) => BaseScreen(),
              );

            case '/cadastro':
              return MaterialPageRoute(
                builder: (_) => CadastroScreen(),
              );
            case '/login':
              return MaterialPageRoute(
                builder: (_) => LoginScreen(),
              );

            case '/produto':
              return MaterialPageRoute(
                builder: (_) => ProductScreen(settings.arguments as Produto),
              );
            case '/carrinho':
              return MaterialPageRoute(
                builder: (_) => CartScreen(),
              );
            case '/address':
              return MaterialPageRoute(
                builder: (_) => AddressScreen(),
              );
            case '/select_product':
              return MaterialPageRoute(
                builder: (_) => SelectProductScreeen(),
              );
            case '/edit_product':
              return MaterialPageRoute(
                builder: (_) =>
                    EditProductScreen(settings.arguments as Produto),
              );
            default:
              return MaterialPageRoute(
                builder: (_) => BaseScreen(),
              );
          }
        },
      ),
    );
  }
}
