class ProfileBadge {
  String link;
  String image;
  String description;
  int created;

  ProfileBadge({this.link, this.image, this.description, this.created});

  ProfileBadge.fromJson(Map<String, dynamic> json) {
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
