import 'dart:math';

import 'package:courierx/model/pickuporder.dart';
import 'package:courierx/services/RestData/RestDataServices.dart';
import 'package:courierx/services/pickup/requestpickup.dart';
import 'package:courierx/model/pickorders.dart';
import '../../servicelocator.dart';

// This class is the concrete implementation of [CurrencyService]. It is a
// wrapper around the WebApi and StorageService services. This way the view models
// don't actually have to know anything about the web or storage details.
class RequestPickupImpl implements RequestPickup {
  RestDataService _restdataService = serviceLocator<RestDataService>();

  @override
  Future<Pickorders> addNewPickup(
    String name,
    String address,
    String phone,
    String mobilephone,
    String pcategory,
    String packages,
    String desc,
    String yourlocation,
    String senderlocation,
    String token,
    double distance,
    String lat1,
    String long1,
    String lat2,
    String long2,
  ) async {
    Pickuporder account = new Pickuporder(
        name,
        address,
        phone,
        mobilephone,
        pcategory,
        packages,
        desc,
        yourlocation,
        senderlocation,
        distance,
        lat1,
        long1,
        lat2,
        long2);

    Future<Pickorders> res =
        _restdataService.createpickuporders(token, body: account.toMap());
    print('requestpickupimpl addNewpickup${account.toMap()}');
    return res;
  }

  Future<Pickorders> addNewPrice(String token, Pickorders pickorders,
      String amount, String comments) async {
    //Pickuporder account = new Pickuporder();
    String payment = "Not Paid";
    Pickorders account = Pickorders(
        pickorders.id,
        pickorders.name,
        pickorders.address,
        pickorders.phone,
        pickorders.mobilephone,
        pickorders.pcategory,
        pickorders.packages,
        pickorders.description,
        pickorders.youurlocation,
        pickorders.senderlocation,
        pickorders.distance,
        amount,
        comments,
        payment,
        pickorders.date,
        1,
        pickorders.driverid,
        pickorders.email,
        pickorders.lat1,
      pickorders.long1,
      pickorders.lat2,
      pickorders.long2,

    );
    Future<Pickorders> res =
        _restdataService.pickupprice(token, body: account.toMap());
    print('requestpickupimpl addNewPrice${account.toMap()}');
    return res;
  }

  Future<List<Pickorders>> getorgers(String token, String email) async {
    //Pickuporder account = new Pickuporder();

    Future<List<Pickorders>> res =
        _restdataService.getorders(token, body: toMap(email));
    print("res");

    return res;
  }

  Future<Pickorders> addNewPaymentdone(
      String token, Pickorders pickorders) async {
    //Pickuporder account = new Pickuporder();
    String payment = "Paid";
    Pickorders account = new Pickorders(
        pickorders.id,
        pickorders.name,
        pickorders.address,
        pickorders.phone,
        pickorders.mobilephone,
        pickorders.pcategory,
        pickorders.packages,
        pickorders.description,
        pickorders.youurlocation,
        pickorders.senderlocation,
        pickorders.distance,
        pickorders.amount,
        pickorders.comments,
        payment,
        pickorders.date,
        1,
        pickorders.driverid,
        pickorders.email,
      pickorders.lat1,
      pickorders.long1,
      pickorders.lat2,
      pickorders.long2,
    );
    Future<Pickorders> res =
        _restdataService.pickupprice(token, body: account.toMap());
    print('requestpickupimpl addNewPaymentdone${account.toMap()}');
    return res;
  }

  Future<Pickorders> addNewPaymentdelivery(
      String token, Pickorders pickorders) async {
    //Pickuporder account = new Pickuporder();
    String payment = "Pay on Delivery";
    Pickorders account = new Pickorders(
        pickorders.id,
        pickorders.name,
        pickorders.address,
        pickorders.phone,
        pickorders.mobilephone,
        pickorders.pcategory,
        pickorders.packages,
        pickorders.description,
        pickorders.youurlocation,
        pickorders.senderlocation,
        pickorders.distance,
        pickorders.amount,
        pickorders.comments,
        payment,
        pickorders.date,
        1,
        pickorders.driverid,
        pickorders.email,
      pickorders.lat1,
      pickorders.long1,
      pickorders.lat2,
      pickorders.long2,
    );
    Future<Pickorders> res =
        _restdataService.pickupprice(token, body: account.toMap());
    print('requestpickupimpl addNewPaymentDelivery${account.toMap()}');
    return res;
  }

  @override
  // ignore: override_on_non_overriding_member
  Future<String> addAPhone({Map? body}) async {
    Future<String> res = _restdataService.createphone(body: body!);
    //print(account.toMap());
    return res;
  }

  @override
  Future<String> login(String username, String password) async {
    Future<String> res = _restdataService.login(username, password);
    //print(account.toMap());
    return res;
  }

  Map<String, dynamic> toMap(String email) {
    var map = new Map<String, dynamic>();
    // print(username);

    map["email"] = email;

    return map;
  }
}
