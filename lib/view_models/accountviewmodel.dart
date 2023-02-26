import 'package:courierx/data/APIKeys.dart';
import 'package:flutter/widgets.dart';
import 'package:courierx/model/account.dart';
import 'package:courierx/model/orders.dart';
import 'package:courierx/model/pickuporder.dart';
import 'package:courierx/services/RestData/RestDataServices.dart';
import 'package:provider/provider.dart';
import 'package:courierx/model/pickorders.dart';
import '../servicelocator.dart';
import 'package:courierx/model/adminuser.dart';

class AccountViewModel extends ChangeNotifier {
  // static CreateAccountProvider of(BuildContext context, {bool listen = true}) =>
  //     Provider.of<CreateAccountProvider>(context, listen: listen);

  // String _prevSearchTerm = "";

  RestDataService _restdataService = serviceLocator<RestDataService>();

  late Pickorders _pickuporder;
  late List<Pickorders> _pickuporderlist;
  late Orders _orders;
  int _stage = 1;
  late String _ordersid;
  late String _payment;
  late String _date;
  late String _gapikey = APIKeys().gapikeys;
  late String _adminuser;
  late String _adminphone;
  late String _option;
//  String get prevSearchTerm => _prevSearchTerm;
  Pickorders get pickuporder => _pickuporder;
  List<Pickorders> get pickuporderlist => _pickuporderlist;
  Orders get orders => _orders;
  int get stage => _stage;
  String get gapikey => _gapikey;
  String get ordersid => _ordersid;
  String get payment => _payment;
  String get date => _date;
  String get adminuser => _adminuser;
  String get adminphone => _adminphone;
  String get option => _option;

  void pickupset(Pickorders newValue) {
    _pickuporder = newValue;
    notifyListeners();
  }

  void setpayment(String value) {
    _payment = value;
    notifyListeners();
  }

  void setoption(String value) {
    _option = value;
    notifyListeners();
  }

  void setdate(String value) {
    _date = value;
    notifyListeners();
  }

  void orderidset(String newValue) {
    _ordersid = newValue;
    print("logon here now ${newValue}");
    //  print(_pickuporder.name);
    notifyListeners();
  }

  void orderset(Orders newValue) {
    // print(newValue[1].name);
    //  _orders = newValue;

    _orders = newValue;

    print("order set");
    //  print(_pickuporder.name);
    notifyListeners();
  }

  void pickuplistset(List<Pickorders> newValue) {
    _pickuporderlist = newValue;
    print("logon here now");
    print(_pickuporderlist);
    notifyListeners();
  }

  void setstagep(int newValue) {
    _stage = newValue;
    print("logon here now");
    // print(_pickuporder.name);
    notifyListeners();
  }

  void adminusernameset(String token) async {
    Model1DTO model1dto = await _restdataService.getadminusername(token);
    _adminuser = model1dto.username;
    _adminphone = model1dto.phone;
    print("admin - $_adminuser");
    print("admin phone - $_adminphone");
    notifyListeners();
  }
  // void accounts(String username) async {
  //   _account = await _restdataService.getloggedin(username);
  //   print("account -");
  //   print(account.notifyCount);
  //   notifyListeners();
  // }

  // void usernameset(String newValue) {
  //   _logonusername = newValue;
  //   print("logon here now");
  //   print(_logonusername);

  //   notifyListeners();
  // }

  // set prevSearchTerm(String newValue) {
  //   _prevSearchTerm = newValue;
  // }
}
