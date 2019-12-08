import 'package:pr0gramm/entities/commonTypes/user/commentUser.dart';
import 'package:pr0gramm/entities/commonTypes/userMark.dart';

class User extends CommentUser {
  int registered;
  int score;
  int admin;
  int itemDelete;
  int commentDelete;
  int inactive;
  int banned;

  User(
      {this.registered,
      this.score,
      this.admin,
      this.itemDelete,
      this.commentDelete,
      this.inactive,
      this.banned,
      int id,
      String name,
      UserMark mark})
      : super(
          id: id,
          name: name,
          mark: mark,
        );

  User.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    registered = json['registered'];
    score = json['score'];
    admin = json['admin'];
    banned = json['banned'];
    commentDelete = json['commentDelete'];
    itemDelete = json['itemDelete'];
    inactive = json['inactive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['registered'] = this.registered;
    data['score'] = this.score;
    data['admin'] = this.admin;
    data['banned'] = this.banned;
    data['commentDelete'] = this.commentDelete;
    data['itemDelete'] = this.itemDelete;
    data['inactive'] = this.inactive;
    return data;
  }
}
