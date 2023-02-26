import 'package:flutter/material.dart';
import 'package:courierx/data/rest_data.dart';
import 'package:courierx/main.dart';
import 'package:courierx/services/RestData/RestDataServices.dart';
import 'package:courierx/view_models/accountviewmodel.dart';
import 'package:courierx/view_models/createaccount.dart';
import 'package:courierx/widget/ibackground3.dart';
import 'package:courierx/widget/ibox.dart';
import 'package:courierx/widget/ibutton.dart';
import 'package:courierx/widget/iinputField2.dart';
import 'package:courierx/widget/iinputField2Password.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../servicelocator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  RestDataService restdataServices = serviceLocator<RestDataService>();
  bool _isLoading = false;
  bool credCheck = false;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  _pressLoginButton() async {
    print("User pressed \"LOGIN\" button");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result;
    Provider.of<AccountViewModel>(context, listen: false).setoption("Bike");
    setState(() {
      _isLoading = true;
    });

    Future<String> users = restdataServices
        .login(editControllerName.text, editControllerPassword.text)
        .then((value) async {
      result = value;
      //  _showSnackBar(result);
      if (result != null && result != "failed") {
        Provider.of<CreateAccountViewModel>(context, listen: false)
            .tokenset(result);
        print(result);
        Provider.of<CreateAccountViewModel>(context, listen: false)
            .usernameset(editControllerName.text);
        String username =
            Provider.of<CreateAccountViewModel>(context, listen: false)
                .logonusername;
        credCheck =
            await Provider.of<CreateAccountViewModel>(context, listen: false)
                .accounts(username);
        if (credCheck) {
          prefs.setString('username', username);
          prefs.setString('password', editControllerPassword.text);
          new Future.delayed(const Duration(seconds: 6), () {
            Navigator.pushNamedAndRemoveUntil(context, "/main", (r) => false);
          });
        } else {
          Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
          String text = "username/password is incorrect";
          _showSnackBar(text);
        }
      } else {
        String text = "username/password is incorrect";
        _showSnackBar(text);
        setState(() {
          _isLoading = false;
        });
      }

      return result;
    });
    print(users);

    print(
        "Login: ${editControllerName.text}, password: ${editControllerPassword.text}");
    // route.pushToStart(context, "/main");
  }

  _pressDontHaveAccountButton() {
    print("User press \"Don't have account\" button");
    route.push(context, "/createaccount");
  }

  _pressForgotPasswordButton() {
    print("User press \"Forgot password\" button");
    route.push(context, "/forgot");
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  final editControllerName = TextEditingController();
  final editControllerPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    editControllerName.dispose();
    editControllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    var body = Stack(
      children: <Widget>[
        IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient),
        Center(
            child: Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, windowHeight * 0.1),
          width: windowWidth > 800 ? 400 : windowWidth,
          child: _body(),
        )),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    _pressDontHaveAccountButton();
                  }, // needed
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, bottom: 10, top: 20),
                    child: Text(
                        strings.get(19)!, // ""Don't have an account? Create",",
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: theme.text16boldWhite),
                  )),
              InkWell(
                  onTap: () {
                    _pressForgotPasswordButton();
                  }, // needed
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Text(strings.get(17)!, // "Forgot password",
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: theme.text16boldWhite),
                  ))
            ],
          ),
        ),
      ],
    );

    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          body,
          new Container(
            alignment: AlignmentDirectional.center,
            decoration: new BoxDecoration(
              color: Colors.white70,
            ),
            child: new Container(
              decoration: new BoxDecoration(
                  color: Color(0x00000000),
                  borderRadius: new BorderRadius.circular(10.0)),
              width: 300.0,
              height: 200.0,
              alignment: AlignmentDirectional.center,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Center(
                    child: new SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: new CircularProgressIndicator(
                        value: null,
                        strokeWidth: 7.0,
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: new Center(
                      child: new Text(
                        "loading.. please wait...",
                        style: new TextStyle(color: Colors.blue[300]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return new Scaffold(
      key: scaffoldKey,
      body: new Container(child: _isLoading ? bodyProgress : body),
    );
  }

  _body() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15, right: 20),
          alignment: Alignment.centerLeft,
          child: Text(strings.get(13)!, // "Let's start with LogIn!"
              style: theme.text20boldWhite),
        ),
        SizedBox(
          height: 20,
        ),
        IBox(
            color: theme.colorBackgroundDialog,
            press: () {  },
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: IInputField2(
                      hint: strings.get(15),
                      // "Login"
                      icon: Icons.alternate_email,
                      colorDefaultText: theme.colorPrimary,
                      colorBackground: theme.colorBackgroundDialog,
                      controller: editControllerName,
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: IInputField2Password(
                      hint: strings.get(16)!,
                      // "Password"
                      icon: Icons.vpn_key,
                      colorDefaultText: theme.colorPrimary,
                      colorBackground: theme.colorBackgroundDialog,
                      controller: editControllerPassword,
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: IButton(
                    pressButton: _pressLoginButton,
                    text: strings.get(22)!, // LOGIN
                    color: theme.colorPrimary,
                    textStyle: theme.text16boldWhite,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            )),
      ],
    );
  }
}
