import 'package:pr0gramm/api/dtos/comment/profile_comment.dart';

class LikedProfileComment extends ProfileComment {
  int ccreated;
  int userId;
  int mark;
  String name;

  LikedProfileComment({
    this.ccreated,
    this.userId,
    this.mark,
    this.name,
    int itemId,
    String thumb,
    String content,
    int id,
    int created,
    int up,
    int down,
  }) : super(
            itemId: itemId,
            thumb: thumb,
            content: content,
            id: id,
            created: created,
            up: up,
            down: down);

  LikedProfileComment.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    this.ccreated = json['ccreated'];
    this.userId = json['userId'];
    this.mark = json['mark'];
    this.name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['ccreated'] = this.ccreated;
    data['userId'] = this.userId;
    data['mark'] = this.mark;
    data['name'] = this.name;
    return data;
  }
}
