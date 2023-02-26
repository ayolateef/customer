import 'package:flutter/material.dart';
import 'package:courierx/main.dart';
import 'package:courierx/view_models/createaccount.dart';
import 'package:courierx/widget/dialog.dart';
import 'package:courierx/widget/iVerifySMS.dart';
import 'package:courierx/widget/iappBar.dart';
import 'package:courierx/widget/ibackground3.dart';
import 'package:courierx/widget/ibox.dart';
import 'package:courierx/widget/ibutton.dart';
import 'package:provider/provider.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  @override
  _VerifyPhoneNumberScreenState createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen>
    with SingleTickerProviderStateMixin {
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  late String token;
  _pressContinueButton() {
    String tokens =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;
    // for (int i = 0; i < token.length; i++) {
    //   if(token[i].allMatches(string) == )
    //   if(("[" OR "'val2'" OR "val3").equalsIgnoreCase(str)
    //   var char = s[i];
    // }
    if (token == tokens) {
      print("User pressed \"CONTINUE\" button");
      //    print("Phone: ${code}");

      _openDialog();
    }
  }

  _onChangeCode(String code) {
    // print('Code onChanged $code');
    token = code;
    print('Code onChanged $token');
  }

  _callbackDone() {
    print("User pressed \"Continue\" button");
    route.pushToStart(context, "/login");
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  final editControllerPhone = TextEditingController();

  _openDialog() {
    EasyDialog(
      title: strings.get(31)!, // "Almost done!",
      text: strings.get(32)!, // Code verification success
      closeOnBackgroundTap: true,
      colorBackground: theme.colorBackgroundDialog,
      titleLine: false,
      bodyLine: true,
      okText: strings.get(18)!, okColor: theme.colorPrimary, // "Continue",
      callbackPressOk: _callbackDone, okButtonText: true,
    ).show(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    route.disposeLast();
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
          IBackground4(
              width: windowWidth, colorsGradient: theme.colorsGradient),
          IAppBar(context: context, text: "", color: Colors.white),
          Center(
              child: Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, windowHeight * 0.1),
            width: windowWidth,
            child: _body(),
          )),
        ],
      ),
    );
  }

  _body() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15, right: 20),
          alignment: Alignment.centerLeft,
          child: Text(strings.get(30)!, // "Verify phone number"
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
                  height: 25,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: IVerifySMS(
                    color: theme.colorPrimary,
                    callback: _onChangeCode,
                  ),
                ),
                SizedBox(
                  height: 45,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: IButton(
                    pressButton: _pressContinueButton,
                    text: strings.get(29)!, // CONTINUE
                    color: theme.colorPrimary,
                    textStyle: theme.text16boldWhite,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            )),
      ],
    );
  }
}
