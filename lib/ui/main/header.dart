import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:courierx/main.dart';
import 'package:courierx/model/account.dart';
import 'package:courierx/services/RestData/RestDataServices.dart';
import 'package:courierx/view_models/createaccount.dart';
import 'package:courierx/widget/iinkwell.dart';
import 'package:provider/provider.dart';
import 'package:courierx/globals.dart' as globals;

import '../../servicelocator.dart';

class Header extends StatefulWidget {
  final String ? title;
  final Function onMenuClick;
  final bool nomenu;
  final bool white;
  final bool transparent;
  Header(
      {Key? key,
      this.title,
      required this.onMenuClick,
      this.nomenu = false,
      this.white = false,
      this.transparent = false})
      : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  ///////////////////////////////////////////////////////////////////////////////
  //
  var _iconMenu = "assets/menu.png";
  var _iconBack = "assets/back.png";
  var _iconShop = "assets/shop.png";
  var _iconNotify = "assets/notifyicon.png";

  Account? account;
  RestDataService _restdataService = serviceLocator<RestDataService>();

  CreateAccountViewModel _accountViewModel =
      serviceLocator<CreateAccountViewModel>();

  void didChangeDependencies() {
    account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account;
    print(account?.notifyCount);

    super.didChangeDependencies();
  }

  _onBackClick() {
    Navigator.pop(context);
  }

  _onMenuClick() {
    print("User click menu button");
    if (widget.onMenuClick != null) widget.onMenuClick();
  }

  _onNotifyClick() {
    print("User click Notify button");
    //_restdataService.getnotify(token)
    route.push(context, "/notify");
  }

  _onBasketClick() {
    print("User click basket button");
    route.push(context, "/basket");
  }

  // _account() async{

  //   _accountViewModel.accounts
  //  Account account1 = await _restdataService.getloggedin(username);
  //  return account1;
  // }

  // _account2() {
  //   String username =
  //       Provider.of<CreateAccountViewModel>(context, listen: false)
  //           .logonusername;
  //   account = _restdataService.getloggedaccount(username);
  //   return globals.account;
  // }

  _onAvatarClick() {
    print("User click avatar button");
    route.push(context, "/account");
//    if (widget.nomenu)
//      Navigator.pop(context);

    // route.mainScreen.route("account");
  }

  @override
  void initState() {
    super.initState();
    //   _account;
    //       Account account1 = await _restdataService.getloggedin(username);
    //  print(account1.notifyCount);
    //  accounts();

    // Account account =
    //  accounts();
  }

  // Account account = globals.account;

  //
  ///////////////////////////////////////////////////////////////////////////////
  Color _color = Colors.black;

  @override
  Widget build(BuildContext context) {
    _color = theme.colorDefaultText;
    if (widget.white) _color = Colors.white;
    String _title = "";
    if (widget.title != null) _title = widget.title ?? "";

    Widget _menu = IInkWell(
      child: _iconMenuWidget(),
      onPress: _onMenuClick,
    );
    if (widget.nomenu)
      _menu = IInkWell(
        child: _iconBackWidget(),
        onPress: _onBackClick,
      );

    var _style = theme.text16bold;
    if (widget.white != null && widget.white) _style = theme.text16boldWhite;

    var _box = BoxDecoration(
      color: theme.colorBackground,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 3,
          blurRadius: 5,
          offset: Offset(3, 3),
        ),
      ],
    );
    if (widget.transparent) _box = BoxDecoration();

    return Container(
        height: 40,
        decoration: _box,
        child: Row(
          children: <Widget>[
            _menu,
            Expanded(
              child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    _title,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: _style,
                  )),
            ),
            IInkWell(
              child: _notify(),
              onPress: _onNotifyClick,
            ),
            // IInkWell(
            //   child: _shopping(),
            //   onPress: _onBasketClick,
            // ),
            // IInkWell(
            //   child: _avatar(),
            //   onPress: _onAvatarClick,
            // ),
          ],
        ));
  }

  _avatarget(String avatar) {
    if (avatar == null || avatar == '') {
      return Image(image: AssetImage("assets/selectimage.png")).image;
    } else {
      final Color colorProgressBar = Colors.black;
      return NetworkImage(avatar);
    }
  }

  _avatar() {
    Account? accounts =
        Provider.of<CreateAccountViewModel>(context, listen: true).account;
    print(accounts?.userAvatar);
    return Container(
      child: CircleAvatar(
        backgroundImage: _avatarget(accounts!.userAvatar),
        radius: 12,
      ),
      margin: EdgeInsets.only(left: 5, top: 2, bottom: 2, right: 10),
    );
  }

  _iconMenuWidget() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
      child: UnconstrainedBox(
          child: Container(
              height: 25,
              width: 25,
              child: Image.asset(
                _iconMenu,
                fit: BoxFit.contain,
                color: _color,
              ))),
    );
  }

  _iconBackWidget() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
      child: UnconstrainedBox(
          child: Container(
              height: 25,
              width: 25,
              child: Image.asset(
                _iconBack,
                fit: BoxFit.contain,
                color: _color,
              ))),
    );
  }

  _shopping() {
    Account? accounts =
        Provider.of<CreateAccountViewModel>(context, listen: false).account;
    return UnconstrainedBox(
        child: Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      height: 25,
      width: 30,
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: UnconstrainedBox(
                child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    height: 25,
                    width: 30,
                    child: Image.asset(
                      _iconShop,
                      fit: BoxFit.contain,
                      color: _color,
                    ))),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: theme.colorPrimary,
                shape: BoxShape.circle,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(accounts!.inBasket.toString(),
                    style: theme.text10white),
              ),
            ),
          )
        ],
      ),
    ));
  }

  _notify() {
    Account? accounts =
        Provider.of<CreateAccountViewModel>(context, listen: true).account;
    //    print(accounts.notifyCount);

    return UnconstrainedBox(
        child: Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
      height: 25,
      width: 30,
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: UnconstrainedBox(
                child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    height: 25,
                    width: 30,
                    child: Image.asset(
                      _iconNotify,
                      fit: BoxFit.contain,
                      color: _color,
                    ))),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: theme.colorPrimary,
                shape: BoxShape.circle,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(accounts?.notifyCount.toString() ?? "",
                    style: theme.text10white),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
