import 'package:flutter/material.dart';
import 'package:pr0gramm/entities/commonTypes/baseTypes/enum.dart';

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

  UserMark(int val) : super(val);

  Color get color => _colors[value];

  String get name => _names[value];
}

const _colors = [
  Color(0xffffffff),
  Color(0xffe108e9),
  Color(0xff5bb91c),
  Color(0xffff9900),
  Color(0xff444444),
  Color(0xff008fff),
  Color(0xff6c432b),
  Color(0xff1cb992), //content:'\25C6';margin-left:0.4em;}
  Color(0xffd23c22), //content:'\25A7';margin-left:0.4em;}
  Color(0xff1cb992),
  Color(0xffaddc8d),
  Color(0xff7fc7ff),
  Color(0xffc52b2f), // content:'\2764';margin-left:0.4em;}
  Color(0xff10366f),
  Color(0xffffc166),
];

const _names = [
  "Schwuchtel",
  "Neuschwuchtel",
  "Altschwuchtel",
  "Administrator",
  "Gebannt",
  "Moderator",
  "Fliesentisch",
  "LebendeLegende",
  "Wichtel",
  "EdlerSpender",
  "Mittelaltschwuchtel",
  "Altmoderator",
  "Communityhelfer",
  "Nutzerbot",
  "Systembot",
];
