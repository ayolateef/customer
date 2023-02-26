class Notifications {
  int? _id;
  String? _title;
  String? _text;
  String? _date;
  String? _image;
  String? _status;

  Notifications(this._id, this._title, this._text, this._date, this._image, this._status);


  Notifications.map(dynamic obj) {
    this._id = obj['id'];
    this._title = obj['title'];
    this._text = obj['text'];//
    this._date = obj['date'];
    this._image = obj['image'];
    this._status = obj['status'];

  }
  int? get id => _id;
  String? get title => _title;
  String? get text => _text;
  String? get date => _date;
  String? get image => _image;
  String? get status => _status;

    Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = _id;
    map["title"] = _title;
    map["text"] = _text;
    map["date"] = _date;
    map["image"] = _image;
    map["status"] = status;
  
    return map;
  }
   factory Notifications.fromJson(Map<String, dynamic> data) {
    return Notifications(
      data["id"],
      data["title"],
      data["text"],
      data["date"],
      data["image"],
      data["status"],
   
    );
  }
}