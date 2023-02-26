import 'package:courierx/services/account/createaccount.dart';
import 'package:courierx/model/createaccount.dart';
import 'package:courierx/services/RestData/RestDataServices.dart';
import 'package:courierx/servicelocator.dart';
import 'package:courierx/model/account.dart';

// This class is the concrete implementation of [CurrencyService]. It is a
// wrapper around the WebApi and StorageService services. This way the view models
// don't actually have to know anything about the web or storage details.
class CreateAccountServicesImpl implements CreateAccountServices {
  late CreateAccountM account;
  RestDataService _restdataService = serviceLocator<RestDataService>();

  @override
  Future<String> addNewAccount(
      String username, String email, String password) async {
    CreateAccountM account = new CreateAccountM(username, email, password);

    Future<String> res =
        _restdataService.createnewaccount(body: account.toMap());
    print("yello");
    print(account.toMap());
    return res;
  }

  @override
  Future<String> addAPhone({Map? body}) async {
    Future<String> res = _restdataService.createphone(body: body!);
    print("yello");
    //print(account.toMap());
    return res;
  }

  @override
  Future<String> login(String username, String password) async {
    Future<String> res = _restdataService.login(username, password);
    print("yello");
    //print(account.toMap());
    return res;
  }

  Future<String> chnagepassword(String token, String email, String oldpassword,
      String newpassword, String confirmpassword) async {
    Future<String> res = _restdataService.changepassword(token,
        body: toMap2(email, oldpassword, newpassword, confirmpassword));
    print("yello");
    //print(account.toMap());
    return res;
  }

  Future<Account> editprofile(
      String token, String name, String email, String phone) async {
    Future<Account> res =
        _restdataService.editprofile(token, body: toMap3(name, email, phone));
    print("yello");
    //print(account.toMap());
    return res;
  }

  Map<String, dynamic> toMap2(String email, String oldpassword,
      String newpassword, String confirmpassword) {
    var map = new Map<String, dynamic>();
    print("map for ddd");
    // print(username);
    map["email"] = email;
    map["oldpassword"] = oldpassword;
    map["newpassword"] = newpassword;
    map["confirmpassword"] = confirmpassword;

    return map;
  }

  Map<String, dynamic> toMap3(String name, String email, String phone) {
    var map = new Map<String, dynamic>();
    print("map for ddd");
    // print(username);
    map["name"] = name;
    map["email"] = email;
    map["phone"] = phone;

    return map;
  }
}
