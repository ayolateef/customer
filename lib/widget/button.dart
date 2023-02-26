import 'package:flutter/material.dart';
import 'package:courierx/utils/hexToColor.dart';

import 'package:flutter/material.dart';
import 'package:courierx/main.dart';

class Button extends StatelessWidget {
  final Widget? child;
  final Function()? onClick;

  Button({this.child, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: Colors.black12),
      child: Material(
        color: theme.colorPrimary,
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
            onTap: onClick!,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}
