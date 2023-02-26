class Pickorders {
  int? _id;
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
  String? _amount;
  String? _comments;
  String? _payment;
  String? _date;
  int? _statno;
  String? _driverid;
  String? _email;
  String? _lat1;
  String? _long1;
  String? _lat2;
  String? _long2;

  Pickorders(
      this._id,
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
      this._amount,
      this._comments,
      this._payment,
      this._date,
      this._statno,
      this._driverid,
      this._email,
      this._lat1,
      this._long1,
      this._lat2,
      this._long2,
      );

  Pickorders.map(dynamic obj) {
    this._id = obj['id'];
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
    this._amount = obj['amount'];
    this._comments = obj['comments'];
    this._payment = obj['payment'];
    this._date = obj['date'];
    this._statno = obj['statno'];
    this._driverid = obj['driverid'];
    this._email = obj['email'];
    this._lat1 = obj['address1Latitude'];
    this._long1= obj['address1Longitude'];
    this._lat2= obj['address2Latitude'];
    this._long2= obj['address2Longitude'];

  }
  int? get id => _id;
  String? get name => _name;
  String? get address => _address;
  String? get phone => _phone;
  String? get mobilephone => _mobilephone;
  String? get pcategory => _pcategory;
  String? get packages => _packages;
  String? get description => _description;
  String? get youurlocation => _youurlocation;
  String? get senderlocation => _senderlocation;
  double? get distance => _distance;
  String? get amount => _amount;
  String? get comments => _comments;
  String? get payment => _payment;
  String? get date => _date;
  int? get statno => _statno;
  String? get driverid => _driverid;
  String? get email => _email;
  String? get lat1 =>_lat1;
  String? get long1 =>_long1;
  String? get lat2 =>_lat2;
  String? get long2 =>_long2;


  void setphone(String phone) {
    _phone = phone;
  }

  void setMail(String mail) {
    _email = mail;
  }

  void setDriverid(String id) {
    _driverid = id;
  }

  void setprice(String price) {
    _amount = price;
  }

  void setcomments(String comments) {
    _comments = comments;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = _id;
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
    map["amount"] = _amount;
    map["comments"] = _comments;
    map["payment"] = _payment;
    map["date"] = _date;
    map["statno"] = _statno;
    map["driverid"] = _driverid;
    map["email"] = _email;
    map["address1Latitude"] = _lat1;
    map["address1Longitude"] = _long1;
    map["address2Latitude"] = _lat2;
    map["address2Longitude"] = _long2;
    return map;
  }

  factory Pickorders.fromJson(Map<String, dynamic> data) {
    return Pickorders(
      data["id"],
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
      data["amount"],
      data["comments"],
      data["payment"],
      data["date"],
      data["statno"],
      data["driverid"],
      data["email"],
      data["address1Latitude"],
      data["address1Longitude"],
      data["address2Latitude"],
      data["address2Longitude"],

    );
  }
}
