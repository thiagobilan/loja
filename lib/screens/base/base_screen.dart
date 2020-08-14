import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: <Widget>[
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
