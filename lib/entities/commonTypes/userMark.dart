import 'package:flutter/material.dart';
import 'package:pr0gramm/entities/commonTypes/baseTypes/enum.dart';

const _userMarkData = [
  const UserMarkData(name: "Schwuchtel", color: Color(0xffffffff)),
  const UserMarkData(name: "Neuschwuchtel", color: Color(0xffe108e9)),
  const UserMarkData(name: "Altschwuchtel", color: Color(0xff5bb91c)),
  const UserMarkData(name: "Administrator", color: Color(0xffff9900)),
  const UserMarkData(name: "Gebannt", color: Color(0xff444444)),
  const UserMarkData(name: "Moderator", color: Color(0xff008fff)),
  const UserMarkData(name: "Fliesentisch", color: Color(0xff6c432b)),
  const UserMarkData(name: "LebendeLegende", color: Color(0xff1cb992)), //content:'\25C6';margin-left:0.4em;}
  const UserMarkData(name: "Wichtel", color: Color(0xffd23c22)), //content:'\25A7';margin-left:0.4em;}
  const UserMarkData(name: "EdlerSpender", color: Color(0xff1cb992)),
  const UserMarkData(name: "Mittelaltschwuchtel", color: Color(0xffaddc8d)),
  const UserMarkData(name: "Altmoderator", color: Color(0xff7fc7ff)),
  const UserMarkData(name: "Communityhelfer", color: Color(0xffc52b2f)), // content:'\2764';margin-left:0.4em;}
  const UserMarkData(name: "Nutzerbot", color: Color(0xff10366f)),
  const UserMarkData(name: "Systembot", color: Color(0xffffc166))
];

class UserMarkData {
  final String name;
  final Color color;

  const UserMarkData({this.name, this.color});
}

class UserMark extends Enum<int> {
  static UserMark Schwuchtel = UserMark(0);
  static UserMark Neuschwuchtel = UserMark(1);
  static UserMark Altschwuchtel = UserMark(2);
  static UserMark Administrator = UserMark(3);
  static UserMark Gebannt = UserMark(4);
  static UserMark Moderator = UserMark(5);
  static UserMark Fliesentisch = UserMark(6);
  static UserMark LebendeLegende = UserMark(7);
  static UserMark Wichtel = UserMark(8);
  static UserMark EdlerSpender = UserMark(9);
  static UserMark Mittelaltschwuchtel = UserMark(10);
  static UserMark Altmoderator = UserMark(11);
  static UserMark Communityhelfer = UserMark(12);
  static UserMark Nutzerbot = UserMark(13);
  static UserMark Systembot = UserMark(14);

  UserMark(int val) : _data = _userMarkData[val], super(val);

  final UserMarkData _data;

  Color get color => _data.color;
  String get name => _data.name;
}

