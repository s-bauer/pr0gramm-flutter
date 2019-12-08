class Tag {
  int id;
  String tag;
  double confidence;

  Tag({
    this.id,
    this.tag,
    this.confidence,
  });

  Tag.fromJson(Map<String, dynamic> json) {
    this.tag = json['tag'];
    this.confidence = 0.0 + json['confidence'];
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
