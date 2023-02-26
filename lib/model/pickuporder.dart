class Pickuporder {
  String? _name;
  String? _address;
  String? _phone;
  String? _mobilephone;
  String? _pcategory;
  String? _packages;
  String? _description;
  String? _youurlocation;
  String? _senderlocation;
  double? _distance;
  String? _lat1;
  String? _long1;
  String? _lat2;
  String? _long2;


  Pickuporder(
      this._name,
      this._address,
      this._phone,
      this._mobilephone,
      this._pcategory,
      this._packages,
      this._description,
      this._youurlocation,
      this._senderlocation,
      this._distance,
      this._lat1,
      this._long1,
      this._lat2,
      this._long2,

      );

  Pickuporder.map(dynamic obj) {
    this._name = obj['name'];
    this._address = obj['address'];
    this._phone = obj['phone'];
    this._mobilephone = obj['mobilephone'];
    this._pcategory = obj['pcategory'];
    this._packages = obj['packages'];
    this._description = obj['desc'];
    this._youurlocation = obj['youurlocation'];
    this._senderlocation = obj['senderlocation'];
    this._distance = obj['distance'];
    this._lat1 = obj['address1Latitude'];
    this._long1= obj['address1Longitude'];
    this._lat2= obj['address2Latitude'];
    this._long2= obj['address2Longitude'];
  }

  String? get name => _name;
  String? get address => _address;
  String? get phone => _phone;
  String? get mobilephone => _mobilephone;
  String? get pcategory => _pcategory;
  String? get packages => _packages;
  String? get desc => _description;
  String? get youurlocation => _youurlocation;
  String? get senderlocation => _senderlocation;
  double? get distance => _distance;
  String? get lat1 =>_lat1;
  String? get long1 =>_long1;
  String? get lat2 =>_lat2;
  String? get long2 =>_long2;



  void setphone(String phone) {
    _phone = phone;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = _name;
    map["address"] = _address;
    map["phone"] = _phone;
    map["mobilephone"] = _mobilephone;
    map["pcategory"] = _pcategory;
    map["packages"] = _packages;
    map["description"] = _description;
    map["youurlocation"] = _youurlocation;
    map["senderlocation"] = _senderlocation;
    map["distance"] = _distance;
    map["address1Latitude"] = _lat1;
    map["address1Longitude"] = _long1;
    map["address2Latitude"] = _lat2;
    map["address2Longitude"] = _long2;

    return map;
  }

  factory Pickuporder.fromJson(Map<String, dynamic> data) {
    return Pickuporder(
      data["name"],
      data["address"],
      data["phone"],
      data["mobilephone"],
      data["pcategory"],
      data["packages"],
      data["description"],
      data["youurlocation"],
      data["senderlocation"],
      data["distance"],
      data["address1Latitude"],
      data["address1Longitude"],
      data["address2Latitude"],
      data["address2Longitude"],

    );
  }
}
