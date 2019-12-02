class ItemInfoResponse {
  String cache;
  int ts;
  int rt;
  int qc;
  List<Comment> comments;
  List<Tag> tags;

  ItemInfoResponse({this.cache, this.ts, this.rt, this.qc, this.comments, this.tags});

  ItemInfoResponse.fromJson(Map<String, dynamic> json) {
    this.cache = json['cache'];
    this.ts = json['ts'];
    this.rt = json['rt'];
    this.qc = json['qc'];
    this.comments = (json['comments'] as List)!=null?(json['comments'] as List).map((i) => Comment.fromJson(i)).toList():null;
    this.tags = (json['tags'] as List)!=null?(json['tags'] as List).map((i) => Tag.fromJson(i)).toList():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cache'] = this.cache;
    data['ts'] = this.ts;
    data['rt'] = this.rt;
    data['qc'] = this.qc;
    data['comments'] = this.comments != null?this.comments.map((i) => i.toJson()).toList():null;
    data['tags'] = this.tags != null?this.tags.map((i) => i.toJson()).toList():null;
    return data;
  }

}

class Comment {
  String content;
  String name;
  double confidence;
  int id;
  int parent;
  int created;
  int up;
  int down;
  int mark;

  Comment({this.content, this.name, this.confidence, this.id, this.parent, this.created, this.up, this.down, this.mark});

  Comment.fromJson(Map<String, dynamic> json) {
    this.content = json['content'];
    this.name = json['name'];
    this.confidence = json['confidence'];
    this.id = json['id'];
    this.parent = json['parent'];
    this.created = json['created'];
    this.up = json['up'];
    this.down = json['down'];
    this.mark = json['mark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['name'] = this.name;
    data['confidence'] = this.confidence;
    data['id'] = this.id;
    data['parent'] = this.parent;
    data['created'] = this.created;
    data['up'] = this.up;
    data['down'] = this.down;
    data['mark'] = this.mark;
    return data;
  }
}

class Tag {
  String tag;
  double confidence;
  int id;

  Tag({this.tag, this.confidence, this.id});

  Tag.fromJson(Map<String, dynamic> json) {
    this.tag = json['tag'];
    this.confidence = json['confidence'];
    this.id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag'] = this.tag;
    data['confidence'] = this.confidence;
    data['id'] = this.id;
    return data;
  }
}