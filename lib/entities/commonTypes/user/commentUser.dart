import 'package:pr0gramm/entities/commonTypes/userMark.dart';

class CommentUser {
  int id;
  String name;
  UserMark mark;

  CommentUser({
    this.id,
    this.name,
    this.mark,
  });

  CommentUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mark = UserMark(json['mark']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mark'] = this.mark;
    return data;
  }
}
