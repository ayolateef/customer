class Account {
  late String _userName;
  late String _email;
  late String _phone;
  late String _userAvatar;
  late String _userAvatarInternet;
  late String _gender;
  late String _dateOfBirth;

  late int _notifyCount ;
  late int _inBasket ;

  Account(
      this._userName,
      this._email,
      this._phone,
      this._userAvatar,
      this._userAvatarInternet,
      this._gender,
      this._dateOfBirth,
      this._inBasket,
      this._notifyCount);

  Account.map(dynamic obj) {
    this._userName = obj['username'];
    this._email = obj['email'];
    this._phone = obj['phone']; //
    this._userAvatar = obj['useravatar'];
    this._userAvatarInternet = obj['userAvatarInternet'];
    this._gender = obj['gender'];
    this._dateOfBirth = obj['dateOfBirth'];
    this._notifyCount = obj['notifyCount'];
    this._inBasket = obj['inBasket'];
  }

  String get userName => _userName;
  String get email => _email;
  String get phone => _phone;
  String get userAvatar => _userAvatar;
  String get userAvatarInternet => _userAvatarInternet;
  String get gender => _gender;
  String get dateOfBirth => _dateOfBirth;
  int get notifyCount => _notifyCount;
  int get inBasket => _inBasket;

  void setphone(String phone) {
    _phone = phone;
  }

  void setavatar(String image) {
    _userAvatar = image;
  }

  void setavatarinternet(String image) {
    _userAvatarInternet = image;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["userName"] = _userName;
    map["email"] = _email;
    map["phone"] = _phone;
    map["userAvatar"] = _userAvatar;
    map["userAvatarInternet"] = _userAvatarInternet;
    map["gender"] = _gender;
    map["dateOfBirth"] = _dateOfBirth;
    map["notifyCount"] = _notifyCount;
    map["inBasket"] = _inBasket;
    return map;
  }

  factory Account.fromJson(Map<String, dynamic> data) {
    return Account(
      data["userName"],
      data["email"],
      data["phone"],
      data["userAvatar"],
      data["userAvatarInternet"],
      data["gender"],
      data["dateOfBirth"],
      data["notifyCount"],
      data["inBasket"],
    );
  }
}
