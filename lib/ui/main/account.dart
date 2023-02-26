import 'dart:io';

import 'package:flutter/material.dart';
import 'package:courierx/main.dart';
import 'package:courierx/model/account.dart';
import 'package:courierx/services/RestData/RestDataServices.dart';
import 'package:courierx/view_models/createaccount.dart';
import 'package:courierx/widget/iAvatarWithPhotoFileCaching.dart';
import 'package:courierx/widget/ibutton2.dart';
import 'package:courierx/widget/ilist4.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../servicelocator.dart';

class AccountScreen extends StatefulWidget {
  final Function(String)? onDialogOpen;
  AccountScreen({Key? key, this.onDialogOpen}) : super(key: key);
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  ///////////////////////////////////////////////////////////////////////////////
  //
  RestDataService _restdataService = serviceLocator<RestDataService>();
  late Account account;
  void didChangeDependencies() {
    account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account!;
    print(account.notifyCount);

    super.didChangeDependencies();
  }

  _onChangePassword() {
    widget.onDialogOpen!("changePassword");
  }

  _pressEditProfileButton() {
    print("User pressed Edit profile");
    widget.onDialogOpen!("EditProfile");
    setState(() {
      account =
          Provider.of<CreateAccountViewModel>(context, listen: false).account!;
    });
  }

  _pressLogOutButton() {
    print("User pressed Log Out");
    //account.logOut();
    Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
  }

  String phone = "+2348186014986";
  String message = "Hi, Admin";
  _openWhatsapp()async{
    var whatsapp = phone; //+92xx enter like this
    var whatsappURlAndroid =
        "whatsapp://send?phone=" + whatsapp + "&text=$message";
    var whatsappURLIos = "https://wa.me/$whatsapp?text=${Uri.tryParse(message)}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
        await launchUrl(Uri.parse(
          whatsappURLIos,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Whatsapp not installed")));
      }
    } else {
      // android , web
      if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
        await launchUrl(Uri.parse(whatsappURlAndroid));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Whatsapp not installed")));
      }
    }
  }

  _makePhoto() {
    print("Make photo");
    widget.onDialogOpen!("makePhoto");
  }

  //
  //
  ///////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 40),
          child: Container(
              child: ListView(
            padding: EdgeInsets.only(top: 0),
            shrinkWrap: true,
            children: _getList(),
          )),
        ),
      ],
    );
  }

  _getList() {
    //   Account account = accounts as Account;
    var list = <Widget>[];

    list.add(
        Stack(
      children: [
        _openWhatsappWidget(),
        IAvatarWithPhotoFileCaching(
          avatar: account.userAvatar,
          color: theme.colorPrimary,
          colorBorder: theme.colorGrey,
          callback: _makePhoto,
        ),
        _logoutWidget(),
      ],
    ));

    list.add(SizedBox(
      height: 10,
    ));

    list.add(Container(
      color: theme.colorBackgroundGray,
      child: _userInfo(),
    ));

    list.add(SizedBox(
      height: 30,
    ));

    list.add(Container(
        margin: EdgeInsets.only(left: 30, right: 30), child: _editProfile()));

    list.add(SizedBox(
      height: 30,
    ));

    list.add(Container(
        margin: EdgeInsets.only(left: 30, right: 30),
        child: _changePassword()));

    list.add(SizedBox(
      height: 100,
    ));

    return list;
  }

  _changePassword() {
    return Container(
      alignment: Alignment.center,
      child: IButton2(
          color: theme.colorPrimary,
          text: strings.get(127)!, // Change password
          textStyle: theme.text14boldWhite,
          padding: 40,
          pressButton: _onChangePassword),
    );
  }

  _editProfile() {
    return Container(
      alignment: Alignment.center,
      child: IButton2(
          color: theme.colorPrimary,
          text: strings.get(128)!, // Edit profile
          textStyle: theme.text14boldWhite,
          padding: 40,
          pressButton: _pressEditProfileButton),
    );
  }

  _openWhatsappWidget() {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: 10, left: 10),
      child: Stack(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorBackgroundDialog,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: Offset(1, 1), // changes position of shadow
                ),
              ],
            ),
            child: Icon(Ionicons.logo_whatsapp,
                color: theme.colorDefaultText..withOpacity(0.1), size: 30),
          ),
          Positioned.fill(
            child: Material(
                color: Colors.transparent,
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.grey[400],
                  onTap: () {
                    _openWhatsapp();
                  }, // needed
                )),
          )
        ],
      ),
    );
  }

  _logoutWidget() {
    return Container(
      alignment: Alignment.topRight,
      margin: EdgeInsets.only(top: 10, right: 10),
      child: Stack(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorBackgroundDialog,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: Offset(1, 1), // changes position of shadow
                ),
              ],
            ),
            child: Icon(Icons.exit_to_app,
                color: theme.colorDefaultText..withOpacity(0.1), size: 30),
          ),
          Positioned.fill(
            child: Material(
                color: Colors.transparent,
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.grey[400],
                  onTap: () {
                    _pressLogOutButton();
                  }, // needed
                )),
          )
        ],
      ),
    );
  }

  _userInfo() {
    return Container(
        margin: EdgeInsets.only(
          left: windowWidth > 800 ? windowWidth * 0.4 : 10,
          right: windowWidth > 800 ? windowWidth * 0.4 : 10,
        ),
        child: Column(
          children: <Widget>[
            IList4(
              text: "${strings.get(57)}:", // "Username",
              textStyle: theme.text14bold,
              text2: account.userName,
              textStyle2: theme.text14bold,
            ),
            SizedBox(
              height: 10,
            ),
            IList4(
              text: "${strings.get(58)}:", // "E-mail",
              textStyle: theme.text14bold,
              text2: account.email,
              textStyle2: theme.text14bold,
            ),
            SizedBox(
              height: 10,
            ),
            IList4(
              text: "${strings.get(59)}:", // "Phone",
              textStyle: theme.text14bold,
              text2: account.phone == null ? "" : account.phone,
              textStyle2: theme.text14bold,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}
