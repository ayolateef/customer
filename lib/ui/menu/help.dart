import 'package:flutter/material.dart';
import 'package:courierx/main.dart';
import 'package:courierx/ui/main/header.dart';
import 'package:courierx/widget/ibackground3.dart';
import 'package:courierx/widget/icard7.dart';

class HelpScreen extends StatefulWidget {
  final String? title;
  HelpScreen({Key? key, this.title}) : super(key: key);
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> with TickerProviderStateMixin {
  ///////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  _tabIndexChanged() {
    // print("Tab index is changed. New index: ${_tabController.index}");
  }

  //
  //
  //
  ///////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  // TabController _tabController;

  @override
  void initState() {
    // _tabController = TabController(vsync: this, length: 1);
    // _tabController.addListener(_tabIndexChanged);
    super.initState();
  }

  @override
  void dispose() {
    route.disposeLast();
    // _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    var topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: theme.colorBackground,
      body: Stack(
        children: <Widget>[
          Container(
              width: windowWidth,
              height: windowHeight * 0.2,
              child: IBackground4(
                  width: windowWidth, colorsGradient: theme.colorsGradient)),
          Container(
              margin: EdgeInsets.only(
                top: windowHeight * 0.2 + 15,
                left: windowWidth > 800 ? windowWidth * 0.1 : 10,
                right: windowWidth > 800 ? windowWidth * 0.1 : 10,
              ),
              child: Container(
                child: ListView(
                  children: _getList(),
                ),
              ),),
          Container(
              margin: EdgeInsets.only(top: topPadding),
              height: 40,
              child: Header(
                nomenu: true,
                transparent: true,
                white: true,
                onMenuClick: () {},
              )),
        ],
      ),
    );
  }

  List<Widget> _getList() {
    var list = <Widget>[];

    list.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
            height: 50,
            width: 50,
            child: Image.asset("assets/logo.png",fit: BoxFit.contain,)),
        // SizedBox(
        //   width: 20,
        // ),
        // Icon(Icons.help_outline),
        // SizedBox(
        //   width: 10,
        // ),
        // Text(strings.get(51), style: theme.text20bold), // "Help & support",
      ],
    ));

    list.add(SizedBox(
      height: 25,
    ));
    list.add(_item(strings.get(0)!, strings.get(1)!));
    list.add(_item(strings.get(2)!, strings.get(3)!));


    return list;
  }

  _item(String _title, String _body) {
    return ICard7(
      color: theme.colorPrimary,
      title: _title,
      titleStyle: theme.text18bold,
      body: _body,
      bodyStyle: theme.text14bold,
    );
  }
}
