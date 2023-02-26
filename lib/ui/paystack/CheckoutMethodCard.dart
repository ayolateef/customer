import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:courierx/utils/hexToColor.dart';
import 'package:courierx/widget/button.dart';
import 'package:provider/provider.dart';
import 'package:courierx/ui/main/delivery.dart';
import 'package:courierx/view_models/accountviewmodel.dart';
import 'package:courierx/model/pickorders.dart';
import 'package:courierx/view_models/createaccount.dart';
import 'package:courierx/services/pickup/requestpickup.dart';

import 'package:courierx/model/account.dart';
import '../../servicelocator.dart';

class CheckoutMethodCard extends StatefulWidget {
  @override
  _CheckoutMethodCardState createState() => _CheckoutMethodCardState();
}

// Pay public key
class _CheckoutMethodCardState extends State<CheckoutMethodCard> {
  RequestPickup requestPickup = serviceLocator<RequestPickup>();
  final instance = new PaystackPlugin();

  @override
  void initState() {
    instance.initialize(
        publicKey: "pk_test_b485dc37becea4ef0798096d41372b1d1493cc06");
    super.initState();
  }

  _navigateToDelivery(BuildContext context) async {
    // Provider.of<AccountViewModel>(context, listen: false).setstagep(3);
    // String token =  Provider.of<CreateAccountViewModel>(context, listen: false).token;
    // Pickorders pickup = Provider.of<AccountViewModel>(context, listen: false).pickuporder;
    // requestPickup.addNewPaymentdone(token, pickup);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeliveryScreen()),
    );
    //refresh the state of your Widget
    //  setState(() {

    //  selectedObject = result;
    //    });
  }

  Dialog successDialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Container(
        height: 350.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _navigateToDelivery(context),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   child: _navigateToDelivery(context);
          // children: <Widget>[
          //   Icon(
          //     Icons.check_box,
          //     color: hexToColor("#41aa5e"),
          //     size: 90,
          //   ),
          //   SizedBox(height: 15),
          //   Text(
          //     'Payment has successfully',
          //     style: TextStyle(
          //         color: Colors.black,
          //         fontSize: 17.0,
          //         fontWeight: FontWeight.bold),
          //   ),
          //   Text(
          //     'been made',
          //     style: TextStyle(
          //         color: Colors.black,
          //         fontSize: 17.0,
          //         fontWeight: FontWeight.bold),
          //   ),
          //   SizedBox(height: 15),
          //   Text(
          //     "Your payment has been successfully",
          //     style: TextStyle(fontSize: 13),
          //   ),
          //   Text("processed.", style: TextStyle(fontSize: 13)),
          // ],
          // ),
        ),
      ),
    );
  }

  void _showDialog() {
    // flutter defined function
    Provider.of<AccountViewModel>(context, listen: false).setstagep(3);
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;
    Pickorders pickup =
        Provider.of<AccountViewModel>(context, listen: false).pickuporder;
    requestPickup.addNewPaymentdone(token, pickup);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeliveryScreen();
        //_navigateToDelivery(context);
      },
    );
  }

  Dialog errorDialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Container(
        height: 350.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.cancel,
                color: Colors.red,
                size: 90,
              ),
              SizedBox(height: 15),
              Text(
                'Failed to process payment',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                "Error in processing payment, please try again",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return errorDialog(context);
      },
    );
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  chargeCard() async {
    Account? account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account;
    Pickorders pickup =
        Provider.of<AccountViewModel>(context, listen: false).pickuporder;
    String email =
        Provider.of<CreateAccountViewModel>(context, listen: false).logonemail;
    debugPrint('checkoutmethodcard chargecard $email');
    String? str = pickup.amount;
    String amtprice = str!.replaceAll("N", "");
    int amt = int.parse(amtprice) *100;
    debugPrint('checkoutmethodcard chargecard $amt');

    Charge charge = Charge()
      ..amount = amt
      ..reference = _getReference()
      // or ..accessCode = _getAccessCodeFrmInitialization()
      ..email = account?.email;
    CheckoutResponse response = await instance.checkout(
      context,
      method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
      charge: charge,
    );
    if (response.status == true) {
      _showDialog();
      // _navigateToDelivery(context);
    } else {
      _showErrorDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pop up method",
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Button(
              child: Text(
                "Charge",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onClick: () => chargeCard(),
            ),
          )),
    );
  }
}
