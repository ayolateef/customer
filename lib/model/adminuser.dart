class Model1DTO {
  late String _username;
  late String _phone;
 
  String get username => _username;
  String get phone => _phone;

  void setusername(String username) {
    _username = username;
  }

  void setphone(String phone) {
    _phone = phone;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["phone"] = _phone;
    return map;
  }

  Model1DTO.map(dynamic obj) {
    this._username = obj['username'];
    this._phone = obj['phone'];
  }
}
