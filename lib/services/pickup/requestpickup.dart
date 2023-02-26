import 'package:courierx/model/pickuporder.dart';
import 'package:courierx/model/pickorders.dart';

abstract class RequestPickup {
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
      );
  Future<Pickorders> addNewPrice(
      String token, Pickorders pickorders, String amount, String comments);
  Future<Pickorders> addNewPaymentdone(String token, Pickorders pickorders);
  Future<Pickorders> addNewPaymentdelivery(String token, Pickorders pickorders);
  Future<List<Pickorders>> getorgers(String token, String email);
}
