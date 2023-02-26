import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:courierx/main.dart';
import 'package:courierx/model/categories.dart';
import 'package:courierx/model/mostpopular.dart';
import 'package:courierx/ui/main/home.dart';
import 'package:courierx/ui/menu/menu.dart';
import 'package:courierx/widget/icard12.dart';
import 'package:courierx/widget/icard13.dart';
import 'package:courierx/widget/ilist1.dart';
import 'header.dart';

class CategoryDetailsScreen extends StatefulWidget {
  CategoryDetailsScreen({Key? key}) : super(key: key);
  @override
  _CategoryDetailsScreenState createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen>
    with SingleTickerProviderStateMixin {
  ///////////////////////////////////////////////////////////////////////////////
  //

  _onCategoriesClick(String id, String heroId) {
    print("User pressed Category item with id: $id");
    setState(() {
      _load(id);
      _controller.animateTo(0,
          duration: Duration(seconds: 1), curve: Curves.ease);
    });
  }

  _onDishesClick(String id, String heroId) {
    print("User pressed Most Popular item with id: $id");
    idHeroes = heroId;
    idDishes = id;
    route.setDuration(1);
    route.push(context, "/dishesdetails");
  }

  ///////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  var _controller = ScrollController();
  late Categories _this;

  _load(String id) {
    for (var item in categories) if (item.id == id) _this = item;
  }

  @override
  void initState() {
    _load(idCategory!);
    super.initState();
  }

  @override
  void dispose() {
    route.disposeLast();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        drawer: Menu(
          // ignore: non_constant_identifier_names
          context: context, callback: (String ) {  },
        ),
        backgroundColor: theme.colorBackground,
        body: NestedScrollView(
            controller: _controller,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: windowHeight * 0.35,
                  automaticallyImplyLeading: false,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: theme.colorPrimary,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: _imageBuild(),
                  ),
                  title: Container(
                      child: Header(
                          nomenu: true, white: true, transparent: true,
                          onMenuClick: () {},
                          ) // Home
                      ),
                )
              ];
            },
            body: Stack(
              children: <Widget>[
                Container(
                  child: _body(),
                ),
              ],
            )));
  }

  _body() {
    return Container(
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: _children(),
      ),
    );
  }

  _children() {
    var list = <Widget>[];

    list.add(SizedBox(
      height: 20,
    ));

    list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: IList1(
          imageAsset: "assets/orders.png",
          text: _this.text, // dish name
          textStyle: theme.text16bold,
          imageColor: theme.colorDefaultText),
    ));

    list.add(SizedBox(
      height: 20,
    ));

    list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Text(strings.get(0)!, style: theme.text14), // dish description
    ));

    list.add(SizedBox(
      height: 20,
    ));

    list.add(Container(
      margin: EdgeInsets.only(left: 20),
      child: IList1(
          imageAsset: "assets/categories.png",
          text: strings.get(41)!, // "Food categories",
          textStyle: theme.text16bold,
          imageColor: theme.colorDefaultText),
    ));

    list.add(SizedBox(
      height: 10,
    ));

    list.add(_horizontalCategories());

    list.add(SizedBox(
      height: 20,
    ));

    list.add(Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: IList1(
          imageAsset: "assets/top.png",
          text: strings.get(91)!, // Dishes
          textStyle: theme.text16bold,
          imageColor: theme.colorDefaultText),
    ));

    _mostPopular(list);
    _mostPopular(list);

    list.add(SizedBox(
      height: 20,
    ));

    return list;
  }

  _mostPopular(List<Widget> list) {
    var height = windowWidth * 0.5 * 0.8;

    bool first = true;
    Widget t1 = list.first;
    for (var item in mostPopular) {
      if (first) {
        t1 = ICard13(
          color: theme.colorBackground,
          text: item.text!,
          width: windowWidth * 0.5 - 15,
          height: height,
          image: item.image!,
          id: item.id!,
          stars: item.star!,
          colorStars: theme.colorPrimary,
          textStyle: theme.text16bold,
          callback: _onDishesClick,
        );
        first = false;
      } else {
        var t2 = ICard13(
          color: theme.colorBackground,
          text: item.text!,
          width: windowWidth * 0.5 - 15,
          height: height,
          image: item.image!,
          id: item.id!,
          stars: item.star!,
          colorStars: theme.colorPrimary,
          textStyle: theme.text16bold,
          callback: _onDishesClick,
        );
        list.add(Container(
          margin: EdgeInsets.only(left: 5, right: 5),
          child: Row(
            children: <Widget>[
              t1,
              SizedBox(
                width: 10,
              ),
              t2
            ],
          ),
        ));
        first = true;
      }
    }

    if (!first) {
      list.add(Container(
        margin: EdgeInsets.only(left: 5, right: 5),
        child: Row(
          children: <Widget>[
            t1,
            SizedBox(
              width: 10,
            ),
            Container(
              width: windowWidth * 0.5 - 15,
            )
          ],
        ),
      ));
    }
  }

  _imageBuild() {
    return Container(
        child: Hero(
      tag: idHeroes!,
      child: Image.asset(_this.image, fit: BoxFit.cover),
    ));
  }

  _horizontalCategories() {
    var list = <Widget>[];
    var height = windowWidth * 0.4 * 0.8;
    for (var item in categories) {
      list.add(ICard12(
        color: theme.colorBackground,
        text: item.text,
        width: windowWidth * 0.4,
        height: height,
        image: item.image,
        id: item.id,
        textStyle: theme.text16bold,
        callback: _onCategoriesClick,
      ));
      list.add(SizedBox(
        width: 10,
      ));
    }
    return Container(
      height: height + 20,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: list,
      ),
    );
  }
}
