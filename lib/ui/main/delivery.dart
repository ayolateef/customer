import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:courierx/main.dart';
import 'package:courierx/services/pickup/requestpickup.dart';
import 'package:courierx/widget/iCard27.dart';
import 'package:courierx/widget/ibutton.dart';
import 'package:courierx/widget/iinputField2.dart';
import 'package:courierx/model/account.dart';
import 'package:courierx/services/RestData/RestDataServices.dart';
import 'package:courierx/view_models/createaccount.dart';
import 'package:provider/provider.dart';
import 'package:courierx/ui/widgets/iinputField3.dart';
import 'package:courierx/model/pickorders.dart';
import 'package:courierx/view_models/accountviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:courierx/widget/button.dart';
import 'package:courierx/widget/easyDialog2.dart';
import '../../servicelocator.dart';

import 'package:courierx/widget/ibutton2.dart';

class DeliveryScreen extends StatefulWidget {
  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen>
    with SingleTickerProviderStateMixin {
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  // User press "Continue" button
  //
  //
  RequestPickup requestPickup = serviceLocator<RequestPickup>();
  late Account account;
  late Pickorders pickorders;
  RestDataService _restdataService = serviceLocator<RestDataService>();
  CreateAccountViewModel _accountViewModel =
      serviceLocator<CreateAccountViewModel>();

  void didChangeDependencies() {
    account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account!;
    pickorders =
        Provider.of<AccountViewModel>(context, listen: false).pickuporder;
     debugPrint('delivery didchange long2 ${pickorders.long2}');
    _getamount();
    pickorders.setMail(account.email);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<AccountViewModel>(context, listen: false).pickupset(
          pickorders);
    });print("Distance here is -  ${pickorders.distance},");
    int stagevalue =
        Provider.of<AccountViewModel>(context, listen: false).stage;
    print(stagevalue);
    if (stagevalue == 3) {
      stage = 3;
    }

