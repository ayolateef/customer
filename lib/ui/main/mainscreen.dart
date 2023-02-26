import 'dart:io';
import 'dart:convert';

import 'package:courierx/model/notification.dart';
import 'package:courierx/services/notification_services.dart';
import 'package:courierx/ui/main/whatsapp.dart';
import 'package:courierx/ui/menu/help.dart';
import 'package:flutter/material.dart';
import 'package:courierx/main.dart';
import 'package:courierx/model/account.dart';
import 'package:courierx/services/RestData/RestDataServices.dart';
import 'package:courierx/services/account/createaccount.dart';
import 'package:courierx/services/firebase/cloudstorage.dart';
import 'package:courierx/view_models/accountviewmodel.dart';
import 'package:courierx/ui/main/ChatDetailPage.dart';
import 'package:courierx/ui/main/account.dart';
import 'package:courierx/ui/main/pickuporderm.dart';
import 'package:courierx/ui/main/favorites.dart';
import 'package:courierx/ui/main/header.dart';
import 'package:courierx/ui/main/home.dart';
import 'package:courierx/ui/main/map.dart';
import 'package:courierx/ui/main/orders.dart';
import 'package:courierx/ui/menu/menu.dart';
import 'package:courierx/view_models/createaccount.dart';
import 'package:courierx/widget/easyDialog2.dart';
import 'package:courierx/widget/ibottombar.dart';
import 'package:courierx/widget/ibutton2.dart';
//import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:courierx/globals.dart' as globals;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import '../../servicelocator.dart';

// ignore: must_be_immutable
class MainScreen extends StatefulWidget {
   _MainScreenState? _state;

  @override
  _MainScreenState createState() {
    _state = _MainScreenState();
    return _state!;
  }

  route(String value) {
    _state?.routes(value);
  }
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  //final scaffoldKey = new GlobalKey<ScaffoldState>();
  RestDataService _restdataService = serviceLocator<RestDataService>();
  CreateAccountServices _createService =
      serviceLocator<CreateAccountServices>();

  AccountViewModel _accountService = serviceLocator<AccountViewModel>();

   Account? account;
  void didChangeDependencies() {
    account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account;
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;
    _accountService.adminusernameset(token);
    print("mainscreen didchange ${account?.email}");
    // print("mainscreen didchange ${strings.langEng[0]}");

    super.didChangeDependencies();
  }

  _callbackChange() {
    print("User pressed Change password");
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;
    Account? account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account;
    // print(account.email);
    print(
        "Old password: ${editControllerOldPassword.text}, New password: ${editControllerNewPassword1.text}, "
        "New password 2: ${editControllerNewPassword2.text}");
    if (editControllerNewPassword1.text == editControllerNewPassword2.text) {
      Future<String> result = _createService.chnagepassword(
          token,
          account!.email,
          editControllerOldPassword.text,
          editControllerNewPassword1.text,
          editControllerNewPassword2.text);
      new Future.delayed(const Duration(seconds: 6), () {
        if (result.toString() == "success") {
          setState(() {
            _show = 0;
          });
        }
      });
    } else {
      _showSnackBar("Password didn't match");
      setState(() {
        _show = 1;
      });
    }
  }

  _callbackSave() async {
    print("User pressed Save profile");
    print(
        "User Name: ${editControllerName.text}, E-mail: ${editControllerEmail.text}, Phone: ${editControllerPhone.text}");
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;
    Account account = await _createService.editprofile(
        token,
        editControllerName.text,
        editControllerEmail.text,
        editControllerPhone.text);
    Provider.of<CreateAccountViewModel>(context, listen: false)
        .accounts(account.userName);
    new Future.delayed(const Duration(seconds: 8), () {
      setState(() {
        _show = 0;
      });
    });
  }

  _bottonBarChange(int index) {
    print("User pressed bottom bar button with index: $index");
    setState(() {
      _currentPage = index;
    });
  }

  _openMenu() {
    print("Open menu");
    setState(() {
      _scaffoldMessengerKey.currentState?.openDrawer();
    });
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  final editControllerName = TextEditingController();
  final editControllerEmail = TextEditingController();
  final editControllerPhone = TextEditingController();
  final editControllerOldPassword = TextEditingController();
  final editControllerNewPassword1 = TextEditingController();
  final editControllerNewPassword2 = TextEditingController();
  var _currentPage = 2;
  final GlobalKey<ScaffoldState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldState>();
  final picker = ImagePicker();
  List<Notifications> _this = [];
  String username = '';
  NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    initNotify();
    // accounts();

    // Account account =
    //  accounts();
  }

