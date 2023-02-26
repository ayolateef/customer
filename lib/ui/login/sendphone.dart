import 'package:flutter/material.dart';
import 'package:courierx/main.dart';
import 'package:courierx/model/account.dart';
import 'package:courierx/view_models/createaccount.dart';
import 'package:courierx/widget/iappBar.dart';
import 'package:courierx/widget/ibackground3.dart';
import 'package:courierx/widget/ibox.dart';
import 'package:courierx/widget/ibutton.dart';
import 'package:courierx/widget/iinputField2.dart';
import 'package:courierx/servicelocator.dart';
import 'package:courierx/services/account/createaccount.dart';
import 'package:courierx/services/RestData/RestDataServices.dart';
import 'package:provider/provider.dart';

class SendPhoneNumberScreen extends StatefulWidget {
  @override
  _SendPhoneNumberScreenState createState() => _SendPhoneNumberScreenState();
}

class _SendPhoneNumberScreenState extends State<SendPhoneNumberScreen>
    with SingleTickerProviderStateMixin {
  // CreateAccountViewModel viewModel;
  CreateAccountServices createAccountServices =
      serviceLocator<CreateAccountServices>();
  RestDataService _restdataService = serviceLocator<RestDataService>();
  // CreateAccountProvider setemail = serviceLocator<CreateAccountProvider>();

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  _pressContinueButton() async {
    String? result;
    Account account = await _restdataService.createaccountget(body: toMap());
    account.setphone(editControllerPhone.text);
    print(account.email);
    Future<String> phone =
        createAccountServices.addAPhone(body: account.toMap()).then((value) {
      return result = value;
      // _showSnackBar(result);
      //  if (result == "success") {
      Provider.of<CreateAccountViewModel>(context, listen: false)
          .tokenset(result!);
      route.push(context, "/verifyphone");
    });
    return result;

    //     });
    // print("User pressed \"CONTINUE\" button");
    // print("test 1");
    // print(phone);
    // print("Phone: ${editControllerPhone.text}");
    route.push(context, "/verifyphone");
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    String _email = '${context.read<CreateAccountViewModel>().logonemail}';
    print("converted - ");
    print(_email);
    map["email"] = _email;

    return map;
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  final editControllerPhone = TextEditingController();

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
    return  Consumer<CreateAccountViewModel>(
        builder: (context, model, child) => Scaffold(
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
          child: Text(strings.get(27)!, // "To continue enter your phone number"
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
                    child: IInputField2(
                      hint: strings.get(28), // "Phone number"
                      icon: Icons.phone,
                      colorDefaultText: theme.colorPrimary,
                      colorBackground: theme.colorBackgroundDialog,
                      controller: editControllerPhone,
                      type: TextInputType.phone,
                    )),
                SizedBox(
                  height: 25,
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