    super.didChangeDependencies();
  }

  _pressContinueButton() async {
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;
    if (stage == 3)
      new Future.delayed(const Duration(seconds: 6), () {
        route.push(context, "/main");
      });
    if (stage == 2) stage = 3;

    if (stage == 1) {

        print("User pressed \"Continue\" button");
       print(amount);
        Pickorders pickup = await requestPickup.addNewPrice(
            token, pickorders, amount, editControllerComments.text);
        pickorders = pickup;
        print("delivery presscontinuebutton: ${pickorders.amount}");
        print("delivery presscontinuebutton pickorders.packaegs: ${pickorders.packages}");

        Provider.of<AccountViewModel>(context, listen: false).pickupset(pickup);

        stage = 2;


    }
    // new Future.delayed(const Duration(seconds: 3), () {
    setState(() {});
    // });
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  int stage = 1;
  double windowWidth = 0.0;
  double windowHeight = 0.0;
  final editControllerAddress1 = TextEditingController();
  final editControllerComments = TextEditingController();
  final editControllerCity = TextEditingController();
  final editControllerEmail = TextEditingController();
  final editControllerPhone = TextEditingController();
  late String amount;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    editControllerAddress1.dispose();
    editControllerComments.dispose();
    editControllerCity.dispose();
    editControllerEmail.dispose();
    editControllerPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: theme.colorBackground,
        body: Stack(
          children: <Widget>[
            Align(
                child: Container(
              child: ListView(
                children: _getList(),
              ),
            )),
            IEasyDialog2(
              setPosition: (double value) {
                _show = value;
              },
              getPosition: () {
                return _show;
              },
              color: theme.colorGrey,
              body: _dialogBody,
              backgroundColor: theme.colorBackground,
            ),
          ],
        ));
  }

  double _show = 0;
  Widget _dialogBody = Container();

  _getamount() {
    double sudoAmount = (pickorders.distance! * 0.2);
    double vatAmount = sudoAmount * 0.075;
    int nextSudo = (vatAmount + sudoAmount).round();

    if ( nextSudo % 10 != 0 ){
      int x = nextSudo % 10;
      int y = 10 - x;
      nextSudo = nextSudo + y;
    }

    amount = (500+nextSudo).toString();

  }

  _openPaymentDialog() {
    _dialogBody = Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Center(child: Text("Payment methods")),
                  SizedBox(
                    height: 20,
                  ),
                  Button(
                      child: Text(
                        "Pay via Debit Card",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onClick: () =>
                          Navigator.pushNamed(context, "/checkOutMethodCard")),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // Button(
                  //     child: Text(
                  //       "Pay via Bank)",
                  //       style: TextStyle(
                  //           color: Colors.white, fontWeight: FontWeight.bold),
                  //     ),
                  //     onClick: () =>
                  //         Navigator.pushNamed(context, "/checkOutMethodBank")),
                ],
              ),
            ), // "Reason to Reject",
            // "User Name",

            SizedBox(
              width: 10,
            ),
            IButton2(
                color: Colors.red,
                text: strings.get(135)!, // Cancel
                textStyle: theme.text14boldWhite,
                pressButton: () {
                  setState(() {
                    _show = 0;
                  });
                }),
          ],
        ));

    setState(() {
      _show = 1;
    });
  }

  _onDeliveryPayment() async {
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;

    Pickorders pickup =
        await requestPickup.addNewPaymentdelivery(token, pickorders);
    print("delivery _onDeliveryPayment: ${pickorders.amount}");

    Provider.of<AccountViewModel>(context, listen: false).pickupset(pickup);
    // print("delivery done");
    new Future.delayed(const Duration(seconds: 5), () {
      print("delivery done");
    });
  }

  _getList() {
    var list = <Widget>[];

    list.add(ICard27(
      colorActive: theme.colorPrimary,
      colorInactive: theme.colorDefaultText.withOpacity(0.5),
      stage: stage,
    ));
    list.add(SizedBox(
      height: 30,
    ));
    list.add(Container(
      height: 1,
      color: theme.colorGrey,
    ));
    list.add(SizedBox(
      height: 30,
    ));

    if (stage == 1) {
      _body(list);
      list.add(SizedBox(
        height: 50,
      ));
      list.add(_button());
    }

    if (stage == 2) {
      list.add(_item("assets/payment1.png", 1)); // cache on delivery
      list.add(SizedBox(
        height: 10,
      ));
      // list.add(_item("assets/payment3.png", 2)); // stripe
      // list.add(SizedBox(
      //   height: 10,
      // ));
      // list.add(_item("assets/payment4.png", 3)); //razorpay
      // list.add(SizedBox(
      //   height: 10,
      // ));
      list.add(_item("assets/paystack.png", 4)); // paystack
      list.add(SizedBox(
        height: 30,
      ));
      list.add(_button());
    }

    if (stage == 3) {
      list.add(
        UnconstrainedBox(
            child: Container(
                height: windowWidth * 0.4,
                width: windowWidth * 0.8,
                child:
                    Image.asset("assets/success2.png", fit: BoxFit.contain))),
      );

      list.add(Container(
          alignment: Alignment.center,
          child: Text(
            strings.get(126)!,
            style: theme.text16bold,
          ))); // You Payment Receive to Seller
      list.add(SizedBox(
        height: windowWidth * 0.2,
      ));
      list.add(_button());
    }

    return list;
  }

  var _currVal = 0;
  _onPayment(int i) {
    if (i == 1) {
      _onDeliveryPayment();
    }
    if (i == 4) {
      _openPaymentDialog();
    }
  }

  _item(String image, int index) {
    return Container(
        color: theme.colorBackgroundGray,
        child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Container(
                        child: RadioListTile(
                  activeColor: theme.colorDefaultText,
                  title: Container(
                      alignment: Alignment.centerLeft,
                      child: UnconstrainedBox(
                          child: Container(
                              height: windowWidth * 0.2,
                              width: windowWidth * 0.30,
                              child: Container(
                                child: Image.asset(image, fit: BoxFit.contain),
                              )))),
                  groupValue: _currVal,
                  value: index,
                  onChanged: (val) {
                    _onPayment(val as int);
                    setState(() {
                      _currVal = val;
                      //_itemSelect();
                    });
                  },
                ))),
              ],
            )));
  }

  _body(List<Widget> list) {
    list.add(Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: IInputField3(
        hint: pickorders.youurlocation!, // "Address 1"
        icon: Icons.location_on,
        controller: editControllerAddress1,
        colorDefaultText: theme.colorPrimary,
        colorBackground: theme.colorBackgroundDialog,
        type: TextInputType.text, onChangeText: (String ) {  }, onPressRightIcon: () {  },
      ),
    ));

    list.add(Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: IInputField3(
        hint: pickorders.packages!, // City
        icon: Icons.location_city,
        controller: editControllerCity,
        type: TextInputType.text,
        colorDefaultText: theme.colorPrimary,
        colorBackground: theme.colorBackgroundDialog, onChangeText: (String ) {  }, onPressRightIcon: () {  },
      ),
    ));

    list.add(Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: IInputField3(
        hint: "$amount (7.5% VAT included)", // Phone",
        icon: Icons.account_balance_wallet_sharp,
        controller: editControllerPhone,
        type: TextInputType.phone,
        colorDefaultText: theme.colorPrimary,
        colorBackground: theme.colorBackgroundDialog, onChangeText: (String ) {  }, onPressRightIcon: () {  },
      ),
    ));

    list.add(Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: IInputField3(
        hint: strings.get(125)!, // Comments",
        icon: Icons.chat,
        controller: editControllerComments,
        type: TextInputType.text,
        colorDefaultText: theme.colorPrimary,
        colorBackground: theme.colorBackgroundDialog, onChangeText: (String ) {  }, onPressRightIcon: () {  },
      ),
    ));

    list.add(SizedBox(
      height: 30,
    ));
  }

  _button() {
    return Container(
      margin:
          EdgeInsets.only(left: windowWidth * 0.15, right: windowWidth * 0.15),
      child: IButton(
        pressButton: _pressContinueButton,
        text: (stage == 3)
            ? strings.get(118)!
            : strings.get(18)!, // Done or Continue
        color: theme.colorPrimary,
        textStyle: theme.text16boldWhite,
      ),
    );
  }
}
