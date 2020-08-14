import 'package:flutter/material.dart';
import 'package:loja/common/custom_drawer/custom_drawer.dart';

class BaseScreen extends StatelessWidget {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: <Widget>[
        Scaffold(
          drawer: CustomDrawer(),
          appBar: AppBar(
            title: const Text('Home'),
          ),
        ),
        Container(
          color: Colors.red,
          child: RaisedButton(
            onPressed: () {
              pageController.jumpToPage(1);
            },
            child: const Text('Proximo'),
          ),
        ),
        Container(
          color: Colors.yellow,
        ),
        Container(
          color: Colors.green,
        ),
      ],
    );
  }
}
