import 'package:flutter/material.dart';

class EmptyCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const EmptyCard({Key key, this.title, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 80,
            color: Colors.white,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
