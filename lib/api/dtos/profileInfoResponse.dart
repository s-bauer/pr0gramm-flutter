class ProfileInfoResponse {
  User user;
  List<Comments> comments;
  int commentCount;
  List<CommentsLike> commentsLikes;
  int commentLikesCount;
  List<Uploads> uploads;
  int uploadCount;
  bool likesArePublic;
  List<Like> likes;
  int likeCount;
  int tagCount;
  List<Badges> badges;
  int followCount;
  bool following;
  bool subscribed;
  int ts;
  Null cache;
  int rt;
  int qc;

  ProfileInfoResponse(
      {this.user,
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
        this.qc});

  ProfileInfoResponse.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['comments'] != null) {
      comments = new List<Comments>();
      json['comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
    commentCount = json['commentCount'];
    if (json['comments_likes'] != null) {
      commentsLikes = new List<CommentsLike>();
      json['comments_likes'].forEach((v) {
        commentsLikes.add(new CommentsLike.fromJson(v));
      });
    }
    commentLikesCount = json['commentLikesCount'];
    if (json['uploads'] != null) {
      uploads = new List<Uploads>();
      json['uploads'].forEach((v) {
        uploads.add(new Uploads.fromJson(v));
      });
    }
    uploadCount = json['uploadCount'];
    likesArePublic = json['likesArePublic'];
    if (json['likes'] != null) {
      likes = new List<Like>();
      json['likes'].forEach((v) {
        likes.add(new Like.fromJson(v));
      });
    }
    likeCount = json['likeCount'];
    tagCount = json['tagCount'];
    if (json['badges'] != null) {
      badges = new List<Badges>();
      json['badges'].forEach((v) {
        badges.add(new Badges.fromJson(v));
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

class User {
  int id;
  String name;
  int registered;
  int score;
  int mark;
  int admin;
  int banned;
  int commentDelete;
  int itemDelete;
  int inactive;

  User(
      {this.id,
        this.name,
        this.registered,
        this.score,
        this.mark,
        this.admin,
        this.banned,
        this.commentDelete,
        this.itemDelete,
        this.inactive});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    registered = json['registered'];
    score = json['score'];
    mark = json['mark'];
    admin = json['admin'];
    banned = json['banned'];
    commentDelete = json['commentDelete'];
    itemDelete = json['itemDelete'];
    inactive = json['inactive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['registered'] = this.registered;
    data['score'] = this.score;
    data['mark'] = this.mark;
    data['admin'] = this.admin;
    data['banned'] = this.banned;
    data['commentDelete'] = this.commentDelete;
    data['itemDelete'] = this.itemDelete;
    data['inactive'] = this.inactive;
    return data;
  }
}

class Comments {
  int id;
  int up;
  int down;
  String content;
  int created;
  int itemId;
  String thumb;

  Comments(
      {this.id,
        this.up,
        this.down,
        this.content,
        this.created,
        this.itemId,
        this.thumb});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    up = json['up'];
    down = json['down'];
    content = json['content'];
    created = json['created'];
    itemId = json['itemId'];
    thumb = json['thumb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['up'] = this.up;
    data['down'] = this.down;
    data['content'] = this.content;
    data['created'] = this.created;
    data['itemId'] = this.itemId;
    data['thumb'] = this.thumb;
    return data;
  }
}

class CommentsLike {
  int id;
  int up;
  int down;
  String content;
  int created;
  int ccreated;
  int itemId;
  String thumb;
  int userId;
  int mark;
  String name;

  CommentsLike(
      {this.id,
        this.up,
        this.down,
        this.content,
        this.created,
        this.ccreated,
        this.itemId,
        this.thumb,
        this.userId,
        this.mark,
        this.name});

  CommentsLike.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    up = json['up'];
    down = json['down'];
    content = json['content'];
    created = json['created'];
    ccreated = json['ccreated'];
    itemId = json['itemId'];
    thumb = json['thumb'];
    userId = json['userId'];
    mark = json['mark'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['up'] = this.up;
    data['down'] = this.down;
    data['content'] = this.content;
    data['created'] = this.created;
    data['ccreated'] = this.ccreated;
    data['itemId'] = this.itemId;
    data['thumb'] = this.thumb;
    data['userId'] = this.userId;
    data['mark'] = this.mark;
    data['name'] = this.name;
    return data;
  }
}

class Uploads {
  int id;
  String thumb;

  Uploads({this.id, this.thumb});

  Uploads.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    thumb = json['thumb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['thumb'] = this.thumb;
    return data;
  }
}

class Badges {
  String link;
  String image;
  String description;
  int created;

  Badges({this.link, this.image, this.description, this.created});

  Badges.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    image = json['image'];
    description = json['description'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link'] = this.link;
    data['image'] = this.image;
    data['description'] = this.description;
    data['created'] = this.created;
    return data;
  }
}

class Like {
  int id;
  String thumb;

  Like({this.id, this.thumb});

  Like.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    thumb = json['thumb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['thumb'] = this.thumb;
    return data;
  }
}