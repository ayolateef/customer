import 'package:flutter/material.dart';
import 'package:courierx/view_models/accountviewmodel.dart';
import 'package:provider/provider.dart';

class MeansTransportMenu extends StatefulWidget {
  @override
  _MeansTransportMenuState createState() => _MeansTransportMenuState();
}

class _MeansTransportMenuState extends State {
  final List menuItems = [
    {'time': 'Food Item', 'icon': Icons.fastfood_sharp},
    {'time': 'Document', 'icon': Icons.file_present},
    {'time': 'Equipment', 'icon': Icons.settings},
    {'time': 'Accessories', 'icon': Icons.tapas_sharp},
  ];
  String _option = "";
  String get option => _option;

  int _a = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(menuItems.length, (f) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _a = f;
                _option = menuItems[f]['time'];
                Provider.of<AccountViewModel>(context, listen: false)
                    .setoption(_option);
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 9.0),
              margin: EdgeInsets.symmetric(horizontal: 2.0),
              decoration: BoxDecoration(
                color: _a == f ? Color(0xff02aefe) : Color(0xfffafbfc),
                border: _a == f ? Border() : Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(9.0),
                boxShadow: _a == f
                    ? [
                        BoxShadow(
                            blurRadius: 9.0,
                            color: Color(0xff02aefe),
                            offset: Offset(0, 3))
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    menuItems[f]['icon'],
                    color: _a == f ? Colors.white : Color(0xffa7b7c5),
                    size: 15,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                      child: Text(
                    "${menuItems[f]['time']}",
                    style: TextStyle(
                      color: _a == f ? Colors.white : Color(0xffa7b7c5),
                    ),
                  ))
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
