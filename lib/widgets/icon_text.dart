import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  const IconText({
    Key? key,
    required this.label,
    this.icon,
  }) : super(key: key);

  final Text label;
  final Icon? icon;

  const factory IconText.icon({
    Key? key,
    required Text label,
    Icon? icon,
  }) = IconText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (icon != null) icon!,
        Padding(padding: const EdgeInsets.fromLTRB(2,0,8,0), child: label),
      ],
    );
  }
}
