class LikedItem {
  int id;
  String thumb;

  LikedItem({this.id, this.thumb});

  LikedItem.fromJson(Map<String, dynamic> json) {
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
