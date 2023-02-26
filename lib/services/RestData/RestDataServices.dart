import 'package:courierx/data/rest_data.dart';
import 'package:courierx/model/ChatMessage.dart';
import 'package:courierx/model/pickuporder.dart';
import 'dart:async';
import 'package:courierx/model/pickorders.dart';
import 'package:courierx/model/user.dart';
import 'package:courierx/model/account.dart';
import 'package:courierx/model/notification.dart';
import 'package:courierx/model/adminuser.dart';

abstract class RestDataService {
  Future<String> login(String username, String password);
  Future<Account> accountget(String username, String password);
  Future<String> createnewaccount({Map body});
  Future<Account> createaccountget({Map body});
  Future<String> createphone({Map body});
  Future<Account> getloggedin(String username);
  Account getloggedaccount(String username);
  Future<Pickorders> createpickuporders(String token, {Map body});
  Future<String> changepassword(String token, {Map body});
  Future<Account> editprofile(String token, {Map body});
  Future<Pickorders> pickupprice(String token, {Map body});
  Future<List<Pickorders>> getorders(String token, {Map body});
  Future<List<Notifications>> getnotify(String token, {Map body});
  Future<Notifications> deleteprofile(String token, {Map body});
  Future<Account> editphoto(
      String token, String email, String path, String name);
  Future<Model1DTO> getadminusername(String token, {Map body});
  Future<List<ChatMessage>> getmessage(String token, String url, {Map body});
}
