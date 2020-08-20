import 'package:flutter/material.dart';
import 'package:loja/models/user_manager.dart';
import 'package:loja/screens/base/base_screen.dart';
import 'package:loja/screens/cadastro/cadastro_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserManager>(
      create: (context) => UserManager(),
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

            // case '/base':
            //   return MaterialPageRoute(
            //     builder: (_) => BaseScreen(),
            //   );
            default:
              return MaterialPageRoute(
                builder: (_) => CadastroScreen(),
              );
          }
        },
      ),
    );
  }
}
