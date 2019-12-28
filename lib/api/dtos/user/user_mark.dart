import 'package:flutter/material.dart';
import 'package:pr0gramm/entities/base_types/enum.dart';

const _userMarkData = [
  const _UserMarkData(name: "Schwuchtel", color: Color(0xffffffff)),
  const _UserMarkData(name: "Neuschwuchtel", color: Color(0xffe108e9)),
  const _UserMarkData(name: "Altschwuchtel", color: Color(0xff5bb91c)),
  const _UserMarkData(name: "Administrator", color: Color(0xffff9900)),
  const _UserMarkData(name: "Gebannt", color: Color(0xff444444)),
  const _UserMarkData(name: "Moderator", color: Color(0xff008fff)),
  const _UserMarkData(name: "Fliesentisch", color: Color(0xff6c432b)),
  const _UserMarkData(name: "LebendeLegende", color: Color(0xff1cb992)),
  //content:'\25C6';margin-left:0.4em;}
  const _UserMarkData(name: "Wichtel", color: Color(0xffd23c22)),
  //content:'\25A7';margin-left:0.4em;}
  const _UserMarkData(name: "EdlerSpender", color: Color(0xff1cb992)),
  const _UserMarkData(name: "Mittelaltschwuchtel", color: Color(0xffaddc8d)),
  const _UserMarkData(name: "Altmoderator", color: Color(0xff7fc7ff)),
  const _UserMarkData(name: "Communityhelfer", color: Color(0xffc52b2f)),
  // content:'\2764';margin-left:0.4em;}
  const _UserMarkData(name: "Nutzerbot", color: Color(0xff10366f)),
  const _UserMarkData(name: "Systembot", color: Color(0xffffc166))
];

class _UserMarkData {
  final String name;
  final Color color;

  const _UserMarkData({this.name, this.color});
}

class UserMark extends Enum<int> {
  static UserMark schwuchtel = UserMark(0);
  static UserMark neuschwuchtel = UserMark(1);
  static UserMark altschwuchtel = UserMark(2);
  static UserMark administrator = UserMark(3);
  static UserMark gebannt = UserMark(4);
  static UserMark moderator = UserMark(5);
  static UserMark fliesentisch = UserMark(6);
  static UserMark lebendeLegende = UserMark(7);
  static UserMark wichtel = UserMark(8);
  static UserMark edlerSpender = UserMark(9);
  static UserMark mittelaltschwuchtel = UserMark(10);
  static UserMark altmoderator = UserMark(11);
  static UserMark communityhelfer = UserMark(12);
  static UserMark nutzerbot = UserMark(13);
  static UserMark systembot = UserMark(14);

  UserMark(int val)
      : _data = _userMarkData[val],
        super(val);

  final _UserMarkData _data;

  Color get color => _data.color;

  String get name => _data.name;
}
