import 'package:pr0gramm/entities/commonTypes/comment/itemComment.dart';
import 'package:pr0gramm/entities/commonTypes/tag.dart';

class ItemInfoResponse {
  String cache;
  int ts;
  int rt;
  int qc;
  List<ItemComment> comments;
  List<Tag> tags;

  ItemInfoResponse(
      {this.cache, this.ts, this.rt, this.qc, this.comments, this.tags});

  ItemInfoResponse.fromJson(Map<String, dynamic> json) {
    this.cache = json['cache'];
    this.ts = json['ts'];
    this.rt = json['rt'];
    this.qc = json['qc'];
    this.comments = (json['comments'] as List) != null
        ? (json['comments'] as List)
            .map((i) => ItemComment.fromJson(i))
            .toList()
        : null;
    this.tags = (json['tags'] as List) != null
        ? (json['tags'] as List).map((i) => Tag.fromJson(i)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cache'] = this.cache;
    data['ts'] = this.ts;
    data['rt'] = this.rt;
    data['qc'] = this.qc;
    data['comments'] = this.comments != null
        ? this.comments.map((i) => i.toJson()).toList()
        : null;
    data['tags'] =
        this.tags != null ? this.tags.map((i) => i.toJson()).toList() : null;
    return data;
  }
}
