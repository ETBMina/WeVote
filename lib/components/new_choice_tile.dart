import 'package:flutter/material.dart';

class NewChoiceTile extends StatelessWidget {
  String title;

  NewChoiceTile(this.title);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Text(title),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(),
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.remove_circle),
        color: Colors.deepOrange,
        tooltip: 'Remove Choice',
        onPressed: () {},
      ),
    );
  }
}
