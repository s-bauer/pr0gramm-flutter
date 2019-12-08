import 'package:pr0gramm/entities/commonTypes/comment/comment.dart';
import 'package:pr0gramm/entities/commonTypes/userMark.dart';

class ItemComment extends Comment {
  int parent;
  String name;
  UserMark mark;
  double confidence;

  ItemComment({
    this.name,
    this.confidence,
    this.parent,
    this.mark,
    String content,
    int id,
    int created,
    int up,
    int down,
  }) : super(content: content, id: id, created: created, up: up, down: down);

  ItemComment.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    this.parent = json['parent'];
    this.name = json['name'];
    this.mark = UserMark(json['mark']);
    this.confidence = json['confidence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['parent'] = this.parent;
    data['name'] = this.name;
    data['mark'] = this.mark.value;
    data['confidence'] = this.confidence;
    return data;
  }
}
