import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {
  final String search;
  const SearchDialog(this.search);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 2,
          left: 4,
          right: 4,
          child: Card(
            child: TextFormField(
              initialValue: search,
              textInputAction: TextInputAction.search,
              autofocus: true,
              autocorrect: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                prefixIcon: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.grey[700],
                ),
              ),
              onFieldSubmitted: (value) {
                Navigator.of(context).pop(value);
              },
            ),
          ),
        )
      ],
    );
  }
}