  initNotify() async {
    Account? account = Provider.of<CreateAccountViewModel>(context, listen: false).account;
    String token =
        Provider.of<CreateAccountViewModel>(context, listen: false).token;

    _this = await _restdataService.getnotify(token, body: toMap(account!.email));
    print(" notificationScreen: init ${_this.length}");
    showNotification();   

    setState(() {});
  }

  Map<String, dynamic> toMap(String email) {
    var map = new Map<String, dynamic>();
    print(" notificationScreen: map for ddd");
    // print(username);

    map["email"] = email;

    return map;
  }

  showNotification() async {
    print(" notificationScreen: none showNotification ${_this.length}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < _this.length; i++) {
      username = prefs.getString('dateList' + '${i.toString()}')!;
      if (username != _this[i].date) {
        print(" notificationScreen: username showNotification $username");
        print(" notificationScreen: get showNotification ${_this[i].date}");
        await _notificationService.scheduleNotifications(
            _this[i].id!, _this[i].title!, _this[i].text!);
        prefs.setString('dateList' + '${i.toString()}', _this[i].date!);
      } else {
        await _notificationService.cancelNotifications(_this[i].id!);
        print(" notificationScreen: show showNotification ${_this[i].date}");
      }
    }
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: new Text(text),
    ));
  }

  @override
  void dispose() {
    route.disposeLast();
    editControllerName.dispose();
    editControllerEmail.dispose();
    editControllerPhone.dispose();
    editControllerOldPassword.dispose();
    editControllerNewPassword1.dispose();
    editControllerNewPassword2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    String? _headerText  = strings.get(47); // "Map",
    switch (_currentPage) {
      case 1:
        _headerText = strings.get(36); // "My Orders",
        break;
      case 2:
        _headerText = strings.get(33); // "Home",
        break;
      case 3:
        _headerText = strings.get(37); // "Account",
        break;
      case 4:
        _headerText = strings.get(38); // "Favorites",
        break;
    }
    var body1 = Stack(
      children: <Widget>[
        if (_currentPage == 0) MapScreen(),
        if (_currentPage == 1) OrdersScreen(),
        if (_currentPage == 2) MakeADeliveryScreen(),
        if (_currentPage == 3) AccountScreen(onDialogOpen: _openDialogs),
        if (_currentPage == 4) WhatsappLink(),
        Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Header(title: _headerText, onMenuClick: _openMenu)),
      ],
    );
    var body2 = Stack(
      children: <Widget>[
        if (_currentPage == 0) MapScreen(),
        if (_currentPage == 1) OrdersScreen(),
        if (_currentPage == 2) MakeADeliveryScreen(),
        if (_currentPage == 3) AccountScreen(onDialogOpen: _openDialogs),
        if (_currentPage == 4) WhatsappLink(),
        Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Header(title: _headerText, onMenuClick: _openMenu)),
        SafeArea(
          child: Container(
            child: IBottomBar(
                colorBackground: theme.colorBackground,
                colorSelect: theme.colorPrimary,
                colorUnSelect: theme.colorDefaultText,
                callback: _bottonBarChange,
                initialSelect: _currentPage,
                getItem: () {
                  return _currentPage;
                },
                icons: [
                  "assets/map.png",
                  "assets/list.png",
                  "assets/home.png",
                  "assets/account.png",
                  "assets/whatsapp.png"
                ]),
          ),
        ),
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
    );
    return Scaffold(
      key: _scaffoldMessengerKey,
      drawer: Menu(
        context: context,
        callback: routes,
      ),
      backgroundColor: theme.colorBackground,
      body: windowWidth > 800 ? body1 : body2,
    );
  }

  routes(String route) {
    if (route == "map")
      setState(() {
        _currentPage = 0;
      });
    if (route == "orders")
      setState(() {
        _currentPage = 1;
      });
    if (route == "home")
      setState(() {
        _currentPage = 2;
      });
    if (route == "account")
      setState(() {
        _currentPage = 3;
      });
    if (route == "favorites")
      setState(() {
        _currentPage = 4;
      });
    if (route == "redraw") print("mainscreen redraw");
    setState(() {});
  }

  _openDialogs(String name) {
    if (name == "EditProfile") _openEditProfileDialog();
    if (name == "makePhoto") getImage();
    if (name == "changePassword") _pressChangePasswordButton();
  }

  double _show = 0;
  Widget _dialogBody = Container();

  _openEditProfileDialog() {
    editControllerName.text = account!.userName;
    editControllerEmail.text = account!.email;
    editControllerPhone.text = account!.phone;

    if (windowWidth < 800) {
      print("below 800");
      _dialogBody = Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                child: Text(
                  strings.get(136)!,
                  textAlign: TextAlign.center,
                  style: theme.text18boldPrimary,
                ) // "Edit profile",
                ), // "Reason to Reject",
            SizedBox(
              height: 20,
            ),
            Text(
              "${strings.get(137)}:",
              style: theme.text12bold,
            ), // "User Name",
            _edit2(editControllerName, strings.get(138) ?? '',
                false), //  "Enter your User Name",
            SizedBox(
              height: 20,
            ),
            Text(
              "${strings.get(139)}:",
              style: theme.text12bold,
            ), // "E-mail",
            _edit2(editControllerEmail, strings.get(140) ?? "",
                false), //  "Enter your User E-mail",
            SizedBox(
              height: 20,
            ),
            Text(
              "${strings.get(59)}:",
              style: theme.text12bold,
            ), // Phone
            _edit(editControllerPhone, strings.get(141) ?? "",
                false), //  "Enter your User Phone",
            SizedBox(
              height: 30,
            ),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IButton2(
                    color: theme.colorPrimary,
                    text: strings.get(142) ?? "", // Change
                    textStyle: theme.text14boldWhite,
                    pressButton: () {
                      _callbackSave();
                    }),
                SizedBox(
                  width: 10,
                ),
                IButton2(
                    color: theme.colorPrimary,
                    text: strings.get(135) ?? "", // Cancel
                    textStyle: theme.text14boldWhite,
                    pressButton: () {
                      setState(() {
                        _show = 0;
                      });
                    }),
              ],
            )),
          ],
        ),
      );
    } else {
      print("above 800");
      _dialogBody = Container(
        width: 500,
        margin: EdgeInsets.only(left: 10, right: 10),
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                child: Text(
                  strings.get(136) ?? "",
                  textAlign: TextAlign.center,
                  style: theme.text18boldPrimary,
                ) // "Edit profile",
                ), // "Reason to Reject",
            SizedBox(
              height: 20,
            ),
            Text(
              "${strings.get(137)}:",
              style: theme.text12bold,
            ), // "User Name",
            _edit2(editControllerName, strings.get(138) ?? "",
                false), //  "Enter your User Name",
            SizedBox(
              height: 20,
            ),
            Text(
              "${strings.get(139)}:",
              style: theme.text12bold,
            ), // "E-mail",
            _edit2(editControllerEmail, strings.get(140) ?? "",
                false), //  "Enter your User E-mail",
            SizedBox(
              height: 20,
            ),
            Text(
              "${strings.get(59)}:",
              style: theme.text12bold,
            ), // Phone
            _edit(editControllerPhone, strings.get(141) ?? "",
                false), //  "Enter your User Phone",
            SizedBox(
              height: 30,
            ),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IButton2(
                    color: theme.colorPrimary,
                    text: strings.get(142) ?? "", // Change
                    textStyle: theme.text14boldWhite,
                    pressButton: () {
                      _callbackSave();
                    }),
                SizedBox(
                  width: 10,
                ),
                IButton2(
                    color: theme.colorPrimary,
                    text: strings.get(135) ?? "", // Cancel
                    textStyle: theme.text14boldWhite,
                    pressButton: () {
                      setState(() {
                        _show = 0;
                      });
                    }),
              ],
            )),
          ],
        ),
      );
    }

    setState(() {
      _show = 1;
    });
  }

  _edit(TextEditingController _controller, String _hint, bool _obscure) {
    return Container(
      height: 30,
      child: TextField(
        controller: _controller,
        onChanged: (String value) async {},
        cursorColor: theme.colorDefaultText,
        style: theme.text14,
        cursorWidth: 1,
        obscureText: _obscure,
        textAlign: TextAlign.left,
        maxLines: 1,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: _hint,
            hintStyle: theme.text14),
      ),
    );
  }

  _edit2(TextEditingController _controller, String _hint, bool _obscure) {
    return Container(
      height: 30,
      child: TextField(
        controller: _controller,
        enabled: false,
        onChanged: (String value) async {},
        cursorColor: theme.colorDefaultText,
        style: theme.text14,
        cursorWidth: 1,
        obscureText: _obscure,
        textAlign: TextAlign.left,
        maxLines: 1,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: _hint,
            hintStyle: theme.text14),
      ),
    );
  }

  _pressChangePasswordButton() {
    _dialogBody = Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              child: Text(
                strings.get(145) ?? "",
                textAlign: TextAlign.center,
                style: theme.text18boldPrimary,
              ) // "Change password",
              ), // "Reason to Reject",
          SizedBox(
            height: 20,
          ),
          Text(
            "${strings.get(129)}:",
            style: theme.text12bold,
          ), // "Old password",
          _edit(editControllerOldPassword, strings.get(130) ?? "",
              true), //  "Enter your old password",
          SizedBox(
            height: 20,
          ),
          Text(
            "${strings.get(131)}:",
            style: theme.text12bold,
          ), // "New password",
          _edit(editControllerNewPassword1, strings.get(132) ?? "",
              true), //  "Enter your new password",
          SizedBox(
            height: 20,
          ),
          Text(
            "${strings.get(133)}:",
            style: theme.text12bold,
          ), // "Confirm New password",
          _edit(editControllerNewPassword2, strings.get(134) ?? "",
              true), //  "Enter your new password",
          SizedBox(
            height: 30,
          ),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IButton2(
                  color: theme.colorPrimary,
                  text: strings.get(142)!, // Change
                  textStyle: theme.text14boldWhite,
                  pressButton: () {
                    setState(() {
                      _show = 0;
                    });
                    _callbackChange();
                  }),
              SizedBox(
                width: 10,
              ),
              IButton2(
                  color: theme.colorPrimary,
                  text: strings.get(135)!, // Cancel
                  textStyle: theme.text14boldWhite,
                  pressButton: () {
                    setState(() {
                      _show = 0;
                    });
                  }),
            ],
          )),
        ],
      ),
    );

    setState(() {
      _show = 1;
    });
  }

  Future getImage2(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null && pickedFile.path != null) {
      print("Photo file: ${pickedFile.path}");
      File _storedImage;

      if (pickedFile == null) {
        debugPrint('mainscreen: getimage2: picked file == null');
        return;
      }
      setState(() {
        //  _storedImage = pickedFile;
      });

      final fileName = path.basename(pickedFile.path);
      debugPrint("mainscreen: getimage2: filename: $fileName");
      var img = await File(pickedFile.path);

      CloudStorageResult? imgcloud = await CloudStorageService()
          .uploadImage(imageToUpload: img, title: "useravatar");
      debugPrint("mainscreen: getimage2: imgcloud: ${imgcloud!.imageUrl}");

      account?.setavatar(imgcloud.imageUrl!);
      account?.setavatarinternet(imgcloud.imageFileName!);
      String token =
          Provider.of<CreateAccountViewModel>(context, listen: false).token;
      debugPrint('mainscreen: getimage2: token: $token');

      _restdataService.editphoto(
          token, account!.email, imgcloud.imageUrl!, imgcloud.imageFileName!);
      // if (account.userAvatarInternet != "" ||
      //     account.userAvatarInternet != null) {
      //       print(account.userAvatarInternet)
      //   await CloudStorageService().deleteImage(account.userAvatarInternet);
      // }
      setState(() {
        //_avatar = pickedFile.path;
      });
    }
  }

  getImage() {
    _dialogBody = Column(
      children: [
        InkWell(
            onTap: () {
              getImage2(ImageSource.gallery);
              setState(() {
                _show = 0;
              });
            }, // needed
            child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                margin: EdgeInsets.only(top: 10, bottom: 10),
                height: 40,
                color: theme.colorBackgroundGray,
                child: Center(
                  child: Text(strings.get(143)!), // "Open Gallery",
                ))),
        InkWell(
            onTap: () {
              getImage2(ImageSource.camera);
              setState(() {
                _show = 0;
              });
            }, // needed
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              margin: EdgeInsets.only(bottom: 10),
              height: 40,
              color: theme.colorBackgroundGray,
              child: Center(
                child: Text(strings.get(144)!), //  "Open Camera",
              ),
            )),
        SizedBox(
          height: 20,
        ),
        IButton2(
            color: theme.colorPrimary,
            text: strings.get(135)!, // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: () {
              setState(() {
                _show = 0;
              });
            }),
      ],
    );
    setState(() {
      _show = 1;
    });
  }
}
