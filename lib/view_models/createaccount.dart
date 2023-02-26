import 'package:flutter/widgets.dart';
import 'package:courierx/model/account.dart';
import 'package:courierx/services/RestData/RestDataServices.dart';

import '../servicelocator.dart';

class CreateAccountViewModel extends ChangeNotifier {
  // static CreateAccountProvider of(BuildContext context, {bool listen = true}) =>
  //     Provider.of<CreateAccountProvider>(context, listen: listen);

  // String _prevSearchTerm = "";

  RestDataService _restdataService = serviceLocator<RestDataService>();
  String _logonemail = "";
  String _logonusername = "";
  String _token = "";
  Account? _account;

//  String get prevSearchTerm => _prevSearchTerm;
  String get logonemail => _logonemail;
  String get token => _token;
  String get logonusername => _logonusername;
  Account? get account => _account;

  void logonemailset(String newValue) {
    _logonemail = newValue;
    print("logon here now");
    print(_logonemail);
    notifyListeners();
  }

  void tokenset(String newValue) {
    _token = newValue;
    print("tokenset- logon here now");
    print(_token);
    notifyListeners();
  }

  Future<bool> accounts(String username) async {
    try {
      _account = await _restdataService.getloggedin(username);

      print("create account - notify count${account?.notifyCount}");
      print("create account - email${account?.email}");
      notifyListeners();
      return true;
    } catch (e) {
      print("createaccount.dart error in accounts notyfyer");
      return false;
    }
  }

  void usernameset(String newValue) {
    _logonusername = newValue;
    print("usernameset- logon here now");
    print(_logonusername);

    notifyListeners();
  }

  // set prevSearchTerm(String newValue) {
  //   _prevSearchTerm = newValue;
  // }
}
