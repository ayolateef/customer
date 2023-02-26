import 'package:flutter/material.dart';
import 'package:courierx/main.dart';
import 'package:courierx/model/orders.dart';
import 'package:courierx/ui/main/home.dart';
import 'package:courierx/widget/icard14.dart';
import 'package:courierx/widget/ilist1.dart';
import 'package:courierx/widget/isearch.dart';
import 'package:courierx/services/pickup/requestpickup.dart';
import 'package:provider/provider.dart';
import 'package:courierx/servicelocator.dart';
import 'package:courierx/view_models/accountviewmodel.dart';
import 'package:courierx/view_models/createaccount.dart';
import 'package:courierx/model/account.dart';

import 'package:courierx/model/pickorders.dart';

class OrdersScreen extends StatefulWidget {
  final Function(String)? callback;
  OrdersScreen({this.callback});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  RequestPickup requestPickup = serviceLocator<RequestPickup>();
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  List<Pickorders> pickup = <Pickorders>[];
  _onPressSearch(String query) {
    print("User search word: $query");
    List<Orders> dummySearchList = <Orders>[];
    dummySearchList.addAll(orders);
    if (query.isNotEmpty) {
      List<Orders> dummyListData = <Orders>[];
      dummySearchList.forEach((item) {
        if (item.name!.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        orders2.clear();
        orders2.addAll(dummyListData);
        print("orders lenght ${orders.length}");
      });
      return;
    } else {
      setState(() {
        orders2.clear();
        orders2.addAll(dummySearchList);
      });
    }

    if (query == "" || query == null) {
      setState(() {
        orders2.clear();
        orders2.addAll(dummySearchList);
        print("orders lenght ${orders.length}");
      });
    }
  }

  void didChangeDependencies() {
    //   _onPickuporders();

    super.didChangeDependencies();
  }

  List<Orders> orders = <Orders>[];
  List<Orders> orders2 = <Orders>[];
  Future<List<Orders>> _onPickuporders() async {
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;

    Account? account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account;
    pickup = await requestPickup.getorgers(token, account!.email);
    print("got here orders length - ${pickup.length}");

    if (pickup.length > 0) {
      for (int i = 0; i < pickup.length; i++) {
        if (pickup[i].payment == "Paid" ||
            pickup[i].payment == "Pay on Delivery") {
          //  Map<String,dynamic> map = pickup[i];
          print(pickup[i].name);
          print(pickup[i].id);
          print(pickup[i].amount);
          print(pickup[i].date);

          orders.add(
            Orders(
                image: "assets/b2.jpg",
                name: pickup[i].name,
                id: pickup[i].id.toString(),
                address: pickup[i].address,
                total: pickup[i].amount,
                date: pickup[i].date,
                payment: pickup[i].payment,
                status: pickup[i].statno.toString()),
          );

          // _postList .add(Post.fromJson(map));
          // debugPrint('Id-------${map['id']}');
        }
      }
    }
    orders2.addAll(orders);

    return orders;
  }

  _onItemClick(String id, String heroId) {
    print("User pressed item with id: $id");
    idOrder = id;
    idHeroes = heroId;

    if (orders.length > 0) {
      for (int i = 0; i < orders.length; i++) {
        print(orders[i].id.toString());
        String? idcheck = orders[i].id;
        if (idcheck == id) {
          //  Map<String,dynamic> map = pickup[i];
          print(orders[i].name);
          // print(orders[i].id);
          // print(pickup[i].amount);
          // print(pickup[i].date);

          Orders order = new Orders(
              image: "assets/b2.jpg",
              name: orders[i].name,
              id: orders[i].id,
              address: orders[i].address,
              total: orders[i].total,
              date: orders[i].date,
              payment: orders[i].payment,
              status: orders[i].status);
          print(order);

          Provider.of<AccountViewModel>(context, listen: false).orderset(order);
          // _postList .add(Post.fromJson(map));
          // debugPrint('Id-------${map['id']}');
        }
      }
    }
    Provider.of<AccountViewModel>(context, listen: false).orderidset(idOrder!);
    // Provider.of<AccountViewModel>(context, listen: false).setpayment(payment);
    // Provider.of<AccountViewModel>(context, listen: false).setdate(text3);
    // new Future.delayed(const Duration(seconds: 3), () {
    route.setDuration(7);
    route.push(context, "/orderdetails");

    //  });
  }

  @override
  void initState() {
    // TODO: implement initState
    _onPickuporders().then((orders) {
      setState(() {
        this.orders = orders;
        // orders2.addAll(orders);
      });
    });

    super.initState();
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 50),
        child: ListView(
            padding: EdgeInsets.only(top: 0, left: 15, right: 15),
            shrinkWrap: true,
            children: _children()));
  }

  _children() {
    var list = <Widget>[];

    list.add(Container(
      margin: EdgeInsets.only(
          top: 10, right: windowWidth > 800 ? windowWidth * 0.4 : 10),
      child: ISearch(
        hint: strings.get(34)!, // "Search",
        icon: Icons.search,
        onChangeText: _onPressSearch,
        colorDefaultText: theme.colorDefaultText,
        colorBackground: theme.colorBackground,
      ),
    ));

    list.add(SizedBox(
      height: 20,
    ));

    list.add(Container(
        //margin: EdgeInsets.only(left: 10, right: 10),
        child: IList1(
      imageAsset: "assets/list.png",
      text: strings.get(36)!, // "My Orders",
      textStyle: theme.text16bold,
      imageColor: theme.colorDefaultText,
    )));

    list.add(SizedBox(
      height: 10,
    ));
    if (orders == null) {
    } else {
      _list(list);
    }

    list.add(SizedBox(
      height: 200,
    ));

    return list;
  }

  _list(List<Widget> list) {
    var height = windowWidth > 800 ? 400 * 0.3 : windowWidth * 0.3;
    for (var item in orders2) {
      // Provider.of<AccountViewModel>(context, listen: false).orderset(item);
      list.add(Container(
          //margin: EdgeInsets.only(right: 10),
          child: ICard14(
        color: theme.colorBackgroundDialog,
        text: item.name!,
        textStyle: theme.text16bold,
        text2: item.address!,
        textStyle2: theme.text14,
        text3: item.date!,
        textStyle3: theme.text14,
        text4: "₦${item.total}",
        textStyle4: theme.text18boldPrimary,
        width: windowWidth,
        height: height,
        image: item.image!,
        id: item.id!,
        payment: item.payment!,
        callback: _onItemClick,
      )));
    }
  }
}
