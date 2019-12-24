import 'package:pr0gramm/api/dtos/comment/liked_profile_comment.dart';
import 'package:pr0gramm/api/dtos/comment/profile_comment.dart';
import 'package:pr0gramm/api/dtos/item/liked_item.dart';
import 'package:pr0gramm/api/dtos/item/profile_upload_item.dart';
import 'package:pr0gramm/api/dtos/user/profile_badge.dart';
import 'package:pr0gramm/api/dtos/user/user.dart';

class ProfileInfo {
  User user;
  List<ProfileComment> comments;
  int commentCount;
  List<LikedProfileComment> commentsLikes;
  int commentLikesCount;
  List<ProfileUploadItem> uploads;
  int uploadCount;
  bool likesArePublic;
  List<LikedItem> likes;
  int likeCount;
  int tagCount;
  List<ProfileBadge> badges;
  int followCount;
  bool following;
  bool subscribed;
  int ts;
  Null cache;
  int rt;
  int qc;

  ProfileInfo({
    this.user,
    this.comments,
    this.commentCount,
    this.commentsLikes,
    this.commentLikesCount,
    this.uploads,
    this.uploadCount,
    this.likesArePublic,
    this.likes,
    this.likeCount,
    this.tagCount,
    this.badges,
    this.followCount,
    this.following,
    this.subscribed,
    this.ts,
    this.cache,
    this.rt,
    this.qc,
  });

  ProfileInfo.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['comments'] != null) {
      comments = new List<ProfileComment>();
      json['comments'].forEach((v) {
        comments.add(new ProfileComment.fromJson(v));
      });
    }
    commentCount = json['commentCount'];
    if (json['comments_likes'] != null) {
      commentsLikes = new List<LikedProfileComment>();
      json['comments_likes'].forEach((v) {
        commentsLikes.add(new LikedProfileComment.fromJson(v));
      });
    }
    commentLikesCount = json['commentLikesCount'];
    if (json['uploads'] != null) {
      uploads = new List<ProfileUploadItem>();
      json['uploads'].forEach((v) {
        uploads.add(new ProfileUploadItem.fromJson(v));
      });
    }
    uploadCount = json['uploadCount'];
    likesArePublic = json['likesArePublic'];
    if (json['likes'] != null) {
      likes = new List<LikedItem>();
      json['likes'].forEach((v) {
        likes.add(new LikedItem.fromJson(v));
      });
    }
    likeCount = json['likeCount'];
    tagCount = json['tagCount'];
    if (json['badges'] != null) {
      badges = new List<ProfileBadge>();
      json['badges'].forEach((v) {
        badges.add(new ProfileBadge.fromJson(v));
      });
    }
    followCount = json['followCount'];
    following = json['following'];
    subscribed = json['subscribed'];
    ts = json['ts'];
    cache = json['cache'];
    rt = json['rt'];
    qc = json['qc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    data['commentCount'] = this.commentCount;
    if (this.commentsLikes != null) {
      data['comments_likes'] =
          this.commentsLikes.map((v) => v.toJson()).toList();
    }
    data['commentLikesCount'] = this.commentLikesCount;
    if (this.uploads != null) {
      data['uploads'] = this.uploads.map((v) => v.toJson()).toList();
    }
    data['uploadCount'] = this.uploadCount;
    data['likesArePublic'] = this.likesArePublic;
    if (this.likes != null) {
      data['likes'] = this.likes.map((v) => v.toJson()).toList();
    }
    data['likeCount'] = this.likeCount;
    data['tagCount'] = this.tagCount;
    if (this.badges != null) {
      data['badges'] = this.badges.map((v) => v.toJson()).toList();
    }
    data['followCount'] = this.followCount;
    data['following'] = this.following;
    data['subscribed'] = this.subscribed;
    data['ts'] = this.ts;
    data['cache'] = this.cache;
    data['rt'] = this.rt;
    data['qc'] = this.qc;
    return data;
  }
}
