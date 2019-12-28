import 'package:pr0gramm/api/dtos/comment/profile_comment.dart';
import 'package:pr0gramm/api/dtos/user/comment_user.dart';

class ProfileCommentBatch {
  List<ProfileComment> comments;
  bool hasOlder;
  bool hasNewer;
  CommentUser user;
  int ts;
  Null cache;
  int rt;
  int qc;

  ProfileCommentBatch(
      {this.comments,
        this.hasOlder,
        this.hasNewer,
        this.user,
        this.ts,
        this.cache,
        this.rt,
        this.qc});

  ProfileCommentBatch.fromJson(Map<String, dynamic> json) {
    if (json['comments'] != null) {
      comments = new List<ProfileComment>();
      json['comments'].forEach((v) {
        comments.add(new ProfileComment.fromJson(v));
      });
    }
    hasOlder = json['hasOlder'];
    hasNewer = json['hasNewer'];
    user = json['user'] != null ? new CommentUser.fromJson(json['user']) : null;
    ts = json['ts'];
    cache = json['cache'];
    rt = json['rt'];
    qc = json['qc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    data['hasOlder'] = this.hasOlder;
    data['hasNewer'] = this.hasNewer;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['ts'] = this.ts;
    data['cache'] = this.cache;
    data['rt'] = this.rt;
    data['qc'] = this.qc;
    return data;
  }
}
