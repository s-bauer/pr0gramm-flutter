import 'package:pr0gramm/entities/commonTypes/comment/comment.dart';

class ProfileComment extends Comment {
  int itemId;
  String thumb;

  ProfileComment({
    this.itemId,
    this.thumb,
    String content,
    int id,
    int created,
    int up,
    int down,
  }) : super(content: content, id: id, created: created, up: up, down: down);

  ProfileComment.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.itemId = json['itemId'];
    this.thumb = json['thumb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['itemId'] = this.itemId;
    data['thumb'] = this.thumb;
    return data;
  }
}
