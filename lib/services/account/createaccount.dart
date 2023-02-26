import 'dart:async';
import 'package:courierx/model/account.dart';

abstract class CreateAccountServices {
  Future<String> addNewAccount(String username, String email, String password);
  Future<String> addAPhone({Map body});
  Future<String> login(String username, String password);
  Future<String> chnagepassword(String token, String email, String oldpassword,
      String newpassword, String confirmpassword);
  Future<Account> editprofile(
      String token, String name, String email, String phone);
}
