class Comment {
  int id;
  String content;
  int up;
  int down;
  int created;

  Comment({
    this.content,
    this.id,
    this.created,
    this.up,
    this.down,
  });

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    up = json['up'];
    down = json['down'];
    content = json['content'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['up'] = this.up;
    data['down'] = this.down;
    data['content'] = this.content;
    data['created'] = this.created;
    return data;
  }
}
