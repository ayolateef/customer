import 'dart:async';

import 'package:courierx/model/ChatMessage.dart';
import 'package:courierx/model/user.dart';
import 'package:courierx/model/account.dart';
import 'package:courierx/model/createaccount.dart';
import 'package:courierx/utils/network_util.dart';
import 'package:courierx/services/RestData/RestDataServices.dart';
import 'package:courierx/model/pickuporder.dart';
import 'package:courierx/model/pickorders.dart';
import 'package:courierx/model/notification.dart';
import 'package:courierx/model/adminuser.dart';

class RestDataImpl implements RestDataService {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://18.118.154.13:30136";
  static final LOGIN_URL = BASE_URL + "/login";
  static final createnewaccturl = BASE_URL + "/profiles/addnewaccount";
  static final getcreateaccount = BASE_URL + "/profiles/email";
  static final createphoneno = BASE_URL + "/profiles/phonecode";
  static final loginurl = BASE_URL + "/login";
  static final loggedinusers = BASE_URL + "/profiles/loggedusers";
  static final addpickup = BASE_URL + "/pickuporders/addone";
  static final changepasskey = BASE_URL + "/profiles/changepasskey";
  static final changephone = BASE_URL + "/profiles/setphonecode";
  static final editprofileurl = BASE_URL + "/profiles/editprofile";
  static final addprice = BASE_URL + "/pickuporders/addPrice";
  static final getordersurl = BASE_URL + "/pickuporders/email";
  static final getnotifyurl = BASE_URL + "/notification";
  static final getonenotifyurl = BASE_URL + "/notification/email";
  static final addnotifysurl = BASE_URL + "/notification/addone";
  static final deletnotifyurl = BASE_URL + "/notification/delete";
  static final changephoto = BASE_URL + "/profiles/changeavatar";
  static final admineusername = BASE_URL + "/profiles/adminusername";
  //static final messageurl = BASE_URL + "/profiles/adminusername";

  Future<String> login(String username, String password) {
    return _netUtil
        .getloginpost(loginurl, body: toMap(username, password))
        .then((dynamic res) {
      print("rest_data login: ${res.toString()}");
      if (res == null) throw new Exception("error_msg");
      return res;
    });
  }

  Future<Model1DTO> getadminusername(String token, {Map? body}) {
    return _netUtil.adminemail(admineusername, token, body: body!);
  }

  Future<Account> accountget(String username, String password) {
    return _netUtil.getlogin(loggedinusers).then((dynamic res) {
      print("rest_data accountget: ${res.toString()}");
      if (res["error"]) throw new Exception(res["error_msg"]);
      return new Account.map(res);
    });
  }

  Future<Account> editprofile(String token, {Map? body}) {
    return _netUtil.editprofile(editprofileurl, token, body: body! );
  }

  Future<Account> editphoto(
      String token, String email, String path, String name) {
    return _netUtil.editprofile2(changephoto, token,
        body: toMap4(email, path, name));
  }

  Future<Notifications> deleteprofile(String token, {Map? body}) {
    return _netUtil.deletenotifyone(deletnotifyurl, token, body: body!);
  }

  Future<Account> getloggedin(String username) async {
    // await Future<Account>.delayed(const Duration(seconds: 8));
    return _netUtil.getloggedinnet(
      loggedinusers,
      body: toMap2(username),
    );
    //     .then((dynamic res) {
    //   print(res.toString());
    //   //  if (res["error"]) throw new Exception(res["error_msg"]);
    //   return new Account.map(res);
    // });
  }

  Future<Account> createaccountget({Map? body}) {
    return _netUtil
        .getcreateaccount(getcreateaccount, body: body!)
        .then((dynamic res) {
      print("rest_data createaccount: ${res.toString()}");
      // if (res["error"]) throw new Exception(res["error_msg"]);
      return new Account(
          res['username'],
          res['email'],
          res['phone'],
          res['userAvatar'],
          res['userAvatarInternet'],
          res['gender'],
          res['dateOfBirth'],
          res['inBasket'],
          res['notifyCount']);
    });
  }

  Future<String> createnewaccount({Map? body}) async {
    return _netUtil
        .createnewaccount(createnewaccturl, body: body!)
        .then((dynamic res) {
      print("rest_data createnewaccount: ${res.toString()}");
      String result = res;

      return result;
    });
  }

  Future<Pickorders> createpickuporders(String token, {Map? body}) async {
    print("rest_data createpickuporders: ${body.toString()}");

    return _netUtil.addpickuporder(addpickup, token, body: body!);
    // .then((dynamic res) {
    // print(res.toString());
    // //   String result = res;

    //   return result;
  }

  Future<Pickorders> pickupprice(String token, {Map? body}) async {
    return _netUtil.addpickuporder(addprice, token, body: body!);
    // .then((dynamic res) {
    // print(res.toString());
    // //   String result = res;

    //   return result;
  }

  Future<List<Pickorders>> getorders(String token, {Map? body}) async {
    return _netUtil.getorders(getordersurl, token, body: body!);
  }

  Future<List<Notifications>> getnotify(String token, {Map? body}) async {
    return _netUtil.getnotifyone(getonenotifyurl, token, body: body!);
  }

  Future<String> changepassword(String token, {Map? body}) async {
    return _netUtil.changepassword(changepasskey, token, body: body!);
    // .then((dynamic res) {
    // print(res.toString());
    // //   String result = res;

    //   return result;
  }

  Future<List<ChatMessage>> getmessage(String token, String url,
      {Map? body}) async {
    return _netUtil.getmessagesDTO(url, token, body: body!);
  }

  Future<String> createphone({Map? body}) async {
    return _netUtil.phonereg(createphoneno, body: body!).then((dynamic res) {
      print("rest_data createphone: ${res.toString()}");
      String result = res;

      return result;
    });
  }

  Map<String, dynamic> toMap(String username, String password) {
    var map = new Map<String, dynamic>();

    map["username"] = username;
    map["password"] = password;

    return map;
  }

  Map<String, dynamic> toMap4(String email, String path, String name) {
    var map = new Map<String, dynamic>();

    map["email"] = email;
    map["userAvatar"] = path;
    map["userAvatarInternet"] = name;

    return map;
  }

  Map<String, dynamic> toMap2(String username) {
    var map = new Map<String, dynamic>();
    print("rest_data to Map2 map for ddd");
    print(username);
    map["username"] = username;

    return map;
  }

  Map<String, dynamic> toMap3(String name, String address, String phone,
      String mobilephone, String pcategory, String packages, String desc) {
    var map = new Map<String, dynamic>();
    //  print("map for ddd");
    //  print(username);
    map["name"] = name;
    map["address"] = address;
    map["phone"] = phone;
    map["mobilephone"] = mobilephone;
    map["pcategory"] = pcategory;
    map["packages"] = packages;
    map["desc"] = desc;

    return map;
  }

  Account getloggedaccount(String username) {
     late Account result ;
//print(username);
//Account test = await tryrest.getloggedin(username);
    Future<Account> _accounts = getloggedin(username);
    _accounts.then((value) {
      result = value;
      //  _showSnackBar(result);
      // ignore: unnecessary_null_comparison
      if (result != null) {
        //  print(value);
        print("rest_data : logged account");
        print(result.email);
        //   print(result.);
      }
      // return result;
    });
    //  Account results = await _accounts;

    return result;
  }
}
