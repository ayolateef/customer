import 'package:flutter/material.dart';
import 'package:courierx/ui/login/createaccount.dart';
import 'package:courierx/ui/login/forgot.dart';
import 'package:courierx/ui/login/login.dart';
import 'package:courierx/ui/login/sendphone.dart';
import 'package:courierx/ui/login/verifyphone.dart';
import 'package:courierx/ui/main/basket.dart';
import 'package:courierx/ui/main/categoryDetails.dart';
import 'package:courierx/ui/main/delivery.dart';
import 'package:courierx/ui/main/dishesDetails.dart';
import 'package:courierx/ui/main/mainscreen.dart';

import 'package:courierx/ui/main/pickuporderm.dart';
import 'package:courierx/ui/main/notification.dart';
import 'package:courierx/ui/main/orderdetails.dart';
import 'package:courierx/ui/main/payment.dart';
import 'package:courierx/ui/main/restaurantDetails.dart';
import 'package:courierx/ui/menu/help.dart';
import 'package:courierx/ui/menu/language.dart';
import 'package:courierx/ui/menu/termofservice.dart';
import 'package:courierx/ui/start/onboard.dart';
import 'package:courierx/ui/paystack/CheckoutMethodBank.dart';
import 'package:courierx/ui/paystack/CheckoutMethodCard.dart';
import 'package:courierx/ui/paystack/CheckoutMethodSelectable.dart';
import 'package:courierx/ui/paystack/CheckoutMethodUI.dart';

class AppFoodRoute {
  Map<String, StatefulWidget> routes = {
    "/onboard": OnBoardingScreen(),
    "/login": LoginScreen(),
    "/forgot": ForgotScreen(),
    "/createaccount": CreateAccountScreen(),
    "/sendphone": SendPhoneNumberScreen(),
    "/verifyphone": VerifyPhoneNumberScreen(),
    "/main": MainScreen(),
    "/notify": NotificationScreen(),
    "/language": LanguageScreen(),
    "/help": HelpScreen(),
    "/term": TermOfServiceScreen(),
    "/dishesdetails": DishesDetailsScreen(),
    "/restaurantdetails": RestaurantDetailsScreen(),
    "/categorydetails": CategoryDetailsScreen(),
    "/basket": BasketScreen(),
    "/delivery": DeliveryScreen(),
    "/payment": PaymentScreen(),
    "/orderdetails": OrderDetailsScreen(),
    "/makeadelivery": MakeADeliveryScreen(),
  };

  late MainScreen mainScreen;
  List<StatefulWidget> _stack = <StatefulWidget>[];

  int _seconds = 0;

  disposeLast() {
    if (_stack.isNotEmpty) _stack.removeLast();
    _printStack();
  }

  setDuration(int seconds) {
    _seconds = seconds;
  }

  pushLanguage(BuildContext _context, Function()? callback) {
    var _screen = LanguageScreen(callback: callback);
    _stack.add(_screen);
    _printStack();
    Navigator.push(
      _context,
      PageRouteBuilder(
        transitionDuration: Duration(seconds: _seconds),
        pageBuilder: (_, __, ___) => _screen,
      ),
    );
    _seconds = 0;
  }

  push(BuildContext _context, String name) {
    var _screen = routes[name];
    if (name == "/main") mainScreen = _screen as MainScreen;
    _stack.add(_screen!);
    _printStack();
    Navigator.push(
      _context,
      PageRouteBuilder(
        transitionDuration: Duration(seconds: _seconds),
        pageBuilder: (_, __, ___) => _screen,
      ),
    );
    _seconds = 0;
  }

  pushToStart(BuildContext _context, String name) {
    var _screen = routes[name];
    if (name == "/main") mainScreen = _screen as MainScreen;;
    _stack.clear();
    _stack.add(_screen!);
    _printStack();
    Navigator.pushAndRemoveUntil(
        _context,
        PageRouteBuilder(
          transitionDuration: Duration(seconds: _seconds),
          pageBuilder: (_, __, ___) => _screen,
        ),
        (route) => route == null);
    _seconds = 0;
  }

  _printStack() {
    var str = "Screens Stack: ";
    for (var item in _stack) str = "$str -> $item";
    print(str);
  }

  pop(BuildContext context) {
    Navigator.pop(context);
  }

  popToMain(BuildContext context) {
    var _lenght = _stack.length;
    for (int i = 0; i < _lenght - 1; i++) {
      pop(context);
    }
  }
}
