class CreateAccountM {
  late String _username;
  late String _email;
  String _password = '';

  CreateAccountM(
    this._username,
    this._email,
    this._password,
  );

  CreateAccountM.map(dynamic obj) {
    this._username = obj['username'];
    this._email = obj['email'];
    this._password = obj['password'];
  }

  String get userName => _username;
  String get email => _email;
  String get password => _password;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["email"] = _email;
    map["password"] = _password;

    return map;
  }

  factory CreateAccountM.fromJson(Map<String, dynamic> data) {
    return CreateAccountM(
      data["username"],
      data["email"],
      data["pasword"],
    );
  }
}
