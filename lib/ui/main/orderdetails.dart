import 'package:flutter/material.dart';
import 'package:courierx/main.dart';
import 'package:courierx/model/orders.dart';
import 'package:courierx/ui/main/header.dart';
import 'package:courierx/ui/main/home.dart';
import 'package:courierx/view_models/accountviewmodel.dart';
import 'package:courierx/widget/icard14.dart';
import 'package:provider/provider.dart';
import 'package:courierx/servicelocator.dart';
import 'package:courierx/view_models/createaccount.dart';
import 'package:courierx/model/account.dart';

import 'package:courierx/services/pickup/requestpickup.dart';
import 'package:courierx/model/pickorders.dart';

class OrderDetailsScreen extends StatefulWidget {
  OrderDetailsScreen({Key? key}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  double windowWidth = 0.0;
  double windowHeight = 0.0;
  late Orders orders1;
  String amount = '';
  var orders = [];
  RequestPickup requestPickup = serviceLocator<RequestPickup>();
  // ignore: deprecated_member_use
  List<Pickorders> pickup = <Pickorders>[];

  Future<Orders> _onPickuporders() async {
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;

    Account? account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account;
    pickup = await requestPickup.getorgers(token, account!.email);
    // print("got here now");
    // List<Orders> orders = List<Orders>();
    String id = Provider.of<AccountViewModel>(context, listen: false).ordersid;
    // print("id = ${id}");

    if (pickup.length > 0) {
      for (int i = 0; i < pickup.length; i++) {
        print(pickup[i].id.toString());
        String idcheck = pickup[i].id.toString();
        if (idcheck == id) {
          //  Map<String,dynamic> map = pickup[i];
          print(pickup[i].name);
          print(pickup[i].id);
          print(pickup[i].amount);
          print(pickup[i].date);

          orders1 = new Orders(
              image: "assets/b2.jpg",
              name: pickup[i].name,
              id: pickup[i].id.toString(),
              address: pickup[i].address,
              total: pickup[i].amount,
              date: pickup[i].date,
              payment: pickup[i].payment);
          // print(orders1);

          // _postList .add(Post.fromJson(map));
          // debugPrint('Id-------${map['id']}');
        }
      }
    }
    amount = orders1.total!;
    return orders1;
  }

  @override
  void dispose() {
    route.disposeLast();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _onPickuporders().then((orders) {
      setState(() {
        print("id = ${orders.id}");
        print("id = ${orders.date}");
        print("id = ${orders.payment}");
        this.orders1 = orders;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: theme.colorBackground,
        body: Stack(
          children: <Widget>[
            Container(
                margin:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Header(
                  title: strings.get(119) ?? "",
                  onMenuClick: () {},
                  nomenu: true,
                ) // "My Orders",
                ),
            Container(
              margin: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: MediaQuery.of(context).padding.top + 30),
              child: Container(
                child: ListView(
                  padding: EdgeInsets.only(top: 0),
                  children: _body(),
                ),
              ),
            )
          ],
        ));
  }

  _body() {
    var list = <Widget>[];
    var height = windowWidth * 0.3;

    // List<Orders> allorders =
    //     Provider.of<AccountViewModel>(context, listen: false).orders;
    // String id = Provider.of<AccountViewModel>(context, listen: false).ordersid;
    // for (int i = 0; i < allorders.length; i++) {
    //   print(allorders[i].name);
    //   if (allorders[i].id == id) {
    //     orders1 = allorders[i];
    //   }
    // }

    list.add(SizedBox(
      height: 20,
    ));

    for (var item in orders)
      if (item.id == idOrder)
        list.add(Container(
            margin: EdgeInsets.only(right: 10),
            child: ICard14(
              heroId: idHeroes!,
              color: theme.colorBackground,
              text: item.name,
              textStyle: theme.text16bold,
              text2: item.address,
              textStyle2: theme.text14,
              text3: item.date,
              textStyle3: theme.text14,
              text4: item.total,
              textStyle4: theme.text18boldPrimary,
              width: windowWidth,
              height: height,
              image: item.image,
              id: item.id, callback: (String id, String hero) {  },
            )));

    list.add(SizedBox(
      height: 35,
    ));
    if (orders == null) {
      _onPickuporders();
    }
    Orders ordertest =
        Provider.of<AccountViewModel>(context, listen: false).orders;
    String str = ordertest.date!;
    String date = str.replaceAll("WAT", "");
    bool stabool = false;
    bool devbool = false;
    if (ordertest.status == "3") {
      stabool = true;
    }
    if (ordertest.status == "4") {
      stabool = true;
      devbool = true;
    }

    list.add(Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order ID #$idOrder",
                style: theme.text18boldPrimary,
                overflow: TextOverflow.ellipsis,
              ),
              amount == ""
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                        color: Color(0xff009688),
                      ))
                  : Text(
                      '₦$amount',
                      // orders1.total == null ?  "":"₦${orders1.total}",
                      style: theme.text18boldPrimary,
                      overflow: TextOverflow.ellipsis,
                    ),
            ],
          ),
          Text(date),
        ],
      ),
    ));
    list.add(SizedBox(
      height: 15,
    ));
    list.add(
        _itemTextPastOrder("${strings.get(120)}", '', true)); // "Order placed",
    list.add(_divider());
    list.add(_itemTextPastOrder("${strings.get(121)} - ", ordertest.payment!,
        true)); // Payment verification
    list.add(_divider());
    list.add(_itemTextPastOrder("${strings.get(122)}", "", true)); // Processing
    list.add(_divider());
    list.add(
        _itemTextPastOrder("${strings.get(123)}", "", stabool)); // On the way
    list.add(_divider());
    list.add(
        _itemTextPastOrder("${strings.get(124)}", "", devbool)); // Delivery
    list.add(SizedBox(
      height: 5,
    ));

    return list;
  }

  _itemTextPastOrder(String leftText, String rightText, bool _delivery) {
    var _icon = Icon(Icons.check_circle, color: theme.colorPrimary, size: 30);
    if (!_delivery)
      _icon = Icon(
        Icons.history,
        color: theme.colorGrey,
        size: 30,
      );
    return Container(
        // margin: EdgeInsets.only(left: 20, right: 20),
        child: Row(
      children: <Widget>[
        _icon,
        SizedBox(
          width: 20,
        ),
        Text(
          leftText,
          style: theme.text14,
        ),
        Text(rightText, style: theme.text14, overflow: TextOverflow.ellipsis),
      ],
    ));
  }

  _divider() {
    return Align(
      alignment: Alignment.centerLeft,
      child: UnconstrainedBox(
        child: Container(
          margin: EdgeInsets.only(left: 35),
          alignment: Alignment.centerLeft,
          height: 30,
          width: 1,
          color: theme.colorDefaultText,
        ),
      ),
    );
  }
}
