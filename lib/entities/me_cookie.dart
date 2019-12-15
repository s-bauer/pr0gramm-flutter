import 'dart:convert';

class MeCookie {
  String name;
  String id;
  int a;
  String pp;
  bool paid;

  MeCookie({this.name, this.id, this.a, this.pp, this.paid});

  MeCookie.fromJson(Map<String, dynamic> json) {
    name = json['n'];
    id = json['id'];
    a = json['a'];
    pp = json['pp'];
    paid = json['paid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['n'] = this.name;
    data['id'] = this.id;
    data['a'] = this.a;
    data['pp'] = this.pp;
    data['paid'] = this.paid;
    return data;
  }

  MeCookie.fromUrlEncodedJson(String urlEncodedMeCookie)
      : this.fromJson(json.decode(Uri.decodeFull(urlEncodedMeCookie)));
}