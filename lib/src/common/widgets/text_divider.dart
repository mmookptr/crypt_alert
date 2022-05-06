import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  const TextDivider({
    Key? key,
    this.height = 3,
    this.color = Colors.black54,
    required this.label,
  }) : super(key: key);

  final String label;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 15.0),
            child: Divider(
              color: color,
              height: height,
            )),
      ),
      Text(
        label,
        style: const TextStyle(color: Colors.black54),
      ),
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: Divider(
              color: color,
              height: height,
            )),
      ),
    ]);
  }
}
