import 'package:courierx/services/notification_services.dart';
import 'package:courierx/ui/main/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:courierx/route.dart';
import 'package:courierx/config/theme.dart';
import 'package:courierx/ui/login/login.dart';
import 'package:courierx/ui/start/splash.dart';
import 'package:courierx/data/rest_data.dart';
import 'package:courierx/servicelocator.dart';
import 'package:courierx/services/RestData/RestDataServices.dart';
import 'package:courierx/view_models/accountviewmodel.dart';
import 'package:courierx/view_models/createaccount.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/lang.dart';
import 'package:courierx/ui/paystack/CheckoutMethodBank.dart';
import 'package:courierx/ui/paystack/CheckoutMethodCard.dart';
import 'package:courierx/ui/paystack/CheckoutMethodSelectable.dart';
import 'package:courierx/ui/paystack/CheckoutMethodUI.dart';

//
// Theme
//
AppThemeData theme = AppThemeData();
RestDataImpl tryrest = RestDataImpl();
//
// Language data
//
Lang strings = Lang();
//
// Routes
//
AppFoodRoute route = AppFoodRoute();
//
// Account

//
RestDataService _restdataService = serviceLocator<RestDataService>();
CreateAccountViewModel _accountcreateService =
    serviceLocator<CreateAccountViewModel>();

String username = _accountcreateService.logonusername;

String? password;
// void print(username) {
//   print(" -  ---- ");
//   print(username);
// }

//print(username);
//Account test = await tryrest.getloggedin(username);
//Account account = _restdataService.getloggedaccount(username);
// print(accounts);
// bool langCheck = false;

void main() async {
  theme.init();
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await Firebase.initializeApp();
  setupServiceLocator();
  SharedPreferences pref = await SharedPreferences.getInstance();
  int? language = pref.getInt('language');
  if (language != null) {
    strings.setLang(language);
  } else {
    strings.setLang(Lang.english); // set default language - English
  }

  runApp(Appcourierx());
}

class Appcourierx extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _theme = ThemeData(
      fontFamily: 'Raleway',
      primarySwatch: theme.primarySwatch,
    );

    if (theme.darkMode) {
      _theme = ThemeData(
        fontFamily: 'Raleway',
        brightness: Brightness.dark,
        unselectedWidgetColor: Colors.white,
        primarySwatch: theme.primarySwatch,
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CreateAccountViewModel()),
        ChangeNotifierProvider(create: (_) => AccountViewModel()),
      ],
      child: MaterialApp(
        title: strings.get(10)!,
        // "Food Delivery Flutter App UI Kit",
        debugShowCheckedModeBanner: false,
        theme: _theme,
        initialRoute: '/splash',
        //initialRoute: '/login',
        routes: {
          '/splash': (BuildContext context) => SplashScreen(),
          '/login': (BuildContext context) => LoginScreen(),
          '/main': (BuildContext context) => MainScreen(),
          "/checkOutMethodCard": (BuildContext context) => CheckoutMethodCard(),
          "/checkOutMethodSelectedable": (BuildContext context) =>
              CheckoutMethodSelectable(),
          "/checkOutMethodBank": (BuildContext context) => CheckoutMethodBank(),
          "/checkOutMethodUI": (BuildContext context) => CheckoutMethodUI(),
        },
      ),
    );
  }
}
